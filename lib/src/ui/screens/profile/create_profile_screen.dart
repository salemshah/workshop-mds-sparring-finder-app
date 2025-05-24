import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../blocs/profile/profile_bloc.dart';
import '../../../blocs/profile/profile_event.dart';
import '../../../blocs/profile/profile_state.dart';
import '../../../config/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/custom_input_field.dart';
import '../../widgets/custom_input_mutiline.dart';
import '../../widgets/gender_selector.dart';
import '../../widgets/input_date_picker.dart';
import '../../widgets/upload_image_field.dart';
import 'package:intl/intl.dart';

/// Multi‑step form for creating a new fighter profile with lightweight local
/// validation *before* advancing to the next step. After a successful API
/// response the user is routed directly to the home screen. While the profile
/// is being created a full‑screen opaque loader is displayed, blocking user
/// interaction.
class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  // --------------------------- Wizard state ------------------------------ //
  final int _lastStep = 4;
  int _currentStep = 0;

  // --------------------------- Controllers -------------------------------- //
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _bio = TextEditingController();
  final _dob = TextEditingController();
  final _weight = TextEditingController();
  final _skill = TextEditingController();
  final _experience = TextEditingController();
  final _styles = TextEditingController();
  final _gym = TextEditingController();
  final _city = TextEditingController();
  final _country = TextEditingController();

  String _gender = 'Male';
  File? _profileImage;

  final _levels = const [
    'Beginner',
    'Intermediate',
    'Advanced',
    'Professional',
  ];

  // -------------------------------- Helpers ------------------------------ //
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        if (_firstName.text.isEmpty || _lastName.text.isEmpty) {
          _showError('Please enter your first and last name');
          return false;
        }
        return true;
      case 1:
        if (_profileImage == null) {
          _showError('Please upload a profile photo');
          return false;
        }
        return true;
      case 2:
        if (_dob.text.isEmpty) {
          _showError('Please enter your date of birth');
          return false;
        }
        return true;
      case 3:
        if (_weight.text.isEmpty ||
            _skill.text.isEmpty ||
            _experience.text.isEmpty) {
          _showError('Please complete weight, skill level and experience');
          return false;
        }
        return true;
      case 4:
        if (_gym.text.isEmpty || _city.text.isEmpty || _country.text.isEmpty) {
          _showError('Please fill gym, city and country');
          return false;
        }
        return true;
      default:
        return true;
    }
  }

  void _nextStep() {
    if (!_validateCurrentStep()) return;

    if (_currentStep < _lastStep) {
      setState(() => _currentStep++);
    } else {
      _submit();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) setState(() => _currentStep--);
  }

  void _submit() {

    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final DateTime dateOfBirth = formatter.parseStrict(_dob.text);

    final profileData = {
      'first_name': _firstName.text,
      'last_name': _lastName.text,
      'bio': _bio.text,
      'date_of_birth': dateOfBirth,
      'gender': _gender,
      'weight_class': _weight.text,
      'skill_level': _skill.text,
      'years_experience': _experience.text,
      'preferred_styles': _styles.text,
      'gym_name': _gym.text,
      'city': _city.text,
      'country': _country.text,
    };

    context.read<ProfileBloc>().add(
      ProfileCreated(data: profileData, photo: _profileImage),
    );
  }



  // --------------------------- UI Builders ------------------------------- //
  Widget _buildStep0() => Column(
    children: [
      CustomInputField(
        label: 'Name',
        hint: 'Enter your name',
        controller: _firstName,
      ),
      const SizedBox(height: 16),
      CustomInputField(
        label: 'Last name',
        hint: 'Enter your last name',
        controller: _lastName,
      ),
      const SizedBox(height: 16),
      BioField(controller: _bio),
    ],
  );

  Widget _buildStep1() => UploadImageField(
    onImageSelected: (file) => _profileImage = file,
  );

  Widget _buildStep2() => Column(
    children: [
      InputDatePicker(
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
        onDateChanged: (date) {
          // Format the date as dd/MM/yyyy (or any other format you prefer)
          final formattedDate = DateFormat('dd/MM/yyyy').format(date);
          _dob.text = formattedDate; // Update the controller with formatted date
        },
        controller: _dob,
        hint: 'Select your date of birth',
        label: "Date of birth",
      ),
      const SizedBox(height: 16),
      Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            'Gender',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      GenderSelector(onChanged: (value) => _gender = value),
    ],
  );

  Widget _buildStep3() => Column(
    children: [
      CustomInputField(
        label: 'Weight class',
        hint: 'Enter your weight class',
        controller: _weight,
      ),
      const SizedBox(height: 16),
      CustomDropdown(
        controller: _skill,
        levels: _levels,
        label: 'Skill level',
        hint: 'Select your skill level',
      ),
      const SizedBox(height: 16),
      CustomInputField(
        label: 'Years experience',
        hint: 'Enter your years experience',
        controller: _experience,
      ),
      const SizedBox(height: 16),
      CustomInputField(
        label: 'Preferred styles',
        hint: 'Enter your preferred styles',
        controller: _styles,
      ),
    ],
  );

  Widget _buildStep4() => Column(
    children: [
      CustomInputField(
        label: 'Gym name',
        hint: 'Enter your gym name',
        controller: _gym,
      ),
      const SizedBox(height: 16),
      CustomInputField(
        label: 'City',
        hint: 'Enter your city name',
        controller: _city,
      ),
      const SizedBox(height: 16),
      CustomInputField(
        label: 'Country',
        hint: 'Enter your country name',
        controller: _country,
      ),
    ],
  );

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildStep0();
      case 1:
        return _buildStep1();
      case 2:
        return _buildStep2();
      case 3:
        return _buildStep3();
      case 4:
        return _buildStep4();
      default:
        return const SizedBox();
    }
  }

  // --------------------------- Screen build ----------------------------- //
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // BlocConsumer gives us both listener (for side‑effects) and builder (for UI)
    return BlocConsumer<ProfileBloc, ProfileState>(
      listenWhen: (previous, current) => current is! ProfileLoadInProgress,
      listener: (context, state) {
        if (state is ProfileLoadSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile created successfully!')),
          );
          Navigator.pushReplacementNamed(context, AppRoutes.applicationScreen);
        } else if (state is ProfileFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is ProfileLoadInProgress;

        return Stack(
          children: [
            Scaffold(
              backgroundColor: AppColors.background,
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                              child: CustomButton(
                                label: 'Back',
                                onPressed: _previousStep,
                              ),
                            ),
                          if (_currentStep > 0) const SizedBox(width: 16),
                          Expanded(
                            child: CustomButton(
                              label: _currentStep == _lastStep ? 'Submit' : 'Next',
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
            if (isLoading) const _FullScreenLoader(),
          ],
        );
      },
    );
  }
}

/// A reusable, opaque, pointer‑blocking loading overlay.
class _FullScreenLoader extends StatelessWidget {
  const _FullScreenLoader();

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: true,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.background.withValues(alpha: 0.7),
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      ),
    );
  }
}
