import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:frapp/core/utils/styles/style_to_texts.dart';
import 'package:frapp/features/auth/presentation/views/recognize_face_page.dart';
import 'package:frapp/features/auth/presentation/views/register_face_page.dart';
import 'package:frapp/features/auth/presentation/views/registered_faces_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.camera});

  final CameraDescription camera;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          'Face Recognition App',
          style: StyleToTexts.textStyleNormal16(context: context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterFacePage()));
                },
                child: Text(
                  'Register Face',
                  style: StyleToTexts.textStyleBold14(context: context),
                )),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              RecognizeFacePage(camera: widget.camera)));
                },
                child: Text(
                  'Recognize Face',
                  style: StyleToTexts.textStyleBold14(context: context),
                )),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisteredFacesPage()));
                },
                child: Text(
                  'Registered Faces',
                  style: StyleToTexts.textStyleBold14(context: context),
                )),
          ],
        ),
      ),
    );
  }
}
