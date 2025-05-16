import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sparring_finder/src/config/routes.dart';
import 'package:sparring_finder/src/ui/screens/home/home_screen.dart';
import 'package:sparring_finder/src/ui/screens/user/user_email_verification_screen.dart';
import 'package:sparring_finder/src/ui/screens/user/user_login_screen.dart';

// Import utils and themes
import 'package:sparring_finder/src/utils/font_size.dart';

// Import ApiService, repository, and bloc
import 'package:sparring_finder/src/services/api_service.dart';
import 'package:sparring_finder/src/repositories/user_repository.dart';
import 'package:sparring_finder/src/blocs/user/user_bloc.dart';
import 'package:sparring_finder/src/ui/screens/user/user_register_screen.dart';

void main() {
  runApp(MindaApp());
}

class MindaApp extends StatelessWidget {
  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  MindaApp({super.key});

  @override
  Widget build(BuildContext context) {
    FontSize(context);

    final ApiService apiService = ApiService(
      baseUrl: "http://localhost:8000/api",
      // baseUrl: "https://minda-app.store/api",
      secureStorage: const FlutterSecureStorage(),
    );

    final UserRepository userRepository = UserRepository(apiService: apiService);

    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(userRepository: userRepository),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorObservers: [routeObserver],
        home: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;

            final dynamicDesignSize = Size(width, height);

            return ScreenUtilInit(
              designSize: dynamicDesignSize,
              minTextAdapt: true,
              splitScreenMode: true,
              builder: (context, child) {
                return const UserRegisterScreen();
              },
            );
          },
        ),
        routes: {
          Routes.registerScreen: (context) => const UserRegisterScreen(),
          Routes.loginScreen: (context) => const UserLoginScreen(),
          Routes.verifyEmailScreen: (context) => const UserEmailVerificationScreen(),
          Routes.homeScreen: (context) => const HomeScreen(),
        },
      ),
    );
  }
}
