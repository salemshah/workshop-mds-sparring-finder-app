import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sparring_finder/src/services/storage.dart';


class Global {

  static late StorageService storageService;

  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    storageService = await StorageService().init();
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
   
  }
}
