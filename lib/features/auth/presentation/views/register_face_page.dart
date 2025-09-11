/*
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frapp/core/utils/styles/style_to_colors.dart';
import 'package:frapp/core/utils/styles/style_to_texts.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frapp/features/auth/data/services/face_recognition_service.dart';

class RegisterFacePage extends StatefulWidget {
  const RegisterFacePage({super.key});

  @override
  State<RegisterFacePage> createState() => _RegisterFacePageState();
}

class _RegisterFacePageState extends State<RegisterFacePage> {
  final TextEditingController nameController = TextEditingController();
  final _imagePicker = ImagePicker();
  final _faceService = FaceRecognitionService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _faceService.initialize();
  }

  @override
  void dispose() {
    nameController.dispose();
    _faceService.dispose();
    super.dispose();
  }

  Future<void> _registerFace() async {
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
          'Please enter a name',
          style: StyleToTexts.textStyleNormal12(context: context),
        )),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final image = await _imagePicker.pickImage(source: ImageSource.camera);
      if (image == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      InputImage inputImage = InputImage.fromFile(File(image.path));
      final faces = await _faceService.detectFaces(inputImage);
      if (faces.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
              'No face detected',
              style: StyleToTexts.textStyleNormal12(context: context),
            )),
          );
        }
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final input = FaceRecognitionService.prepareInputFromImagePath({
        'imgPath': image.path,
        'face': faces.first,
      });
      final embedding = _faceService.getEmbedding(input);

      try {
        await _faceService.registerFace(nameController.text, embedding);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
              'Error registering face: $e',
              style: StyleToTexts.textStyleNormal12(context: context)
                  .copyWith(color: StyleToColors.redColor),
            )),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Face registered successfully',
            style: StyleToTexts.textStyleNormal12(context: context)
                .copyWith(color: StyleToColors.whiteColor),
          ),
          backgroundColor: StyleToColors.greenColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Register Face',
        style: StyleToTexts.textStyleNormal16(context: context),
      )),
      body: Stack(
        children: [
          ListView(
            children: <Widget>[
              SizedBox(height: size.height * 0.021),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.037),
                child: TextField(
                  style: StyleToTexts.textStyleBold14(context: context),
                  controller: nameController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Your Name',
                    labelStyle:
                        StyleToTexts.textStyleNormal14(context: context),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.021),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.037),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _registerFace,
                  child: _isLoading
                      ? SizedBox(
                          width: size.width * 0.045,
                          height: size.height * 0.028,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                StyleToColors.whiteColor),
                          ),
                        )
                      : Text(
                          'Register Face',
                          style:
                              StyleToTexts.textStyleNormal16(context: context),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
*/
