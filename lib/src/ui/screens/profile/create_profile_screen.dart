import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sparring_finder/src/ui/widgets/app_lottie_loader.dart';
import '../../../../generated/assets.dart';
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
import '../test/address_picker_screen.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _successController;
  String? _animationPath;
  bool _isLoading = false;
  bool _showSuccess = false;
  bool _isInitialized = false;
  bool _isLooping = false;

  @override
  void initState() {
    super.initState();
    _successController = AnimationController(vsync: this);
    _successController.addStatusListener((status) {
      if (status == AnimationStatus.completed && _showSuccess) {
        Navigator.pushReplacementNamed(context, AppRoutes.loadingScreen);
      }
    });
    _isInitialized = true;
  }

  @override
  void dispose() {
    _addressController.dispose();
    _successController.dispose();
    super.dispose();
  }

  final int _lastStep = 4;
  int _currentStep = 0;

  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _bio = TextEditingController();
  final TextEditingController _dob = TextEditingController();
  final TextEditingController _weight = TextEditingController();
  final TextEditingController _skill = TextEditingController();
  final TextEditingController _experience = TextEditingController();
  final TextEditingController _styles = TextEditingController();
  final TextEditingController _gym = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? _address;
  String? _city;
  String? _country;
  double? _latitude;
  double? _longitude;

  String _gender = 'Male';
  File? _profileImage;

  final _levels = const [
    'Beginner',
    'Intermediate',
    'Advanced',
    'Professional',
  ];

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _firstName.text.isNotEmpty && _lastName.text.isNotEmpty;
      case 1:
        return _profileImage != null;
      case 2:
        return _dob.text.isNotEmpty;
      case 3:
        return _weight.text.isNotEmpty &&
            _skill.text.isNotEmpty &&
            _experience.text.isNotEmpty;
      case 4:
        return _gym.text.isNotEmpty && _addressController.text.isNotEmpty;
      default:
        return true;
    }
  }

  void _nextStep() {
    if (!_validateCurrentStep()) {
      _showError('Please complete all required fields.');
      return;
    }

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
    final dateOfBirth = DateFormat('dd/MM/yyyy').parseStrict(_dob.text);

    setState(() {
      _isLooping = true;
      _isLoading = true;
      _showSuccess = false;
      _animationPath = Assets.animationsRegister;
    });

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
      'city': _city,
      'country': _country,
      'address': _address,
      'latitude': _latitude,
      'longitude': _longitude,
    };
    context
        .read<MyProfileBloc>()
        .add(MyProfileCreated(data: profileData, photo: _profileImage));
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return Column(children: [
          CustomInputField(
              label: 'Name *', hint: 'Enter your name', controller: _firstName),
          const SizedBox(height: 16),
          CustomInputField(
              label: 'Last name *',
              hint: 'Enter your last name',
              controller: _lastName),
          const SizedBox(height: 16),
          BioField(controller: _bio),
        ]);
      case 1:
        return UploadImageField(
            onImageSelected: (file) => _profileImage = file);
      case 2:
        return Column(children: [
          InputDatePicker(
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
            onDateChanged: (date) =>
                _dob.text = DateFormat('dd/MM/yyyy').format(date),
            controller: _dob,
            hint: 'Select your date of birth',
            label: "Date of birth *",
          ),
          const SizedBox(height: 16),
          GenderSelector(onChanged: (value) => _gender = value),
        ]);
      case 3:
        return Column(children: [
          CustomInputField(
              label: 'Weight class *',
              hint: 'Enter your weight class',
              controller: _weight),
          const SizedBox(height: 16),
          CustomDropdown(
              controller: _skill,
              levels: _levels,
              label: 'Skill level *',
              hint: 'Select your skill level'),
          const SizedBox(height: 16),
          CustomInputField(
              label: 'Years experience *',
              hint: 'Enter your years experience',
              controller: _experience),
          const SizedBox(height: 16),
          CustomInputField(
              label: 'Preferred styles *',
              hint: 'Enter your preferred styles',
              controller: _styles),
        ]);
      case 4:
        return Column(children: [
          CustomInputField(
              label: 'Gym name *',
              hint: 'Enter your gym name',
              controller: _gym),
          const SizedBox(height: 16),
          CustomInputField(
            label: 'Address *',
            readOnly: true,
            hint: 'Tap to pick your address',
            controller: _addressController,
            onTap: _openAddressPicker,
          )
        ]);
      default:
        return const SizedBox();
    }
  }

  Future<void> _openAddressPicker() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => const AddressPickerScreen(),
      ),
    );

    if (result == null) return;
    setState(() {
      _addressController.text = result["address"] as String;
      _city = result["city"] as String;
      _country = result["country"] as String;
      _address = result["address"] as String;
      _latitude = result["latitude"] as double;
      _longitude = result["longitude"] as double;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return BlocConsumer<MyProfileBloc, MyProfileState>(
      listenWhen: (prev, current) => current is! MyProfileLoadInProgress,
      listener: (context, state) {
        if (state is MyProfileLoadInProgress) {
          setState(() {
            _animationPath = Assets.animationsRegister;
            _isLoading = true;
            _showSuccess = false;
            _isLooping = true;
          });
        } else if (state is MyProfileLoadSuccess) {
          setState(() {
            _animationPath = Assets.animationsSuccess;
            _showSuccess = true;
            _isLooping = false;
          });
        } else if (state is MyProfileFailure) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error)));
          setState(() {
            _isLoading = false;
            _animationPath = null;
            _showSuccess = false;
          });
        }
      },
      builder: (context, state) {
        if (_isInitialized &&
            (_isLoading || _showSuccess) &&
            _animationPath != null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: AppLottieLoader(
              size: width,
              animationPath: _animationPath!,
              controller: _successController,
              onLoaded: (composition) {
                _successController.duration = composition.duration;
                if (_isLooping) {
                  _successController.repeat();
                } else {
                  _successController.forward(from: 0);
                }
              },
              repeat: false, // must be false if using controller
            ),
          );
        }

        return Stack(children: [
          Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(children: [
                  Stack(children: [
                    Image.asset('assets/images/boxer.png',
                        width: width - 50, fit: BoxFit.fill),
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
                  ]),
                  const SizedBox(height: 20),
                  Expanded(
                      child: SingleChildScrollView(child: _buildStepContent())),
                  const SizedBox(height: 20),
                  Row(children: [
                    if (_currentStep > 0)
                      Expanded(
                          child: CustomButton(
                              label: 'Back', onPressed: _previousStep)),
                    if (_currentStep > 0) const SizedBox(width: 16),
                    Expanded(
                        child: CustomButton(
                            label:
                                _currentStep == _lastStep ? 'Submit' : 'Next',
                            onPressed: _nextStep)),
                  ]),
                  const SizedBox(height: 20),
                ]),
              ),
            ),
          ),
        ]);
      },
    );
  }
}
