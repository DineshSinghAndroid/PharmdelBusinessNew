import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/web_constent.dart';
import '../../model/VirModel/vir_api_model.dart';
import '../../ui/login_screen.dart';
import '../../util/connection_validater.dart';
import '../../util/log_print.dart';

class ApiController {
  ///Get Update Profile Data

  Future<VirUploadApiModel?> virUploadApi({
    context,
    required String url,
    required dictData,
    String? token,
  }) async {
    VirUploadApiModel? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestPostApi(context: context, url: url, dictData: dictData, token: token);
        if (response?.data != null && response?.statusCode == 200) {
          result = VirUploadApiModel.fromJson(response?.data);
          return result;
        } else {
          return result;
        }
      } catch (e) {
        PrintLog.printLog("Exception_main1: $e");
        return result;
      }
    } else {
      Fluttertoast.showToast(msg: "Please check network connection and try again!");
    }
    return result;
  }

  Future<Response?> requestPostApi({required context, String? url, required dictData, String? token}) async {
    Dio _dio = new Dio();
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        "Content-type": "application/json",
        "Authorization": 'Bearer $token'
      };

      PrintLog.printLog("Headers: $headers");
      PrintLog.printLog("Url:  $url");
      PrintLog.printLog("Token:  $token");
      PrintLog.printLog("formData: $dictData");

      BaseOptions options = BaseOptions(
          baseUrl: WebConstant.BASE_URL, receiveTimeout: 60 * 1000, connectTimeout: 60 * 1000, headers: headers);

      _dio.options = options;
      Response response = await _dio.post(url!,
          data: dictData,
          options: Options(
            followRedirects: false,
            validateStatus: (status) => true,
            headers: headers,
          ));

      PrintLog.printLog("Response: $response");

      if (response.statusCode == 401) {
        final prefs = await SharedPreferences.getInstance();
        prefs.remove('token');
        prefs.remove('userId');
        prefs.remove('name');
        prefs.remove('email');
        prefs.remove('mobile');
        prefs.setBool(WebConstant.IS_LOGIN, false);
        Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
              return LoginScreen();
            }, transitionsBuilder: (BuildContext context, Animation<double> animation,
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
      }
      return response;
    } catch (error) {
      PrintLog.printLog("Exception_Main: $error");
      return null;
    }
  }
}
