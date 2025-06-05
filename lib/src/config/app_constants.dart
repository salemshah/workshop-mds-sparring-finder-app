
const bool isProduction = false;

const String devHost = '172.20.10.3';

class _DevEndpoints {
  static final String apiBase = 'http://$devHost:8000/api';
  static final String socketBase = 'http://$devHost:8000';
}

class _ProdEndpoints {
  static const String apiBase = 'https://sparring-finder-app.duckdns.org/api';
  static const String socketBase = 'https://sparring-finder-app.duckdns.org';
}

class AppConstants {
  static String get apiBaseUrl =>
      isProduction ? _ProdEndpoints.apiBase : _DevEndpoints.apiBase;

  static String get socketBaseUrl =>
      isProduction ? _ProdEndpoints.socketBase : _DevEndpoints.socketBase;


  //TODO: REMOVE IN THE FEATURE
  static const String storageUserProfileKey = "user_profile";
  static const String storageUserTokenKey = "user_token";
  static const String storageDeviceOpenFirstKey = "first_time";
}
