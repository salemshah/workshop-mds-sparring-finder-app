import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparring_finder/src/config/bloc_providers.dart';
import 'package:sparring_finder/src/config/app_routes.dart';
import 'package:sparring_finder/src/config/repository_provider.dart';
import 'package:sparring_finder/src/ui/screens/splash/splash_screen.dart';
import 'package:provider/provider.dart';

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
    return MultiProvider(
      providers: RepositoryProviders.all,
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