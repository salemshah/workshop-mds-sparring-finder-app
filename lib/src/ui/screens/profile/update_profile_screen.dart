import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sparring_finder/src/blocs/profile/profile_event.dart';
import 'package:sparring_finder/src/blocs/profile/profile_state.dart';
import 'package:sparring_finder/src/config/app_routes.dart';
import 'package:sparring_finder/src/ui/screens/test/address_picker_screen.dart';
import 'package:sparring_finder/src/ui/theme/app_colors.dart';
import '../../../blocs/profile/profile_bloc.dart';
import '../../widgets/custom_input_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_input_mutiline.dart';
import '../../widgets/gender_selector.dart';
import '../../widgets/custom_dropdown.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _bioController = TextEditingController();
  final _dobController = TextEditingController();
  final _weightController = TextEditingController();
  final _skillController = TextEditingController();
  final _genderController = TextEditingController();
  final _experienceController = TextEditingController();
  final _stylesController = TextEditingController();
  final _gymController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String? _address;
  String? _city;
  String? _country;
  double? _latitude;
  double? _longitude;



  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      final profileData = {
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'bio': _bioController.text,
        'date_of_birth': _dobController.text,
        'gender': _genderController.text,
        'weight_class': _weightController.text,
        'skill_level': _skillController.text,
        'years_experience': _experienceController.text,
        'preferred_styles': _stylesController.text,
        'gym_name': _gymController.text,
        'city': _city,
        'country': _country,
        'address': _address,
        'latitude': _latitude.toString(),
        'longitude': _longitude.toString(),
      };

      context.read<MyProfileBloc>().add(
        MyProfileUpdated(profileData),
      );
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

  final List<String> levels = [
    'Beginner',
    'Intermediate',
    'Advanced',
    'Professional',
  ];

  @override
  void initState() {
    super.initState();
    context.read<MyProfileBloc>().add(MyProfileRequested());
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return BlocListener<MyProfileBloc, MyProfileState>(
      listener: (context, state) {
       
        if (state is MyProfileUpdateInProgress) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Updating Profile...')),
          );
        } 
        else if (state is MyProfileUpdateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile Updated Successfully!')),
          );
          Navigator.of(context).pushNamed(AppRoutes.applicationScreen);
        }
        
        else if (state is MyProfileLoadSuccess) {
          final profile = state.profile;

          _firstNameController.text = profile.firstName;
          _lastNameController.text = profile.lastName;
          _bioController.text = profile.bio ?? '';
          _dobController.text =DateFormat('dd/MM/yyyy').format(profile.dateOfBirth);
          _genderController.text = profile.gender;
          _weightController.text = profile.weightClass;
          _skillController.text = profile.skillLevel;
          _experienceController.text =profile.yearsExperience.toString();
          _stylesController.text = profile.preferredStyles;
          _gymController.text = profile.gymName;
          _addressController.text = profile.address;
          _address = profile.address;
          _city = profile.city;
          _country = profile.country;
          _latitude = profile.latitude;
          _longitude = profile.longitude;
        } else if (state is MyProfileFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            'Update Profile',
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: AppColors.background,
          centerTitle: true,
        ),
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
                          'Update your profile',
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
                  GenderSelector(onChanged: (value) => _genderController.text = value),
                  const SizedBox(height: 16),
                  CustomInputField(
                    label: 'Weight class',
                    hint: 'Enter your weight class',
                    controller: _weightController,
                  ),
                  const SizedBox(height: 16),
                  CustomDropdown(controller:  _skillController, levels: levels, label: 'Skill level', hint: 'Select your skill level'),
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
                    label: 'Address *',
                    readOnly: true,
                    hint: 'Tap to pick your address',
                    controller: _addressController,
                    onTap: _openAddressPicker,
                  ),
                  const SizedBox(height: 16),
                  
                  const SizedBox(height: 24),
                  CustomButton(
                    label: 'Update Profile',
                    onPressed: _onSubmit,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
