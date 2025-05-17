import 'dart:io';
import 'package:flutter/material.dart';
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

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      setState(() => _selectedImage = file);
      widget.onImageSelected(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border, style: BorderStyle.solid, width: 3),
          borderRadius: BorderRadius.circular(12),
          color: AppColors.inputFill,

        ),
        child: _selectedImage != null
            ? ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(_selectedImage!, fit: BoxFit.cover, width: double.infinity),
        )
            : const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.upload, color: AppColors.label, size: 32),
              SizedBox(height: 8),
              Text("Upload your profile photo", style: TextStyle(color: AppColors.label)),
            ],
          ),
        ),
      ),
    );
  }
}
