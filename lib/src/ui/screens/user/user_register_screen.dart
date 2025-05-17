import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparring_finder/src/blocs/user/user_bloc.dart';
import 'package:sparring_finder/src/blocs/user/user_event.dart';
import 'package:sparring_finder/src/blocs/user/user_state.dart';
import 'package:sparring_finder/src/ui/theme/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../widgets/custom_input_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/social_button.dart';
import '../../widgets/loading_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _onRegisterButtonPressed() {
    if (_formKey.currentState!.validate()) {
      context.read<UserBloc>().add(
        UserRegisterRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
    }
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
              Navigator.pushNamed(context, AppRoutes.verifyEmailScreen);
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
                            'Register',
                            style: GoogleFonts.montserrat(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    CustomInputField(
                      label: "Email",
                      hint: "Placeholder",
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) return "Please enter email";
                        if (!value.contains('@')) return "Invalid email";
                        return null;
                      },
                    ),
                    const SizedBox(height: 9),
                    CustomInputField(
                      label: "Password",
                      hint: "************",
                      isPassword: true,
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) return "Please enter password";
                        if (value.length < 6) return "At least 6 characters";
                        return null;
                      },
                    ),
                    const SizedBox(height: 9),
                    CustomInputField(
                      label: "Confirm password",
                      hint: "************",
                      isPassword: true,
                      controller: _confirmController,
                      validator: (value) {
                        if (value != _passwordController.text) return "Passwords do not match";
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    state is UserLoading
                        ? const LoadingWidget()
                        : CustomButton(label: "Register", onPressed: _onRegisterButtonPressed),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, AppRoutes.loginScreen),
                      child: RichText(
                        text: const TextSpan(
                          text: "Already have an Account? ",
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
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Expanded(child: Divider(color: AppColors.label, thickness: 1)),
                        Container(
                          alignment: Alignment.center,
                          height: 30,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: const Text("OR", style: TextStyle(color: AppColors.primary)),
                        ),
                        const Expanded(child: Divider(color: AppColors.label, thickness: 1)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SocialButton(
                      text: 'Sign up with Google',
                      assetPath: 'assets/icons/google_logo.png',
                      onPressed: () {
                        // Google sign in logic
                      },
                    ),
                    const SizedBox(height: 10),
                    SocialButton(
                      text: 'Sign up with Apple',
                      assetPath: 'assets/icons/apple_logo.png',
                      onPressed: () {
                        // Apple sign in logic
                      },
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
