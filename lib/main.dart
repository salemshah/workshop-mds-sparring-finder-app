import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:sparring_finder/src/blocs/notification/notification_bloc.dart';
import 'package:sparring_finder/src/services/notification_service.dart';
import 'package:sparring_finder/src/config/repository_provider.dart';
import 'package:sparring_finder/src/config/bloc_providers.dart';
import 'package:sparring_finder/src/config/app_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparring_finder/src/ui/screens/splash/splash_screen.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const InitApp());
}

class InitApp extends StatefulWidget {
  const InitApp({super.key});

  @override
  State<InitApp> createState() => _InitAppState();
}

class _InitAppState extends State<InitApp> {
  late final Future<List<Provider>> _futureProviders;
  final notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _futureProviders = RepositoryProviders.init(notificationService);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Provider>>(
      future: _futureProviders,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        return MultiProvider(
          providers: snapshot.data!,
          child: MultiBlocProvider(
            providers: BlocProviders.all(notificationService),
            child: Builder(
              builder: (context) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  final bloc = context.read<NotificationBloc>();
                  // Wait until NotificationBloc is created, then safely register listener
                  NotificationService.handleNotificationTap(bloc);
                });
                return MaterialApp(
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
      },
    );
  }
}
