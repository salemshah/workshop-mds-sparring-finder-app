import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparring_finder/src/blocs/profile/profile_event.dart';
import 'package:sparring_finder/src/blocs/profile/profile_state.dart';
import 'package:sparring_finder/src/blocs/profile/profile_bloc.dart';
import 'package:sparring_finder/src/ui/theme/app_colors.dart';
import '../../widgets/custom_input_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_input_mutiline.dart';
import '../../widgets/upload_image_field.dart';
import '../../widgets/gender_selector.dart';
import '../../widgets/custom_dropdown.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

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

  final List<String> levels = ['Beginner', 'Intermediate', 'Advanced', 'Professional'];

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      final profileData = {
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'bio': _bioController.text,
        'date_of_birth': _dobController.text,
        'gender': _gender,
        'weight_class': _weightController.text,
        'skill_level': _skillController.text,
        'years_experience': _experienceController.text,
        'preferred_styles': _stylesController.text,
        'gym_name': _gymController.text,
        'city': _cityController.text,
        'country': _countryController.text,
      };

      context.read<ProfileBloc>().add(
        ProfileCreateRequested(profileData: profileData, photo: _profileImage),
      );
    }
  }

  void _nextStep() {
    if (_currentStep < 4) {
      setState(() {
        _currentStep++;
      });
    } else {
      _onSubmit();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return Column(
          children: [
            CustomInputField(label: 'Name', hint: 'Enter your name', controller: _firstNameController),
            const SizedBox(height: 16),
            CustomInputField(label: 'Last name', hint: 'Enter your last name', controller: _lastNameController),
            const SizedBox(height: 16),
            BioField(controller: _bioController),
          ],
        );
      case 1:
        return UploadImageField(onImageSelected: (file) => _profileImage = file);
      case 2:
        return Column(
          children: [
            CustomInputField(label: 'Date of birth', hint: 'dd/mm/yyyy', controller: _dobController),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text("Gender", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
              ),
            ),
            GenderSelector(onChanged: (value) => _gender = value),
          ],
        );
      case 3:
        return Column(
          children: [
            CustomInputField(label: 'Weight class', hint: 'Enter your weight class', controller: _weightController),
            const SizedBox(height: 16),
            CustomDropdown(controller: _skillController, levels: levels, label: 'Skill level', hint: 'Select your skill level'),
            const SizedBox(height: 16),
            CustomInputField(label: 'Years experience', hint: 'Enter your years experience', controller: _experienceController),
            const SizedBox(height: 16),
            CustomInputField(label: 'Preferred styles', hint: 'Enter your preferred styles', controller: _stylesController),
          ],
        );
      case 4:
        return Column(
          children: [
            CustomInputField(label: 'Gym name', hint: 'Enter your gym name', controller: _gymController),
            const SizedBox(height: 16),
            CustomInputField(label: 'City', hint: 'Enter your city name', controller: _cityController),
            const SizedBox(height: 16),
            CustomInputField(label: 'Country', hint: 'Enter your country name', controller: _countryController),
          ],
        );
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoading) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Creating profile...')));
        } else if (state is ProfileLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile created successfully!')));
        } else if (state is ProfileFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // if (_currentStep == 0)
                    Stack(
                      children: [
                        Image.asset('assets/images/boxer.png', width: width - 50, fit: BoxFit.fill),
                        Positioned(
                          bottom: 30,
                          left: 10,
                          child: Text('Create your profile',
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
                  Expanded(
                    child: SingleChildScrollView(
                      child: _buildStepContent(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      if (_currentStep > 0)
                        Expanded(
                          child: CustomButton(label: 'Back', onPressed: _previousStep),
                        ),
                      if (_currentStep > 0) const SizedBox(width: 16),
                      Expanded(
                        child: CustomButton(
                          label: _currentStep == 4 ? 'Submit' : 'Next',
                          onPressed: _nextStep,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}