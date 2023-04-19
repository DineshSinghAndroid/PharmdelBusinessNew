import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:pharmdel/Controller/Helper/PrintLog/PrintLog.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../WidgetController/Popup/popup.dart';
import '../ConnectionValidator/ConnectionValidator.dart';

class RedirectCustom{
  RedirectCustom._privateConstructor();
  static final RedirectCustom instance = RedirectCustom._privateConstructor();

  static LocationData? _locationData;
  static PermissionStatus? _permissionGranted;
  // static Location? _location;

  static Future<void> makePhoneCall({required String phoneNumber}) async {
    var url = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<void> storeRedirect({required String urlString}) async {
    var url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<void> mapRedirectWithCustomerAddress({required String latitude,required String longitude,required String customerDetailAddress,required String customerDetailAddress1}) async {
    bool checkInternet = await ConnectionValidator().check();
    if (!checkInternet) {
      PopupCustom.showNoInternetPopUpWhenOffline(
          context: Get.overlayContext!,
          onValue: (value){

          }
      );
      return;
    }

    if (_locationData == null) {
      // if (_permissionGranted == PermissionStatus.granted) {
      //   _locationData = await _location?.getLocation();
      // }
    }

    PrintLog.printLog("Current location latitude:${_locationData?.latitude}");

    if(Platform.isAndroid){
      final AndroidIntent intent = AndroidIntent(
          action: 'action_view',
          data:
          Uri.encodeFull("https://www.google.com/maps/dir/?api=1&origin=${_locationData?.latitude},${_locationData?.longitude}"
              "&destination=$customerDetailAddress"),
          package: 'com.google.android.apps.maps');
      intent.launch();
    }else{
      MapsLauncher.launchQuery(customerDetailAddress1);

      MapsLauncher.launchCoordinates(
          double.parse(latitude),
          double.parse(longitude)
      );
    }

  }

  static Future<void> mapRedirect({required String lat,required String lng}) async {
    MapsLauncher.launchCoordinates(
        double.parse(lat.toString()), //lat will be dynamic
        double.parse(lng.toString()),  //lng will be dynamic
        'Google Headquarters are here'
    );
  }



}