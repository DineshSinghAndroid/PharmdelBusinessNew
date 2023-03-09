

import 'dart:developer' as logs;

import 'package:dio/dio.dart';
import 'package:get/get.dart' as G;
import 'package:pharmdel/Model/DriverDashboard/driverDashboardResponse.dart';
import 'package:pharmdel/Model/NotificationCount/notificationCountResponse.dart';
import '../../Model/AllDelivery/allDeliveryApiResponse.dart';
import '../../Model/CreateNotification/createNotificationResponse.dart';
import '../../Model/DriverList/driverListResponse.dart';
import '../../Model/CreatePatientModel/create_patient_model.dart';
import '../../Model/DriverProfile/profileDriverResponse.dart';
import '../../Model/DriverRoutes/driverRoutesResponse.dart';
import '../../Model/ForgotPassword/forgotPasswordResponse.dart';
import '../../Model/GetPatient/getPatientApiResponse.dart';
import '../../Model/Login/login_model.dart';
import '../../Model/LunchBreak/lunchBreakResponse.dart';
import '../../Model/Notification/NotifficationResponse.dart';
import '../../Model/OrderDetails/orderdetails_response.dart';
import '../../Model/PharmacyModels/P_GetDriverListModel/P_GetDriverListModel.dart';
import '../../Model/PharmacyModels/P_GetDriverRoutesListPharmacy/P_get_driver_route_list_model_pharmacy.dart';
import '../../Model/PharmacyModels/PharmacyProfile/p_profileApiResponse.dart';
import '../../Model/SaveNotification/saveNotificationResponse.dart';
import '../../Model/SetupPin/setupPin_model.dart';
import '../../Model/UpdateProfile/updateProfileResponse.dart';
import '../../Model/UpdateCustomerWithOrder/UpdateCustomerWithOrder.dart';
import '../../Model/VehicleList/vehicleListResponse.dart';
import '../../main.dart';
import '../Helper/ConnectionValidator/ConnectionValidator.dart';
import '../Helper/PrintLog/PrintLog.dart';
import '../Helper/Shared Preferences/SharedPreferences.dart';
import '../RouteController/RouteNames.dart';
import '../WidgetController/Loader/LoadingScreen.dart';
import '../WidgetController/Popup/PopupCustom.dart';
import '../WidgetController/StringDefine/StringDefine.dart';
import '../WidgetController/Toast/ToastCustom.dart';
import 'WebConstant.dart';

class ApiController {
  final Dio _dio = Dio();


  /// Login Api
  Future<LoginModel?> getLoginApi({context, required String url, dictParameter, String? token}) async {
    LoginModel? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestPostForApi(context: context, url: url,dictParameter: dictParameter,token: token ??'');
        if (response?.data != null && response!.statusCode == 200) {
          result = LoginModel.fromJson(response.data);
          return result;
        } else {
          ToastCustom.showToast(msg: response?.statusMessage.toString()??"");
        }
      } catch (e) {
        PrintLog.printLog("Exception_main1s: $e");
        return result;
      }
    } else {
      ToastCustom.showToast( msg: networkToastString);
    }
    return null;
  }



  /// Logout Api
  Future getLogoutApi({context, required String url, dictParameter, String? token}) async {
     if (await ConnectionValidator().check()) {
      try {
        final response = await requestGetForApi(context: context, url: url,dictParameter: dictParameter, token: authToken);
         if (response?.data != null && response!.statusCode == 200) {
         return response;
        }
      } catch (e) {
        PrintLog.printLog("Exception_main1s: $e");
      }
    } else {
      ToastCustom.showToast( msg: networkToastString);
    }
    return null;
  }


  ///Forgot Password
  Future<ForgotPasswordApiResponse?> getForgotPasswordApi({context, required String url, dictParameter, String? token}) async {
    ForgotPasswordApiResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestPostForApi(context: context, url: url,dictParameter: dictParameter,token: token ??'');
        if (response?.data != null && response?.statusCode == 200) {
          result = ForgotPasswordApiResponse.fromJson(response?.data);
          print("THIS IS API RESULT FOR LOGIN API $result");
          return result;
        } else {
          print("THIS IS API RESULT FOR LOGIN API $result");
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


  ///Setup Pin Api
  Future<SetUpPinModel?> setMPinAPi({context, required String url, dictParameter, String? token}) async {
    SetUpPinModel? _result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestPostForApi(context: context, url: url,dictParameter: dictParameter,token: token ??'');
        if (response?.data != null && response!.statusCode == 200) {
          _result = SetUpPinModel.fromJson(response.data);
          return _result;
        } else {
          ToastCustom.showToast(msg: response?.statusMessage.toString()??"");
        }
      } catch (e) {
        PrintLog.printLog("Exception_main1s: $e");
        return _result;
      }
    } else {
      ToastCustom.showToast( msg: networkToastString);
    }
    return null;
  }

///Create Patient Api
  Future<CreatePatientModelResponse?> createPatientApi({context, required String url,
    dictParameter, String? token}) async {
    CreatePatientModelResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestPostForApi(context: context, url: url,dictParameter: dictParameter,token: token ??'');
         print(response.toString());
        if (response?.data != null && response!.statusCode == 200) {
          result = CreatePatientModelResponse.fromJson(response.data);
          print("THIS IS API RESULT FOR CREATE PATIENT POST TYPE :::::>>>>>>>>>>>>>>>>>> ${result.toString()}");
          return result;
        } else {
          return result;
         }
      } catch (e) {

        PrintLog.printLog("Exception_main1s: $e");

        return result;

      }
    } else {
      ToastCustom.showToast( msg: networkToastString);
    }
    return null;
   }



   ///UPDATE CUSTOMER WITH ORDER
  Future<UpdateCustomerWithOrderModel?> updateCustomerWithOrder({context, required String url,
    dictParameter, String? token}) async {
    UpdateCustomerWithOrderModel? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestPostForApi(context: context, url: url,dictParameter: dictParameter,token: token ??'');
         print(response.toString());
        if (response?.data != null && response!.statusCode == 200) {
          result = UpdateCustomerWithOrderModel.fromJson(response.data);
          print("THIS IS API RESULT FOR CREATE PATIENT POST TYPE :::::>>>>>>>>>>>>>>>>>> ${result.toString()}");
          return result;
        } else {
          return result;
         }
      } catch (e) {

        PrintLog.printLog("Exception_main1s: $e");

        return result;

      }
    } else {
      ToastCustom.showToast( msg: networkToastString);
    }
    return null;
   }


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


  ///Notification Count Api
    Future<NotificationCountApiResponse?> getNotificationCountApi({context, required String url, dictParameter, String? token}) async {
    NotificationCountApiResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestGetForApi(context: context, url: url,dictParameter: dictParameter,token: token);
        if (response?.data != null && response?.statusCode == 200) {
          result = NotificationCountApiResponse.fromJson(response?.data);
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

  //Driver Dashboard Api
  Future<DriverDashboardApiresponse?> getDriverDashboardApi({context, required String url, dictParameter, String? token}) async {
    DriverDashboardApiresponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestGetForApi(context: context, url: url,dictParameter: dictParameter,token: token);
        if (response?.data != null && response?.statusCode == 200) {
          result = DriverDashboardApiresponse.fromJson(response?.data);
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

  //Driver Routes Api
  Future< DriverRoutesApiResposne?> getDriverRoutesApi({context, required String url, dictParameter, String? token}) async {
    DriverRoutesApiResposne? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestGetForApi(context: context, url: url,dictParameter: dictParameter,token: token);
        if (response?.data != null && response?.statusCode == 200) {
          result = DriverRoutesApiResposne.fromJson(response?.data);
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
///Pharmacy RoutesList Api
  Future< GetDriverRouteListModelResponse?> getRouteListApiPharmacy({context, required String url, dictParameter, String? token}) async {
    GetDriverRouteListModelResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestGetForApi(context: context, url: url,dictParameter: dictParameter,token: token);
        if (response?.data != null && response?.statusCode == 200) {
          result = GetDriverRouteListModelResponse.fromJson(response?.data);
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
///Pharmacy Driver List Get Api
  Future<dynamic> getDriverListPharmacy({context, required String url, dictParameter, String? token}) async {
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestGetForApi(context: context, url: url,dictParameter: dictParameter,token: token);
        // if (response?.data != null && response?.statusCode == 200) {
          return null;
        // } else {
        //   return null;
        // }
      } catch (e) {
        PrintLog.printLog("Exception_main1: $e");
        return null;
      }
    } else {
      ToastCustom.showToast( msg: networkToastString);
    }
    return null;
  }

  ///Driver Profile Api
  Future<DriverProfileApiResponse?> getDriverProfileApi({context, required String url, dictParameter, String? token}) async {
    DriverProfileApiResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestGetForApi(context: context, url: url,dictParameter: dictParameter,token: token);
        if (response?.data != null && response?.statusCode == 200) {
          result = DriverProfileApiResponse.fromJson(response?.data);
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


  ///Get Vehicle List Api
    Future<VehicleListApiResponse?> getVehicleListApi({context, required String url, dictParameter, String? token}) async {
    VehicleListApiResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestGetForApi(context: context, url: url,dictParameter: dictParameter,token: token);
        if (response?.data != null && response?.statusCode == 200) {
          result = VehicleListApiResponse.fromJson(response?.data);
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


  ///Get Order Details Api
    Future<OrderDetailApiResponse?> getOrderDetailApi({context, required String url, dictParameter, String? token}) async {
    OrderDetailApiResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestGetForApi(context: context, url: url,dictParameter: dictParameter,token: token);
        if (response?.data != null && response?.statusCode == 200) {
          result = OrderDetailApiResponse.fromJson(response?.data);
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


  //Get Patient Api
  Future<GetPatientApiResposne?> getPatientApi({context, required String url, dictParameter, String? token}) async {
  GetPatientApiResposne? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestGetForApi(context: context, url: url,dictParameter: dictParameter,token: token);
        if (response?.data != null && response?.statusCode == 200) {
          result = GetPatientApiResposne.fromJson(response?.data);
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


 ///Get All Delivery Api
  Future<AllDeliveryApiResponse?> getAllDeliveryApi({context, required String url, dictParameter, String? token}) async {
    AllDeliveryApiResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestGetForApi(context: context, url: url,dictParameter: dictParameter,token: token);
        if (response?.data != null && response?.statusCode == 200) {
          result = AllDeliveryApiResponse.fromJson(response?.data);
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


  ///Get Pharmacy Profile Api
  Future<PharmacyProfileApiResponse?> getPharmacyProfileApi({context, required String url, dictParameter, String? token}) async {
    PharmacyProfileApiResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestGetForApi(context: context, url: url,dictParameter: dictParameter,token: token);
        if (response?.data != null && response?.statusCode == 200) {
          result = PharmacyProfileApiResponse.fromJson(response?.data);
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

   ///Get Driver List Api
  Future<DriverListApiResponse?> getDriverListApi({context, required String url, dictParameter, String? token}) async {
    DriverListApiResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestGetForApi(context: context, url: url,dictParameter: dictParameter,token: token);
        if (response?.data != null && response?.statusCode == 200) {
          result = DriverListApiResponse.fromJson(response?.data);
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

  ///Create Notification Api     
  Future<CreateNotificationApiResponse?> getCreateNotificationApi({context, required String url, dictParameter, String? token}) async {
    CreateNotificationApiResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestGetForApi(context: context, url: url,dictParameter: dictParameter,token: token);
        if (response?.data != null && response?.statusCode == 200) {
          result = CreateNotificationApiResponse.fromJson(response?.data);
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

  ///Lunch Break Api
  Future<LunchBreakApiResponse?> getLunchBreakApi({context, required String url, dictParameter, String? token}) async {
    LunchBreakApiResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestPostForApi(context: context, url: url,dictParameter: dictParameter,token: token ??'');
        if (response?.data != null && response?.statusCode == 200) {
          result = LunchBreakApiResponse.fromJson(response?.data);
          print("THIS IS API RESULT FOR LOGIN API $result");
          return result;
        } else {
          print("THIS IS API RESULT FOR LOGIN API $result");
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

   ///Update Profile Api
  Future<UpdateProfileApiResponse?> getUpdateProfileApi({context, required String url, dictParameter, String? token}) async {
    UpdateProfileApiResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestPostForApi(context: context, url: url,dictParameter: dictParameter,token: token ??'');
        if (response?.data != null && response?.statusCode == 200) {
          result = UpdateProfileApiResponse.fromJson(response?.data);
          print("THIS IS API RESULT FOR UPDATE PROFILE $result");
          return result;
        } else {
          print("THIS IS API RESULT FOR UPDATE PROFILE $result");
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


  ///Save Notification Api
  Future<SaveNotificationApiResponse?> getSaveNotificationApi({context, required String url, dictParameter, String? token}) async {
  SaveNotificationApiResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestPostForApi(context: context, url: url,dictParameter: dictParameter,token: token ??'');
        if (response?.data != null && response?.statusCode == 200) {
          result = SaveNotificationApiResponse.fromJson(response?.data);
          PrintLog.printLog(result.message);
          return result;
        } else {
          PrintLog.printLog(result!.message);
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
      {required context,String? url,Map<String, dynamic>? dictParameter, String? token}) async {
    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        // "Authkey": WebApiConstant.AUTH_KEY,
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
          receiveTimeout: Duration(minutes: 1),
          connectTimeout: Duration(minutes: 1),
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
      {required context, required String url,required Map<String, dynamic> dictParameter,required String token}) async {
    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        // "Authkey": WebApiConstant.AUTH_KEY,
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
          receiveTimeout: Duration(minutes: 1),
          connectTimeout: Duration(minutes: 1),
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
        // "Authkey": WebApiConstant.AUTH_KEY,
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
          receiveTimeout: Duration(minutes: 1),
          connectTimeout: Duration(minutes: 1),
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

  /// Background data api
  Future<Response?> postFormBackgroundDataAPI(
      {required context, String? url, formData}) async {
    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": "Bearer $authToken",
        "Connection": "Keep-Alive",
        "Keep-Alive": "timeout=5, max=1000"
      };

      PrintLog.printLog("Headers: $headers");
      PrintLog.printLog("Url:  $url");
      PrintLog.printLog("Token:  $authToken");
      PrintLog.printLog("formData: $formData");

      BaseOptions options = BaseOptions(
          baseUrl: WebApiConstant.BASE_URL,
          receiveTimeout: const Duration(minutes: 1),
          connectTimeout: const Duration(minutes: 1),
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
      }else if(response.statusCode == 200){
        return response;
      }
      return response;
    } catch (error) {
      PrintLog.printLog("Exception_Main: $error");
      return null;
    }
  }


  Future<dynamic?> requestGetForDriverListApi(
      {required context,String? url,Map<String, dynamic>? dictParameter, String? token}) async {
    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        // "Authkey": WebApiConstant.AUTH_KEY,
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
          receiveTimeout: Duration(minutes: 1),
          connectTimeout: Duration(minutes: 1),
          headers: headers,
          validateStatus: (_) => true
      );

      _dio.options = options;
      Response response = await _dio.get(url!, queryParameters: dictParameter);
      return response;

    } catch (error) {
      PrintLog.printLog("Exception_Main: $error");
      return null;
    }
  }


  Future<Response?> logOutApi({required context,String? url}) async {
    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": "Bearer $authToken",
        "Connection": "Keep-Alive",
        "Keep-Alive": "timeout=5, max=1000",
      };

      PrintLog.printLog("Headers: $headers");
      PrintLog.printLog("Url:  $url");
      CustomLoading().show(context, true);

      BaseOptions options = BaseOptions(
          baseUrl: WebApiConstant.BASE_URL,
          receiveTimeout: const Duration(minutes: 1),
          connectTimeout: const Duration(minutes: 1),
          headers: headers,
          validateStatus: (_) => true
      );

      _dio.options = options;
      Response response = await _dio.get(url!, queryParameters: {"":""});
      PrintLog.printLog("Response_headers: ${response.headers}");
      PrintLog.printLog("Response_data: ${response.data}");

      if(response.data.toString().toLowerCase() == "success"){
        AppSharedPreferences.clearSharedPref().then((value) {
          G.Get.offAllNamed(loginScreenRoute);
        });
      }else{
        CustomLoading().show(context, false);
      }
      return response;

    } catch (error) {
      CustomLoading().show(context, false);
      PrintLog.printLog("Exception_Main: $error");
      return null;
    }
  }


}
