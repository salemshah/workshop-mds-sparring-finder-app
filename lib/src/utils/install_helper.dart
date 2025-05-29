import 'package:shared_preferences/shared_preferences.dart';
import 'package:sparring_finder/src/utils/jwt.dart';
import 'package:sparring_finder/src/utils/secure_storage_helper.dart';

class InstallHelper {
  static const String _installKey = 'hasInstalled';

  /// Checks if this is the first launch after install.
  /// If yes, clears secure storage and sets the flag.
  static Future<void> handleFreshInstall() async {
    final prefs = await SharedPreferences.getInstance();
    final hasInstalled = prefs.getBool(_installKey) ?? false;

    if (!hasInstalled) {
      await JwtStorageHelper.clearTokens();
      await SecureStorageHelper.clearAll();
      await prefs.setBool(_installKey, true);
      print('🧼 Fresh install detected. Cleared tokens.');
    } else {
      print('🚀 Not a fresh install. Tokens preserved.');
    }
  }
}
