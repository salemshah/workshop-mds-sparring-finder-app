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

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      context.read<UserBloc>().add(
        UserForgotPasswordRequested(email: _emailController.text.trim()),
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
              Navigator.pushNamed(context, AppRoutes.resetPasswordScreen);
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
                            'Forgot Password',
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
                      label: "Email",
                      hint: "Enter your email",
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) return "Please enter email";
                        if (!value.contains('@')) return "Invalid email";
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
                      label: "Submit",
                      onPressed: _onSubmit,
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
