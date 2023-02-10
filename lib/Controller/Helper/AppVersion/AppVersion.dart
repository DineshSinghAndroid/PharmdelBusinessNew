import 'package:package_info_plus/package_info_plus.dart';

class AppVersionCustom{

  static Future<String?> getAppVersion()async{
    String? appVersion;
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) async {
      appVersion = packageInfo.version;
    });
    return appVersion;
  }


  static Future<String?> getBuildVersion()async{
    String? buildVersion;
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) async {
      buildVersion = packageInfo.buildNumber;
    });
    return buildVersion;
  }
}