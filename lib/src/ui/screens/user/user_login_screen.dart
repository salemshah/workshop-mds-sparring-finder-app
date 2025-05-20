import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparring_finder/src/blocs/user/user_bloc.dart';
import 'package:sparring_finder/src/blocs/user/user_event.dart';
import 'package:sparring_finder/src/blocs/user/user_state.dart';
import 'package:sparring_finder/src/ui/theme/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_input_field.dart';
import '../../widgets/social_button.dart';
import '../../widgets/loading_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: "salemshahdev@gmail.com");
  final _passwordController = TextEditingController(text: "123456");

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginButtonPressed() {
    if (_formKey.currentState!.validate()) {
      context.read<UserBloc>().add(
        UserLoginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return BlocConsumer<UserBloc, UserState>(
              listener: (context, state) {
                if (state is UserAuthenticated) {
                  Navigator.pushReplacementNamed(context, AppRoutes.loadingScreen);
                } else if (state is UserFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                                    'Login',
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
                              label: 'Email',
                              hint: 'Enter your email',
                              controller: _emailController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!value.contains('@')) {
                                  return 'Enter a valid email address';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 9),
                            CustomInputField(
                              label: 'Password',
                              hint: '************',
                              isPassword: true,
                              controller: _passwordController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),


                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () => Navigator.pushNamed(context, AppRoutes.forgotPasswordScreen),
                                child: const Text(
                                  'Forgot Password?',
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ),
                            ),
                            state is UserLoading
                                ? const LoadingWidget()
                                : CustomButton(
                              label: 'Login',
                              onPressed: _onLoginButtonPressed,
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: () => Navigator.pushNamed(context, AppRoutes.registerScreen),
                              child: RichText(
                                text: const TextSpan(
                                  text: "Don't have an Account? ",
                                  style: TextStyle(color: AppColors.label),
                                  children: [
                                    TextSpan(
                                      text: "Sign up here",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 9),
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
                              text: 'Sign in with Google',
                              assetPath: 'assets/icons/google_logo.png',
                              onPressed: () {
                                // Google sign in logic
                              },
                            ),
                            const SizedBox(height: 10),
                            SocialButton(
                              text: 'Sign in with Apple',
                              assetPath: 'assets/icons/apple_logo.png',
                              onPressed: () {
                                // Apple sign in logic
                              },
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}