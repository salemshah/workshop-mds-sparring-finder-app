import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparring_finder/src/blocs/user/user_bloc.dart';
import 'package:sparring_finder/src/blocs/user/user_event.dart';
import 'package:sparring_finder/src/blocs/user/user_state.dart';
import 'package:sparring_finder/src/config/routes.dart';
import 'package:sparring_finder/src/ui/widgets/custom_text_field.dart';
import 'package:sparring_finder/src/ui/widgets/loading_widget.dart';

class UserRegisterScreen extends StatefulWidget {
  const UserRegisterScreen({super.key});

  @override
  State<UserRegisterScreen> createState() => _UserRegisterScreenState();
}

class _UserRegisterScreenState extends State<UserRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          double textScaleFactor = constraints.maxWidth / 600;

          return BlocConsumer<UserBloc, UserState>(
            listener: (context, state) {
              if (state is UserSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green,
                  ),
                );

                Navigator.pushNamed(context, Routes.verifyEmailScreen);
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
                child: SizedBox(
                  height: size.height,
                  child: Stack(
                    children: [
                      ClipPath(
                        clipper: WaveClipper(),
                        child: Container(
                          height: size.height * 0.38,
                          width: double.infinity,
                          color: const Color(0xFF6959C3),
                        ),
                      ),
                      Positioned(
                        top: size.height * 0.05,
                        left: 0,
                        right: 0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // SizedBox(
                            //   height: size.height * 0.15,
                            //   child: Image.asset(
                            //     'assets/images/spaceship.png',
                            //     fit: BoxFit.contain,
                            //   ),
                            // ),
                            const SizedBox(height: 10),
                            Text(
                              'Create Account',
                              style: TextStyle(
                                fontSize: 32 * textScaleFactor,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Join the family',
                              style: TextStyle(
                                fontSize: 16 * textScaleFactor,
                                color: Colors.white.withAlpha(230),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: size.height * 0.35 - 40,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                const SizedBox(height: 80),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: CustomTextFormField(
                                    prefixIcon: Icons.email,
                                    controller: _emailController,
                                    hintText: 'Email',
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter email";
                                      }
                                      if (!value.contains('@')) {
                                        return "Please enter a valid email";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: CustomTextFormField(
                                    prefixIcon: Icons.lock,
                                    obscureText: true,
                                    controller: _passwordController,
                                    hintText: 'Password',
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter password";
                                      }
                                      if (value.length < 6) {
                                        return "Password must be at least 6 characters";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20),
                                state is UserLoading
                                    ? const LoadingWidget()
                                    : SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: _onRegisterButtonPressed,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                      const Color(0xFF6959C3),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      'Register',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.loginScreen);
                                    },
                                    child: const Text(
                                      'I already have an account',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 30);
    path.quadraticBezierTo(
        firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(size.width * 3 / 4, size.height - 80);
    var secondEndPoint = Offset(size.width, size.height - 40);
    path.quadraticBezierTo(
        secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}