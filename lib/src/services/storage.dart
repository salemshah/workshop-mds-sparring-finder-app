import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_constants.dart';


class StorageService {
  late final SharedPreferences _pref;

  Future<StorageService> init() async {
    _pref = await SharedPreferences.getInstance();
    return this;
  }

  Future<bool> setString(String key, String value) async {
    return await _pref.setString(key, value);
  }

  Future<bool> setBool(String key, bool value) async {
    return await _pref.setBool(key, value);
  }

  String getString(String key) {
    return _pref.getString(key) ?? "";
  }

  Future<bool> resetStorage() async {
    final isCleared = await _pref.clear();
    return isCleared;
  }

  bool getDeviceFirstOpen() {
    return _pref.getBool(AppConstants.storageDeviceOpenFirstKey) ?? false;
  }


  bool isLoggedIn() {
    return _pref.getString(AppConstants.storageUserProfileKey) != null
        ? true
        : false;
  }
}