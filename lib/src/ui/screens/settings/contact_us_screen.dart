import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparring_finder/src/blocs/contact/contact_bloc.dart';
import 'package:sparring_finder/src/blocs/contact/contact_event.dart';
import 'package:sparring_finder/src/blocs/contact/contact_state.dart';
import 'package:sparring_finder/src/ui/widgets/app_lottie_loader.dart';
import '../../../../generated/assets.dart';
import '../../theme/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/custom_input_field.dart';
import '../../widgets/custom_input_mutiline.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen>
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
        Navigator.of(context).pop();
      }
    });
    _isInitialized = true;
  }

  @override
  void dispose() {
    _successController.dispose();
    super.dispose();
  }


  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _subject = TextEditingController();

  final _subjects = const [
    'General Inquiry',
    'Feedback',
    'Support',
    'Other',
  ];

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  bool _validateCurrentStep() {
    if (_firstName.text.isEmpty) {
      _showError('Please enter your first name.');
      return false;
    }
    if (_lastName.text.isEmpty) {
      _showError('Please enter your last name.');
      return false;
    }
    if (_email.text.isEmpty) {
      _showError('Please enter your email.');
      return false;
    }
    if (_subject.text.isEmpty) {
      _showError('Please select a subject.');
      return false;
    }
    if (_description.text.isEmpty) {
      _showError('Please enter a description.');
      return false;
    }
    return true;
  }



  void _submit() {
    

    setState(() {
      _isLooping = true;
      _isLoading = true;
      _showSuccess = false;
      _animationPath = Assets.animationsRegister;
    });

    final contactData = {
      'first_name': _firstName.text,
      'last_name': _lastName.text,
      'email': _email.text,
      'subject': _subject.text,
      'description': _description.text,
    };
    context
        .read<ContactBloc>()
        .add(ContactCreated(data: contactData));
  }


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return BlocConsumer<ContactBloc, ContactState>(
      listenWhen: (prev, current) => current is! ContactLoadInProgress,
      listener: (context, state) {
        if (state is ContactLoadInProgress) {
          setState(() {
            _animationPath = Assets.animationsRegister;
            _isLoading = true;
            _showSuccess = false;
            _isLooping = true;
          });
        } else if (state is ContactLoadSuccess) {
          setState(() {
            _animationPath = Assets.animationsSuccess;
            _showSuccess = true;
            _isLooping = false;
          });
        } else if (state is ContactFailure) {
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
            appBar: AppBar(
              backgroundColor: AppColors.primary,
              title: Text(
                'Contact Us',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                ),
              ),
              centerTitle: true,
              elevation: 1,
              foregroundColor: AppColors.white,
            ),
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
                        'Contact Us',
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
                      child: SingleChildScrollView(
                        child:
                        Column(children: [
                  CustomInputField(
                      label: 'Name *', hint: 'Enter your name', controller: _firstName),
                  const SizedBox(height: 16),
                  CustomInputField(
                      label: 'Last name *',
                      hint: 'Enter your last name',
                      controller: _lastName),
                  const SizedBox(height: 16),
                  CustomInputField(
                      label: 'Email *',
                      hint: 'Enter your email',
                      controller: _email,),
                  const SizedBox(height: 16),
                  CustomDropdown(
                      controller: _subject,
                      levels: _subjects,
                      label: 'Subject *',
                      hint: 'Select subject'), 
                  const SizedBox(height: 16),
                  BioField(controller: _description),
                        ]
                      )),),
                  const SizedBox(height: 20),
                  Row(children: [
                   
                    Expanded(
                        child: CustomButton(
                            label:'Submit',
                            onPressed: () {
                              if (_validateCurrentStep()) {
                                _submit();
                              }
                            })),
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
