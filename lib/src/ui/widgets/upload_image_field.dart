import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_colors.dart';

class UploadImageField extends StatefulWidget {
  final void Function(File) onImageSelected;

  const UploadImageField({super.key, required this.onImageSelected});

  @override
  State<UploadImageField> createState() => _UploadImageFieldState();
}

class _UploadImageFieldState extends State<UploadImageField> {
  File? _selectedImage;

  Future<void> _pickAndCropImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );

    if (pickedFile == null) return;

    final croppedFile = await _cropImage(pickedFile.path);

    if (croppedFile != null) {
      final file = File(croppedFile.path);
      setState(() => _selectedImage = file);
      widget.onImageSelected(file);
    }
  }

  Future<CroppedFile?> _cropImage(String path) {
    return ImageCropper().cropImage(
      sourcePath: path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: AppColors.primary,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
          activeControlsWidgetColor: AppColors.primary,
          dimmedLayerColor: Colors.black54,
          cropFrameColor: AppColors.primary,
          showCropGrid: true,
        ),
        IOSUiSettings(
          title: 'Crop Image',
          aspectRatioLockEnabled: true,
          aspectRatioPickerButtonHidden: true,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: _pickAndCropImage,
      child: Container(
        height: width - 60,
        width: width,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border, width: 3),
          borderRadius: BorderRadius.circular(12),
          color: AppColors.inputFill,
        ),
        child: _selectedImage != null
            ? ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            _selectedImage!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        )
            : const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.upload, color: AppColors.label, size: 100),
              SizedBox(height: 8),
              Text(
                "Upload your profile photo",
                style: TextStyle(color: AppColors.label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
