import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class StorageService {
  //this class to store and delete the faces ai know them
  static final StorageService _instance = StorageService._internal();
  //This line creates and stores a single instance of the class, instance. It runs only once when the app starts
  factory StorageService() => _instance;
  //this Constructor it's create for one time and create instance object for one time
  //so you sure there is only one StorageService used in the whole app (singleton pattern)
  StorageService._internal();
  //StorageService.internal: This is a private constructor
  //internal: It's used to create the instance only once internally

  static const String _facesFileName = 'faces.json';
//name the file that storage the data locally, like boxName in hive, so this way in path_provider
  Future<String> get _localPath async {
    //this method will return String in the Future and this method is get method(so it's getter) and name this method is localPathMethod
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
    //in this method i get on paths(paths to many faces in the facesFileNmae)
  }

  Future<File> get _localFile async {
    //Notice: What's the difference between Future<String> get vs Future<String> method(two method can return but there is get method and normal method)
    //in get method: You can't pass parameters, in normal method: You can pass parameters
    final path = await _localPath;
    return File('$path/$_facesFileName');
    //this method will return File(contain on path), and this path it's mix between path document and file name, so you can now read or write this file later
    // This method returns the local file system path where app documents can be stored, It's used to locate the folder where the faces.json file will be saved
  }

  Future<List<Map<String, dynamic>>> getFaces() async {
    //this method enable you to reads all stored faces from the file
    try {
      final file = await _localFile; //get on file the face
      if (!await file.exists()) {
        //if this file not exist
        await file.create(); //create file
        await file.writeAsString('[]');
        //write an empty list to initialize the file
        return []; //return empty list of faces
      }
      final contents = await file.readAsString();
      //if the file is exist so read this file
      final List<dynamic> jsonData = json.decode(contents);
      //i can access json from this(import 'dart:convert';)
      //.decode: decodes JSON to types in Dart like: List, Map, int, String,.., so convert contents to List<dynamic>
      return List<Map<String, dynamic>>.from(jsonData);
      //return and convert List<dynamic> to List<Map<String,dynamic>> like this([{"name": "Ali", "embedding": [0.1, 0.2, 0.3]}])
    } catch (e) {
      throw Exception('Error getting faces: $e');
    }
  }

  Future<void> saveFace(String name, List<dynamic> embedding) async {
    //embedding: embedding is a List of floats representing one face, used for comparing or recognizing it later
    try {
      final file = await _localFile; //get on paths the fileName to save them
      final faces = await getFaces(); // get on faces to save them

      if (faces.any((face) => face['name'] == name)) {
        throw Exception('Face with this name already exists');
        //throw an error if there is a face with the same name already exists
      }

      faces.add({
        'name': name,
        'embedding': embedding,
      });
//add new face and
      await file.writeAsString(json.encode(faces));
      //write this file to initialize it,
    } catch (e) {
      throw Exception('Error saving face: $e');
    }
  }

  Future<void> deleteFace(String name) async {
    //this method assign name to delete this student this name
    try {
      final file = await _localFile; //get on file
      final faces = await getFaces(); //get on face
      faces.removeWhere((face) => face['name'] == name);
      //if you see value(the key it is name) same name parameter so remove this student
      await file.writeAsString(json.encode(faces));
      //write this file to initialize it,
    } catch (e) {
      throw Exception('Error deleting face: $e');
    }
  }

  Future<void> clearAllFaces() async {
    //this method to clear all faces in the file
    try {
      final file = await _localFile; //get on file
      await file.writeAsString('[]');
      //replace all thing you wrote it in the file so replace it in empty list(so write it)
    } catch (e) {
      throw Exception('Error clearing faces: $e');
    }
  }
}
