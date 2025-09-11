/*
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;

class CameraService {
  static final CameraService _instance = CameraService._internal();
  //This line creates and stores a single instance of the class, instance. It runs only once when the app starts
  factory CameraService() => _instance;
  //this Constructor it's create for one time and create instance object for one time
  //so you sure there is only one CameraService used in the whole app (singleton pattern)
  CameraService._internal();
//CameraService.internal: This is a private constructor
  //internal: It's used to create the instance only once internally
  late CameraController _controller;
  //Manages camera state and captures/streams images
  bool _isInitialized = false;
//Keeps track of whether the camera is ready to use or no
  Future<void> initialize(CameraDescription camera) async {
    //Takes a camera(front/back)
    _controller = CameraController(
      camera,
      ResolutionPreset.medium, //Uses medium resolution
      enableAudio: false, //Turns off audio(not needed for face detection)
      imageFormatGroup: ImageFormatGroup.nv21,
      //Uses NV21 image format(used in Android for performance)
    );
    await _controller.initialize();
    _isInitialized = true;
    //isInitialized to true because the camera is initialized
  }

  void startImageStream(Function(CameraImage) onImage) {
    _controller.startImageStream(onImage);
  } //Begins streaming camera images continuously

  CameraController get controller {
    if (!_isInitialized) {
      throw CameraException('Camera not initialized',
          'Call initialize() before accessing the controller');
    }
    return _controller;
  } //If the camera isn’t initialized, throws a CameraException

  static img.Image convertNV21ToImage(
      Uint8List nv21Data, int width, int height) {
    //this method Converts raw NV21 format image bytes to an RGB image from using the image package
    img.Image image = img.Image(width: width, height: height);
    final ySize = width * height;
    final uvSize = width * height ~/ 4;

    final yPlane = nv21Data.sublist(0, ySize);
    final uvPlane = nv21Data.sublist(ySize, ySize + uvSize * 2);

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final yIndex = y * width + x;
        final yValue = yPlane[yIndex];

        final uvIndex = (y ~/ 2) * width + (x - (x % 2));
        final vValue = uvPlane[uvIndex];
        final uValue = uvPlane[uvIndex + 1];

        final r = (yValue + 1.402 * (vValue - 128)).clamp(0, 255).toInt();
        final g = (yValue - 0.34414 * (uValue - 128) - 0.71414 * (vValue - 128))
            .clamp(0, 255)
            .toInt();
        final b = (yValue + 1.772 * (uValue - 128)).clamp(0, 255).toInt();

        image.setPixel(x, y, img.ColorRgb8(r, g, b));
      }
    }

    return image;
  }

  Future<void> dispose() async {
    if (!_isInitialized) return;
    //if not initialized so don't dispose from anything
    await _controller.stopImageStream();
    await _controller.dispose();
    _isInitialized = false;
    //if initialized is true so dispose and make isInitialized is false because i finish
  }
}
*/
