import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparring_finder/src/config/bloc_providers.dart';
import 'package:sparring_finder/src/config/app_routes.dart';
import 'package:sparring_finder/src/ui/screens/user/user_login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Force portrait orientation only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MindaApp());
}


class MindaApp extends StatelessWidget {
  const MindaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: BlocProviders.all,
      child: MaterialApp(
        onGenerateRoute: AppRoutes.generateRoute,
        initialRoute: AppRoutes.verifyEmailScreen,
        debugShowCheckedModeBanner: false,
        navigatorObservers: [RouteObserver<PageRoute>()],
        home: LayoutBuilder(
          builder: (context, constraints) {
            return ScreenUtilInit(
              designSize: constraints.biggest,
              minTextAdapt: true,
              splitScreenMode: true,
              builder: (context, child) => const LoginScreen(),
            );
          },
        ),
      ),
    );
  }
}