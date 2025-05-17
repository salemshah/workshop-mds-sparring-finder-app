import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparring_finder/src/ui/theme/app_colors.dart';
import '../../widgets/custom_input_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_input_mutiline.dart';
import '../../widgets/upload_image_field.dart';
import '../../widgets/gender_selector.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _bioController = TextEditingController();
  final _dobController = TextEditingController();
  final _weightController = TextEditingController();
  final _skillController = TextEditingController();
  final _experienceController = TextEditingController();
  final _stylesController = TextEditingController();
  final _gymController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();

  String _gender = 'Male';
  File? _profileImage;

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      // Collect and send data
      // You can dispatch a BLoC event here
      debugPrint('First name: ${_firstNameController.text}');
      debugPrint('Gender: $_gender');
      debugPrint('Photo: ${_profileImage?.path}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Stack(
                  children: [
                    Image.asset(
                      'assets/images/boxer.png',
                      width: width - 50,
                      fit: BoxFit.fill,
                    ),
                    Positioned(
                      bottom: 30,
                      left: 10,
                      child: Text(
                        'Create your profile',
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CustomInputField(
                  label: 'Name',
                  hint: 'Enter your name',
                  controller: _firstNameController,
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                CustomInputField(
                  label: 'Last name',
                  hint: 'Enter your last name',
                  controller: _lastNameController,
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                BioField(
                  controller: _bioController,
                  validator: (v) => v == null || v.isEmpty ? 'Enter your bio' : null,
                ),
                const SizedBox(height: 16),
                UploadImageField(
                  onImageSelected: (file) => _profileImage = file,
                ),
                const SizedBox(height: 16),
                CustomInputField(
                  label: 'Date of birth',
                  hint: 'dd/mm/yyyy',
                  controller: _dobController,
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      "Gender",
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                GenderSelector(onChanged: (value) => _gender = value),
                const SizedBox(height: 16),
                CustomInputField(
                  label: 'Weight class',
                  hint: 'Enter your weight class',
                  controller: _weightController,
                ),
                const SizedBox(height: 16),
                CustomInputField(
                  label: 'Skill level',
                  hint: 'Enter your skill level',
                  controller: _skillController,
                ),
                const SizedBox(height: 16),
                CustomInputField(
                  label: 'Years experience',
                  hint: 'Enter your years experience',
                  controller: _experienceController,
                ),
                const SizedBox(height: 16),
                CustomInputField(
                  label: 'Preferred styles',
                  hint: 'Enter your preferred styles',
                  controller: _stylesController,
                ),
                const SizedBox(height: 16),
                CustomInputField(
                  label: 'Gym name',
                  hint: 'Enter your gym name',
                  controller: _gymController,
                ),
                const SizedBox(height: 16),
                CustomInputField(
                  label: 'City',
                  hint: 'Enter your city name',
                  controller: _cityController,
                ),
                const SizedBox(height: 16),
                CustomInputField(
                  label: 'Country',
                  hint: 'Enter your country name',
                  controller: _countryController,
                ),
                const SizedBox(height: 24),
                CustomButton(
                  label: 'Submit',
                  onPressed: _onSubmit,
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
