import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparring_finder/src/blocs/user/user_bloc.dart';
import 'package:sparring_finder/src/blocs/user/user_event.dart';
import 'package:sparring_finder/src/blocs/user/user_state.dart';
import 'package:sparring_finder/src/config/app_routes.dart';
import 'package:sparring_finder/src/ui/theme/app_colors.dart';
import 'package:sparring_finder/src/ui/widgets/custom_button.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  String _code = '';
  bool _isFilled = false;

  Timer? _timer;
  int _start = 60;
  bool _isResendEnabled = false;
  String _email = '';

  final List<TextEditingController> _controllers =
  List.generate(6, (_) => TextEditingController());

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    setState(() {
      _start = 60;
      _isResendEnabled = false;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() => _isResendEnabled = true);
        _timer?.cancel();
      } else {
        setState(() => _start--);
      }
    });
  }

  void _submitCode() {
    if (_code.length == 6) {
      context.read<UserBloc>().add(UserVerifyEmailRequested(code: _code.trim()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the full code')),
      );
    }
  }

  void _resendCode() {
    context.read<UserBloc>().add(UserResendVerificationRequested(email: _email));
    _startTimer();
  }

  void _updateCode() {
    _code = _controllers.map((c) => c.text).join();
    setState(() {
      _isFilled = _code.length == 6;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.green),
              );
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.loginScreen,
                    (_) => false,
              );
            } else if (state is UserFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error), backgroundColor: Colors.red),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.email,
                    size: 120,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Verify Email",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    "A Code Has Been Sent To Your Email.\nPlease Enter It Below.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.label),
                  ),
                  const SizedBox(height: 30),

                  // Code input boxes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (i) {
                      return Container(
                        width: 50,
                        height: 50,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: AppColors.inputFill,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border, width: 2),
                        ),
                        child: Center(
                          child: TextField(
                            controller: _controllers[i],
                            maxLength: 1,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                              fontSize: 22,
                              color: AppColors.text,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              counterText: '',
                            ),
                            onChanged: (val) {
                              if (val.isNotEmpty && i < 5) {
                                FocusScope.of(context).nextFocus();
                              } else if (val.isEmpty && i > 0) {
                                FocusScope.of(context).previousFocus();
                              }
                              _updateCode();
                            },
                          ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 20),
                  _isResendEnabled
                      ? TextButton(
                    onPressed: _resendCode,
                    child: const Text(
                      "Resend The Code",
                      style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                    ),
                  )
                      : Text(
                    "Code Not Received? Resend The Code ($_start)",
                    style: const TextStyle(color: AppColors.label),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isFilled ? _submitCode : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: CustomButton(
                        label: "Submit",
                        onPressed: _submitCode,
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
