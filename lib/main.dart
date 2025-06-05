import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:sparring_finder/src/config/repository_provider.dart';
import 'package:sparring_finder/src/config/bloc_providers.dart';
import 'package:sparring_finder/src/config/app_routes.dart';
import 'package:sparring_finder/src/services/notification_service.dart';
import 'package:sparring_finder/src/blocs/notification/notification_bloc.dart';
import 'package:sparring_finder/src/ui/screens/splash/splash_screen.dart';

import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Force portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const InitApp());
}

class InitApp extends StatefulWidget {
  const InitApp({super.key});

  @override
  State<InitApp> createState() => _InitAppState();
}

class _InitAppState extends State<InitApp> {
  late final List<Provider> _providers;
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _providers = RepositoryProviders.init(_notificationService);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: _providers,
      child: MultiBlocProvider(
        providers: BlocProviders.all(_notificationService),
        child: Builder(
          builder: (context) {
            // After the first frame, register the notification tap handler
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final bloc = context.read<NotificationBloc>();
              NotificationService.handleNotificationTap(bloc);
            });

            return MaterialApp(
              key: navigatorKey,
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
            );
          },
        ),
      ),
    );
  }
}
