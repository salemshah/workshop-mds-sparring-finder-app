import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparring_finder/src/blocs/user/user_bloc.dart';
import 'package:sparring_finder/src/blocs/user/user_event.dart';
import 'package:sparring_finder/src/blocs/user/user_state.dart';
import 'package:sparring_finder/src/config/app_routes.dart';
import 'package:sparring_finder/src/ui/theme/app_colors.dart';
import '../../widgets/custom_input_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loading_widget.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _onUpdatePassword() {
    if (_formKey.currentState!.validate()) {
      context.read<UserBloc>().add(
        UserResetPasswordRequested(
          code: _codeController.text.trim(),
          newPassword: _newPasswordController.text.trim(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

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
            return SingleChildScrollView(
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
                            'Reset password',
                            style: GoogleFonts.montserrat(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 9),
                    CustomInputField(
                      label: "Verification code",
                      hint: "Enter the code",
                      controller: _codeController,
                      validator: (value) {
                        if (value == null || value.isEmpty) return "Please enter code";
                        return null;
                      },
                    ),
                    const SizedBox(height: 9),
                    CustomInputField(
                      label: "New Password",
                      hint: "************",
                      isPassword: true,
                      controller: _newPasswordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) return "Please enter new password";
                        if (value.length < 6) return "At least 6 characters";
                        return null;
                      },
                    ),
                    const SizedBox(height: 9),
                    CustomInputField(
                      label: "Confirm New Password",
                      hint: "************",
                      isPassword: true,
                      controller: _confirmPasswordController,
                      validator: (value) {
                        if (value != _newPasswordController.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, AppRoutes.loginScreen),
                      child: RichText(
                        text: const TextSpan(
                          text: "Go back to ",
                          style: TextStyle(color: AppColors.label),
                          children: [
                            TextSpan(
                              text: "Login",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                    state is UserLoading
                        ? const LoadingWidget()
                        : CustomButton(
                      label: "Update Password",
                      onPressed: _onUpdatePassword,
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
