import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:frapp/features/auth/data/services/camera_service.dart';
import 'package:image/image.dart' as img;
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:frapp/features/auth/data/services/storage_service.dart';

class FaceRecognitionService {
  //this calss to Detecting faces, Converting face to embedding, and Saving & comparing embeddings
  static final FaceRecognitionService _instance =
      FaceRecognitionService._internal();
  //This line creates and stores a single instance of the class, instance. It runs only once when the app starts
  factory FaceRecognitionService() => _instance;
  //this Constructor it's create for one time and create instance object for one time
  //so you sure there is only one FaceRecognitionService used in the whole app (singleton pattern)
  FaceRecognitionService._internal();
//FaceRecognitionService.internal: This is a private constructor
  //internal: It's used to create the instance only once internally
  late Interpreter _interpreter;
  //interpreter: Runs the TFLite face embedding model(make the TFLite work)
  final _faceDetector = FaceDetector(options: FaceDetectorOptions());
  //faceDetector: Detects faces using Google ML Kit
  final _storageService = StorageService();
  //storageService: storageService: Manages saving or loading embeddings
  bool _isInitialized = false;
  //isInitialized: Ensures the model loads only once(so initailize it)
  List<Map<String, dynamic>>? _cachedFaces;
//cachedFaces: In memory cache of known faces from storage
  Future<void> initialize() async {
    if (_isInitialized) return;
    //if the model is initialize so getout from this method because you don't need to initialize, if the model doesn't initialize so start initialize it
    final interpreterOptions = InterpreterOptions();
    _interpreter = await Interpreter.fromAsset('assets/mobilefacenet.tflite',
        options: interpreterOptions);
    //Loads the MobileFaceNet model(.tflite) from assets
    _cachedFaces = await _storageService.getFaces(); //saved face
    _isInitialized = true;
    //now the method is initialized
  }

  static List prepareInputFromNV21(Map<String, dynamic> params) {
    //used this method when input comes from the live camera(NV21 format)
    final nv21Data = params['nv21Data'] as Uint8List;
    //nv21Data: expresses format or bytes in camera
    final width = params['width'] as int;
    //width in the camera(i mean when you appear the camera and you see your camera will display things from left and right so this is width the camera like the eyes)
    final height = params['height'] as int;
    //height in the camera(i mean when you appear the camera and you see your camera will display things from top and bottom so this is height the camera like the eyes)
    final isFrontCamera = params['isFrontCamera'] as bool;
    //this parameter to check from camera is front or back
    final face = params['face'] as Face;
    //face will appear in the camera
    img.Image image = CameraService.convertNV21ToImage(nv21Data, width, height);
    //i use method from CameraService and this method is convertNV21ToImage
    image = img.copyRotate(image, angle: isFrontCamera ? -90 : 90);
    //i rotate the image(90 or -90) based on type the camera(front or back)
    return prepareInput(image, face);
    //i send image and face parameter to method(prepareInput) responsible on crop, resize,.. the image, should be the image perfectly before make the AI see it
  }

  static List prepareInputFromImagePath(Map<String, dynamic> params) {
    //Used this method when face image comes from gallery or file path
    final imgPath = params['imgPath'] as String;
    final face = params['face'] as Face;
    img.Image image = img.decodeImage(File(imgPath).readAsBytesSync())!;
    //decode the image from String type to File type and read the image from file
    return prepareInput(image, face);
    //i send image and face parameter to method(prepareInput) responsible on crop, resize,.. the image, should be the image perfectly before make the AI see it
  }

  static List prepareInput(img.Image image, Face face) {
    //this method can Crops and resizes the face from image
    int x, y, w, h;
    x = face.boundingBox.left.round();
    y = face.boundingBox.top.round();
    w = face.boundingBox.width.round();
    h = face.boundingBox.height.round();
//Gets face position from red rectangle
    img.Image faceImage = img.copyCrop(image, x: x, y: y, width: w, height: h);
    //crop the face
    img.Image resizedImage = img.copyResizeCropSquare(faceImage, size: 112);
//resize the face after crop
    List input = _imageToByteListFloat32(resizedImage, 112, 127.5, 127.5);
    //resizedImage(The face image resized to 112x112 pixels), 112(The size of the input image (112x112)), 127.5(Mean: The average value of pixels (used to normalize)), 127.5(Std Dev(Used to divide the result, for normalization))
    input = input.reshape([1, 112, 112, 3]);
    //This code prepares the image data in a format that the MobileFaceNet TFLite model expects, Shape: [1, 112, 112, 3] → (1 image, 112x112 pixels, 3 color channels)
    return input;
  }

  List<double> getEmbedding(List input) {
    List output = List.generate(1, (_) => List.filled(192, 0));
    _interpreter.run(input, output);
    return output[0].cast<double>();
    //this elements in two lists(input and output) it's represents face the students, ai programmer using math(numbers) to make the ai understand them and this numbers it's face to human
    //output[0] because i generate just element, because i use this method to generate student student not all students together
  }

  static List _imageToByteListFloat32(
      img.Image image, int size, double mean, double std) {
    //this method Converts image pixels to float list
    var convertedBytes = Float32List(1 * size * size * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    //Creates a float array to store RGB values
    int pixelIndex = 0;
    for (var i = 0; i < size; i++) {
      for (var j = 0; j < size; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = (pixel.r - mean) / std;
        buffer[pixelIndex++] = (pixel.g - mean) / std;
        buffer[pixelIndex++] = (pixel.b - mean) / std;
      }
      //do some operations to convert all thing in the image to bytes
    }
    return convertedBytes.toList();
  }

  Future<void> registerFace(String name, List embedding) async {
    //this method to Saves the embedding face with the person’s name in storage
    await _storageService.saveFace(name, embedding);
    //save this face to make the ai know it
    _cachedFaces = await _storageService.getFaces();
    //cache the face to make the ai always know this face if you don't delete it
  }

  Future<String> identifyFace(List<double> embedding,
      {double threshold = 0.8}) async {
    //this method Compares new face's embedding with old face's embedding, and detect the face
    _cachedFaces ??= await _storageService.getFaces();
    //if cachedFaces is null so give cachedFaces this value(await _storageService.getFaces();) else so don't give it any value
    double minDistance = double.maxFinite;
    //.maxFinite: double.maxFinite is the largest possible finite number in Dart
    String name = 'Unknown'; //Unknown face
    for (var face in _cachedFaces!) {
      final distance =
          _euclideanDistance(embedding, face['embedding'].cast<double>());
      if (distance <= threshold && distance < minDistance) {
        minDistance = distance;
        name = face['name'];
        //from this method you can give the similarty faces
      }
    }
    return name;
  }

  double _euclideanDistance(List e1, List e2) {
    //this method: can give the similarty faces
    if (e1.length != e2.length) {
      throw Exception('Vectors have different lengths');
    }
    var sum = 0.0;
    for (var i = 0; i < e1.length; i++) {
      sum += pow(e1[i] - e2[i], 2);
    }
    return sqrt(sum);
  }

  Future<void> deleteFace(String name) async {
    await _storageService.deleteFace(name);
    _cachedFaces = await _storageService.getFaces();
  } //Deletes a registered face by name

  Future<List<Map<String, dynamic>>> getRegisteredFaces() async {
    _cachedFaces ??= await _storageService.getFaces();
    return _cachedFaces!;
  } //after register will appear camera to check like ai

  Future<List<Face>> detectFaces(InputImage inputImage) async {
    final faces = await _faceDetector.processImage(inputImage);
    return faces;
  }

//Uses Google ML Kit to detect faces in an image.
  void dispose() {
    if (!_isInitialized) return;
    _faceDetector.close();
    _interpreter.close();
    _isInitialized = false;
  }
}
