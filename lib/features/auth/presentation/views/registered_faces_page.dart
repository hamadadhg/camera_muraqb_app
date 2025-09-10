/*
import 'package:flutter/material.dart';
import 'package:frapp/core/utils/styles/style_to_colors.dart';
import 'package:frapp/core/utils/styles/style_to_texts.dart';
import 'package:frapp/features/auth/data/services/face_recognition_service.dart';

class RegisteredFacesPage extends StatefulWidget {
  const RegisteredFacesPage({super.key});

  @override
  State<RegisteredFacesPage> createState() => _RegisteredFacesPageState();
}

class _RegisteredFacesPageState extends State<RegisteredFacesPage> {
  final FaceRecognitionService _faceService = FaceRecognitionService();
  List<Map<String, dynamic>> _faces = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFaces();
  }

  Future<void> _loadFaces() async {
    try {
      final faces = await _faceService.getRegisteredFaces();
      setState(() {
        _faces = faces;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
            'Error loading faces: $e',
            style: StyleToTexts.textStyleNormal12(context: context).copyWith(
              color: StyleToColors.redColor,
            ),
          )),
        );
      }
    }
  }

  Future<void> _deleteFace(String name) async {
    try {
      await _faceService.deleteFace(name);
      await _loadFaces(); // Reload the list
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Face deleted successfully',
              style: StyleToTexts.textStyleNormal12(context: context)
                  .copyWith(color: StyleToColors.whiteColor),
            ),
            backgroundColor: StyleToColors.greenColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
            'Error deleting face: $e',
            style: StyleToTexts.textStyleNormal12(context: context)
                .copyWith(color: StyleToColors.redColor),
          )),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Registered Faces',
          style: StyleToTexts.textStyleNormal16(context: context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _faces.isEmpty
              ? Center(
                  child: Text(
                    'No faces registered yet',
                    style: StyleToTexts.textStyleNormal16(context: context),
                  ),
                )
              : ListView.builder(
                  itemCount: _faces.length,
                  itemBuilder: (context, index) {
                    final face = _faces[index];
                    return ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.face),
                      ),
                      title: Text(
                        face['name'],
                        style: StyleToTexts.textStyleNormal12(context: context),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete,
                            color: StyleToColors.redColor),
                        onPressed: () => _deleteFace(face['name']),
                      ),
                    );
                  },
                ),
    );
  }
}
*/
