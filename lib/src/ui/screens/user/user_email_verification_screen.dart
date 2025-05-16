import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_verification_code_field/flutter_verification_code_field.dart';
import 'package:sparring_finder/src/blocs/user/user_bloc.dart';
import 'package:sparring_finder/src/blocs/user/user_event.dart';
import 'package:sparring_finder/src/blocs/user/user_state.dart';
import 'package:sparring_finder/src/config/routes.dart';

class UserEmailVerificationScreen extends StatefulWidget {
  const UserEmailVerificationScreen({super.key});

  @override
  State<UserEmailVerificationScreen> createState() => _UserEmailVerificationScreenState();
}

class _UserEmailVerificationScreenState extends State<UserEmailVerificationScreen> {
  String _code = '';
  bool _isFilled = false;

  Timer? _timer;
  int _start = 120;
  bool _isResendEnabled = false;
  String _email = '';

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    setState(() {
      _start = 120;
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

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Email Verification')),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.loginScreen,
                  (route) => false,
            );
          } else if (state is UserFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                VerificationCodeField(
                  autofocus: true,
                  length: 6,
                  hasError: false,
                  spaceBetween: 10,
                  size: const Size(40, 40),
                  onFilled: (value) {
                    setState(() {
                      _code = value;
                      _isFilled = value.length == 6;
                    });
                  },
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _isFilled ? _submitCode : null,
                  child: const Text('Confirm'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isResendEnabled ? _resendCode : null,
                  child: _isResendEnabled
                      ? const Text('Resend Verification Code')
                      : Text('Resend Code in $_start s'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
