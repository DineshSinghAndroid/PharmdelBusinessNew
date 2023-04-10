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


  static String appVersion = "app_version";
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
  static String updateMiles = "updateMiles";

  static String routeID = "route_id";
  static String companyID = "device_id";
  static String lunchBreakStatus = "lunch_break_status";

  static String userEmail = "user_email";
  static String userMobile = "user_mobile";
  static String userStatus = "user_status";
  static String isAddressUpdated = "address_update";
  static String isStartRoute = "is_start_route";
  static String deliveryType = "delivery_type";
  static String forgotMPin = "forgot_mpin";

  /// Use for On Start Route PopUp
  static const String startRouteId = "start_route_id";
  static const String endRouteId = "end_route_id";

  static String userDeliveryLastTime = "user_last_time";
  static String deliveryTime = "delivery_time";

  static String vehicleId = "vehicle_id";



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

  static removeValueToSharedPref(
      {required String variableName}) async {
    await _preferences?.remove(variableName);
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
