
import 'package:dio/dio.dart';
import '../../Model/Notification/NotifficationResponse.dart';
import '../../Model/SetupPin/setupPin_model.dart';
import '../../main.dart';
import '../Helper/ConnectionValidator/ConnectionValidator.dart';
import '../Helper/PrintLog/PrintLog.dart';
import '../Helper/StringDefine/StringDefine.dart';
import '../WidgetController/Popup/PopupCustom.dart';
import '../WidgetController/Toast/ToastCustom.dart';
import 'WebConstant.dart';

class ApiController {
  Dio _dio = new Dio();

  Map<String, String> headers = {
    "Content-type": "application/json",
    "Authorization": 'Bearer $authToken',
    "Authkey": WebApiConstant.AUTH_KEY,
    "Connection": "Keep-Alive",
    "Keep-Alive": "timeout=5, max=1000"
  };

  ApiController() {
    BaseOptions options = BaseOptions(
        baseUrl: WebApiConstant.BASE_URL,
        receiveTimeout: 60 * 1000,
        connectTimeout: 60 * 1000,
        headers: headers);
    _dio.options = options;
  }



  /// Login Api
  // Future<LoginApiResponse?> loginApi({context, required String url, dictParameter, String? token}) async {
  //   LoginApiResponse? result;
  //   if (await ConnectionValidator().check()) {
  //     try {
  //       final response = await requestGetForApi(context: context, url: url,dictParameter: dictParameter,token: token);
  //       if (response?.data != null && response?.statusCode == 200) {
  //         result = LoginApiResponse.fromJson(response?.data);
  //         return result;
  //       } else {
  //         return result;
  //       }
  //     } catch (e) {
  //       PrintLog.printLog("Exception_main1: $e");
  //       return result;
  //     }
  //   } else {
  //     ToastCustom.showToast( msg: networkToastString);
  //   }
  //   return null;
  // }

  ///Setup Pin Api
  Future<SetupMPinApiResponse?> setupMPinApi({context, required String url, dictParameter, String? token}) async {
    SetupMPinApiResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestPostForApi(context: context, url: url,dictParameter: dictParameter,token: token!);
        if (response?.data != null && response?.statusCode == 200) {
          result = SetupMPinApiResponse.fromJson(response?.data);
          return result;
        } else {
          return result;
        }
      } catch (e) {
        PrintLog.printLog("Exception_main1: $e");
        return result;
      }
    } else {
      ToastCustom.showToast( msg: networkToastString);
    }
    return null;
  }

  ///Notification Api
  ///Notification Api
    Future<NotificationApiResponse?> getNotificaitonApi({context, required String url, dictParameter, String? token}) async {
    NotificationApiResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestGetForApi(context: context, url: url,dictParameter: dictParameter,token: token);
        if (response?.data != null && response?.statusCode == 200) {
          result = NotificationApiResponse.fromJson(response?.data);
          return result;
        } else {
          return result;
        }
      } catch (e) {
        PrintLog.printLog("Exception_main1: $e");
        return result;
      }
    } else {
      ToastCustom.showToast( msg: networkToastString);
    }
    return null;
  }

  Future<Response?> requestGetForApi(
      {required context,
      String? url,
      Map<String, dynamic>? dictParameter,
      String? token}) async {
    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authkey": WebApiConstant.AUTH_KEY,
        "Authorization": "Bearer $token",
        "Connection": "Keep-Alive",
        "Keep-Alive": "timeout=5, max=1000",
        // "x-localization":"en",
      };

      //  final prefs = await SharedPreferences.getInstance();
      // String userId = prefs.getString(AppSharedPreferences.userId) ?? "";
      //  String sessionId = prefs.getString(AppSharedPreferences.sessionId) ?? "";

      PrintLog.printLog("Headers: $headers");
      PrintLog.printLog("Url:  $url");
      PrintLog.printLog("Token:  $token");
      PrintLog.printLog("DictParameter: $dictParameter");

      BaseOptions options = BaseOptions(
          baseUrl: WebApiConstant.BASE_URL,
          receiveTimeout: 60 * 1000,
          connectTimeout: 60 * 1000,
          headers: headers,
          validateStatus: (_) => true
      );

      _dio.options = options;
      Response response = await _dio.get(url!, queryParameters: dictParameter);
      PrintLog.printLog("Response_headers: ${response.headers}");
      PrintLog.printLog("Response_data: ${response.data}");

      if(response.data["authenticated"] == false){
        // PopupCustom.logoutPopUP(context: context);
      }
      return response;

    } catch (error) {
      PrintLog.printLog("Exception_Main: $error");
      return null;
    }
  }


  Future<Response?> requestPostForApi(
      {required context,
      required String url,
      required Map<String, dynamic> dictParameter,
      required String token}) async {
    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authkey": WebApiConstant.AUTH_KEY,
        "Authorization": "Bearer $token",
        "Connection": "Keep-Alive",
        "Keep-Alive": "timeout=5, max=1000"
      };

      PrintLog.printLog("Headers: $headers");
      PrintLog.printLog("Url:  $url");
      PrintLog.printLog("Token:  $token");
      PrintLog.printLog("DictParameter: $dictParameter");

      BaseOptions options = BaseOptions(
          baseUrl: WebApiConstant.BASE_URL,
          receiveTimeout: 60 * 1000,
          connectTimeout: 60 * 1000,
          headers: headers);
      _dio.options = options;
      Response response = await _dio.post(url,
          data: dictParameter,
          options: Options(
              followRedirects: false,
              validateStatus: (status) => true,
              headers: headers));
      if(response.data["authenticated"] == false){
        // PopupCustom.logoutPopUP(context: context);
      }
      PrintLog.printLog("Response: $response");
      PrintLog.printLog("Response_headers: ${response.headers}");
      PrintLog.printLog("Response_realuri: ${response.realUri}");
      return response;
    } catch (error) {
      PrintLog.printLog("Exception_Main: $error");
      return null;
    }
  }

  Future<Response?> requestMultipartApi(
      {required context, String? url, formData, String? token}) async {
    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authkey": WebApiConstant.AUTH_KEY,
        "Authorization": "Bearer $token",
        "Connection": "Keep-Alive",
        "Keep-Alive": "timeout=5, max=1000"
      };

      PrintLog.printLog("Headers: $headers");
      PrintLog.printLog("Url:  $url");
      PrintLog.printLog("Token:  $token");
      PrintLog.printLog("formData: $formData");

      BaseOptions options = BaseOptions(
          baseUrl: WebApiConstant.BASE_URL,
          receiveTimeout: 60 * 1000,
          connectTimeout: 60 * 1000,
          headers: headers);

      _dio.options = options;
      Response response = await _dio.post(url!,
          data: formData,
          options: Options(
            followRedirects: false,
            validateStatus: (status) => true,
            headers: headers,
          ));

      PrintLog.printLog("Response: $response");

      if(response.data["authenticated"] == false){
        // PopupCustom.logoutPopUP(context: context);
      }
      return response;
    } catch (error) {
      PrintLog.printLog("Exception_Main: $error");
      return null;
    }
  }


}
