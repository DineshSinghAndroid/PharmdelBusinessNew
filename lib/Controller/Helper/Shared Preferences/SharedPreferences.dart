import 'package:shared_preferences/shared_preferences.dart';
import '../PrintLog/PrintLog.dart';

class AppSharedPreferences {
  static SharedPreferences? _preferences;

  static Future<SharedPreferences?> getInstance() async {
    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
      return _preferences;
    }
    return _preferences;
  }


  static String authToken = "token";
  static String fcmToken = "fcm_token";
  static String userId = "user_id";
  static String customerID = "customer_id";
  static String userType = "user_type";
  static String driverType = "driver_type";
  static String startMiles = "start_miles";
  static String endMiles = "endMiles";
  static String userName = "username";
  static String pharmacyID = "pharmacyID";
  static String userPin = "userPin";
  static String showWages = "showWages";

  static String routeID = "route_id";
  static String isRouteStart = "is_route_start";
  static String deviceID = "device_id";



  /// ADD DATA
  static addStringValueToSharedPref(
      {required String variableName, required String variableValue}) async {
    await _preferences?.setString(variableName, variableValue);
  }

  static addBoolValueToSharedPref(
      {required String variableName, required bool variableValue}) async {
    await _preferences?.setBool(variableName, variableValue);
  }

  static addIntValueToSharedPref(
      {required String variableName, required int variableValue}) async {
    await _preferences?.setInt(variableName, variableValue);
  }

  static addStringListValueToSharedPref(
      {required String variableName,
      required List<String> variableValue}) async {
    await _preferences?.setStringList(variableName, variableValue);
  }

  ///GET DATA
  static String? getStringFromSharedPref({required String variableName}) {
    String? returnValue = _preferences?.getString(variableName);
    return returnValue;
  }

  static int? getIntValueFromSharedPref({required String variableName}) {
    int? returnValue = _preferences?.getInt(variableName);
    return returnValue;
  }

  static bool? getBoolValueFromSharedPref({required String variableName}) {
    bool? returnValue = _preferences?.getBool(variableName);
    return returnValue;
  }

  static List<String>? getStringListValueFromSharedPref(
      {required String variableName}) {
    List<String>? returnValue = _preferences?.getStringList(variableName);
    return returnValue;
  }

  ///CLEAR SHARED PREFERENCE
  static Future clearSharedPref() async {
    PrintLog.printLog("Shared Preference clean...");
    _preferences?.clear();
  }
}
