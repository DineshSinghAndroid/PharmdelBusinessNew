// @dart=2.9
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

// import 'package:progress_dialog/progress_dialog.dart';
import 'package:pharmdel_business/data/web_constent.dart';
import 'package:pharmdel_business/ui/login_screen.dart';
import 'package:pharmdel_business/util/connection_validater.dart';
import 'package:pharmdel_business/util/toast_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../util/custom_loading.dart';
import '../util/sentryExeptionHendler.dart';

class ApiCallFram {
  http.Response response;

  Future<http.Response> postDataAPI(String postURL, String accessToken, Map<String, dynamic> prams,
      BuildContext mContext) async {
    bool checkInternet = await ConnectionValidator().check();
    // print(checkInternet);
    if (checkInternet) {
      Map<String, String> head = {
        'Accept': 'application/json',
        'Content-type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      };

      log(prams.toString());
      log("prams");
      final response = await http.post(Uri.parse(postURL), body: json.encode(prams), headers: head);
      if (response.statusCode == 200) {
        // print("response: " + response.body.toString());
        return response;
      } else {
        log(response.body);
        handleErrorWithStatus(response.statusCode, mContext);
        // print("response: " + response.body.toString());
      }
    } else {
      ToastUtils.showCustomToast(mContext, "Something went wrong, Failed connection with server.");
      return null;
    }
  }

  Future<http.Response> postFormBackgroundDataAPI(String postURL, String accessToken,
      Map<String, dynamic> prams) async {
    // bool checkInternet = await ConnectionValidator().check();
    // print(checkInternet);
    log("PrintLog10");
    // if (checkInternet) {
    Map<String, String> head = {
      'Accept': 'application/json',
      'Content-type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    // print(accessToken);
    // print(postURL);
    // print("Post Body : ${json.encode(prams)}");
    // print("Post Body : ${json.encode(prams)}");
    log(prams.toString());
    // final response = await http.post(Uri.parse(postURL),
    //     body: json.encode(prams), headers: head);

    var request = http.MultipartRequest("POST", Uri.parse(postURL));
    request.fields.addAll({'Model': json.encode(prams)});
    request.headers.addAll(head);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      // print("response: " + response.body.toString());
      return response;
    } else {
      return null;
      // handleErrorWithStatus(response.statusCode, mContext);
      // print("response: " + response.body.toString());
    }
    // } else {
    //   log("PrintLog14");
    //   return null;
    // }
  }

  Future<http.Response> postFormDataAPI(String postURL, String accessToken, String prams, BuildContext mContext) async {
    bool checkInternet = await ConnectionValidator().check();
    if (checkInternet) {
      Map<String, String> head = {
        'Accept': 'application/json',
        'Content-type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      };
      logger.w(postURL);
      // print(postURL);
      try {
        Uri uri = Uri.parse(postURL);
        var request = http.MultipartRequest("POST", uri);
        request.headers.addAll(head);
        // request.fields["scan_type"] = "1";
        request.fields["prescription_info"] = prams;
        log("Post Body : ${request.fields}");
        log(accessToken);
        if (await ConnectionValidator().check()) {
          var streamedResponse = await request.send();
          var response = await http.Response.fromStream(streamedResponse);
          // print("response: " + response.body.toString());
          if (streamedResponse.statusCode != 200) {
            handleErrorWithStatus(response.statusCode, mContext);
          }
          return response;
        } else {
          ToastUtils.showCustomToast(mContext, 'Please check network connection and try again !');
        }
        return null;
      } catch (e, stackTrace) {
        SentryExemption.sentryExemption(e, stackTrace);
        Navigator.of(mContext).pop(true);
        ToastUtils.showCustomToast(mContext, "$e");
        return null;
      }
    } else {
      ToastUtils.showCustomToast(mContext, "Something went wrong, Failed connection with server.");
      return null;
    }
  }

  Future<http.Response> getDataRequestAPI(String requestedURL, String accessToken, BuildContext mContext) async {
    bool checkInternet = await ConnectionValidator().check();
    // print(checkInternet);
    if (checkInternet) {
      Map<String, String> headers = {
        'Accept': 'application/json',
        "Content-type": "application/json",
        "Authorization": 'Bearer $accessToken'
      };

      // print("Access token: $accessToken");
      // print(requestedURL);
      log(requestedURL);
      try {
        final response = await http.get(Uri.parse(requestedURL), headers: headers);
        // print("response: " + response.body.toString());
        if (response.statusCode == 200) {
          return response;
        } else {
          handleErrorWithStatus(response.statusCode, mContext);
        }
        return null;
      } catch (e, stackTrace) {
        SentryExemption.sentryExemption(e, stackTrace);
        // ProgressDialog(mContext).hide();
        CustomLoading().showLoadingDialog(mContext, false);

        // print("response: " + e.toString());
        ToastUtils.showCustomToast(mContext, "Something went wrong, Failed connection with server.");
        return null;
      }
    } else {
      ToastUtils.showCustomToast(mContext, "Something went wrong, Failed connection with server.");
      return null;
    }
  }

  Future<http.Response> postFilesWithDataMaps(String postURL, String accessToken, Map<String, dynamic> prams, File file,
      BuildContext mContext) async {
    log(postURL);
    bool checkInternet = await ConnectionValidator().check();
    if (checkInternet) {
      try {
        Map<String, String> head = {
          'Accept': 'application/json',
          'Content-type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        };
        // print(accessToken);
        // print(postURL);

        Uri uri = Uri.parse(postURL);
        var request = http.MultipartRequest("POST", uri);
        request.fields.addAll({'Model': json.encode(prams)});

        if (file != null) {
          // print("file availabe");
          request.files.add(await http.MultipartFile.fromPath('file', file.path));
          //fromBytes("file", file.readAsBytesSync()));
        }
        request.headers.addAll(head);
        log("Post Body : ${request.fields}");
        var streamedResponse = await request.send();
        response = await http.Response.fromStream(streamedResponse);

        if (streamedResponse.statusCode != 200) {
          handleErrorWithStatus(response.statusCode, mContext);
          // print("response: "+response.body.toString());
        }

        return response;
      } catch (e, stackTrace) {
        SentryExemption.sentryExemption(e, stackTrace);
        // print(e);
        return null;
      }
    } else {
      ToastUtils.showCustomToast(mContext, "Something went wrong, Failed connection with server.");
      return response;
    }
  }

  Future<void> handleErrorWithStatus(int statusCode, BuildContext mContext) async {
    try {
      if (statusCode == 401) {
        final prefs = await SharedPreferences.getInstance();
        prefs.remove(WebConstant.ACCESS_TOKEN);
        prefs.remove(WebConstant.USER_ID);
        prefs.remove(WebConstant.USER_NAME);
        prefs.remove(WebConstant.USER_EMAIL);
        prefs.remove(WebConstant.USER_MOBILE);
        // global.channel.sink.close();
        Navigator.pushAndRemoveUntil(
            mContext,
            PageRouteBuilder(pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
              return LoginScreen();
            },
                transitionsBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation, Widget child) {
                  return new SlideTransition(
                    position: new Tween<Offset>(
                      begin: const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                }),
                (Route route) => false);
        ToastUtils.showCustomToast(mContext, "Session expired, Login again");
      } else if (statusCode == 400) {
        ToastUtils.showCustomToast(mContext, "Invalid request!");
      } else if (statusCode == 403) {
        ToastUtils.showCustomToast(mContext, "You don't have permission to access the requested resource");
      } else if (statusCode == 404) {
        ToastUtils.showCustomToast(mContext, "The requested resource does not exist");
      } else if (statusCode == 500) {
        ToastUtils.showCustomToast(mContext, "Internal Server Error");
      } else if (statusCode == 503) {
        ToastUtils.showCustomToast(mContext, "Service Unavailable");
      } else if (statusCode == 111) {
        ToastUtils.showCustomToast(mContext, "Service Connection Refused");
      } else {
        ToastUtils.showCustomToast(mContext, WebConstant.ERRORMESSAGE);
      }
    } catch (_, stackTrace) {
      SentryExemption.sentryExemption(_, stackTrace);
    }
  }
}
