import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:sparring_finder/src/services/notification_service.dart';
import 'package:sparring_finder/src/config/repository_provider.dart';
import 'package:sparring_finder/src/config/bloc_providers.dart';
import 'package:sparring_finder/src/config/app_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparring_finder/src/ui/screens/splash/splash_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // the init() will be triggered after login, to store fcm token
  final notificationService = NotificationService();

  runApp(MindaApp(notificationService: notificationService));
}

class MindaApp extends StatelessWidget {
  final NotificationService notificationService;

  const MindaApp({super.key, required this.notificationService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: RepositoryProviders.getAll(notificationService),
      child: MultiBlocProvider(
        providers: BlocProviders.all,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: AppRoutes.staticRoutes,
          onGenerateRoute: AppRoutes.generateRoute,
          initialRoute: AppRoutes.splashScreen,
          navigatorObservers: [RouteObserver<PageRoute>()],
          home: LayoutBuilder(
            builder: (context, constraints) {
              return ScreenUtilInit(
                designSize: constraints.biggest,
                minTextAdapt: true,
                splitScreenMode: true,
                builder: (_, __) => const SplashScreen(),
              );
            },
          ),
        ),
      ),
    );
  }
}
