/*
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frapp/core/utils/styles/style_to_colors.dart';
import 'package:frapp/features/auth/presentation/views/home_page.dart';
import 'package:camera/camera.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  //availableCameras(): return List of Cameras in this phone(fronts,backs,..), availableCameras i get on it from camera package
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [],
  );
  runApp(MyApp(camera: cameras.last));
  //cameras.last: normally is front camera in the phone, and the organizing cameras will different in different the phones
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.camera});

  final CameraDescription camera;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Face Recognition App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: StyleToColors.deepPurpleColor,
        ),
        useMaterial3: true,
      ),
      home: MyHomePage(camera: camera),
    );
  }
}
*/
