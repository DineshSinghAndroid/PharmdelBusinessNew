import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoCustom{
  static Future<String?> getPlatForm() async {
    String? platForm;
    if (Platform.isAndroid) {
      platForm = "android";
    } else if (Platform.isIOS) {
      platForm = "ios";
    }
    return platForm;
  }

  static Future<String?> getDeviceName() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if(Platform.isIOS) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.model;
    } else if(Platform.isAndroid) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.utsname.machine;
    }
    return "";
  }
}

