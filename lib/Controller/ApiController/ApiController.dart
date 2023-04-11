import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as G;
import 'package:pharmdel/Model/DriverDashboard/driver_dashboard_response.dart';
import 'package:pharmdel/Model/NotificationCount/notificationCountResponse.dart';

import '../../Model/AllDelivery/allDeliveryApiResponse.dart';
import '../../Model/CreateNotification/createNotificationResponse.dart';
import '../../Model/CreateOrder/driver_create_order_response.dart';
import '../../Model/CreatePatientModel/create_patient_model.dart';
import '../../Model/CreatePatientModel/driver_create_patient_response.dart';
import '../../Model/DriverDashboard/get_pharmacy_info_response.dart';
import '../../Model/DriverDashboard/make_next_order_response.dart';
import '../../Model/DriverDashboard/reschedule_delivery_response.dart';
import '../../Model/DriverDashboard/update_storage_or_cd_response.dart';
import '../../Model/DriverList/driver_list_response.dart';
import '../../Model/DriverProfile/profile_driver_response.dart';
import '../../Model/DriverRoutes/get_route_list_response.dart';
import '../../Model/ForgotPassword/forgotPasswordResponse.dart';
import '../../Model/GetDeliveryMasterData/get_delivery_master_data.dart';
import '../../Model/GetPatient/getPatientApiResponse.dart';
import '../../Model/Login/login_model.dart';
import '../../Model/LunchBreak/lunchBreakResponse.dart';
import '../../Model/Notification/NotifficationResponse.dart';
import '../../Model/OrderDetails/detail_response.dart';
import '../../Model/ParcelBox/parcel_box_response.dart';
import '../../Model/PharmacyModels/P_CreateOrderApiResponse/p_createOrderResponse.dart';
import '../../Model/PharmacyModels/P_DeliveryScheduleResponse/p_DeliveryScheduleResposne.dart';
import '../../Model/PharmacyModels/P_DriverRoutePointsResponse/p_driverRoutePointsResponse.dart';
import '../../Model/PharmacyModels/P_FetchDeliveryListModel/P_fetch_delivery_list_model.dart';
import '../../Model/PharmacyModels/P_GetBoxesResponse/p_getBoxesApiResponse.dart';
import '../../Model/PharmacyModels/P_GetDriverRoutesListPharmacy/P_get_driver_route_list_model_pharmacy.dart';
import '../../Model/PharmacyModels/P_GetMapRoutesResponse/p_get_map_routes_response.dart';
import '../../Model/PharmacyModels/P_MedicineListResponse/p_medicineListResponse.dart';
import '../../Model/PharmacyModels/P_NursingHomeOrderResponse/p_nursingHomeOrderResponse.dart';
import '../../Model/PharmacyModels/P_NursingHomeResponse/p_nursingHomeResponse.dart';
import '../../Model/PharmacyModels/P_SentNotificationResponse/p_sentNotificationRsponse.dart';
import '../../Model/PharmacyModels/P_UpdateNursingOrderResponse/p_updateNursingOrderResponse.dart';
import '../../Model/PharmacyModels/PharmacyProfile/p_profileApiResponse.dart';
import '../../Model/ProcessScan/driver_process_scan_response.dart';
import '../../Model/ProcessScan/process_scan_response.dart';
import '../../Model/SaveNotification/saveNotificationResponse.dart';
import '../../Model/SearchMedicine/search_medicine_response.dart';
import '../../Model/SetupPin/setupPin_model.dart';
import '../../Model/UpdateCustomerWithOrder/UpdateCustomerWithOrder.dart';
import '../../Model/UpdateMiles/update_miles_response.dart';
import '../../Model/UpdateProfile/updateProfileResponse.dart';
import '../../Model/VIRUploadModel/GetInspectionModel.dart';
import '../../Model/VIRUploadModel/vir_api_model.dart';
import '../../Model/VehicleList/vehicleListResponse.dart';
import '../../main.dart';
import '../GeoCoder/GoogleAddresResponse/google_api_response.dart';
import '../Helper/ConnectionValidator/ConnectionValidator.dart';
import '../Helper/PrintLog/PrintLog.dart';
import '../Helper/Shared Preferences/SharedPreferences.dart';
import '../RouteController/RouteNames.dart';
import '../WidgetController/Loader/LoadingScreen.dart';
import '../WidgetController/StringDefine/StringDefine.dart';
import '../WidgetController/Toast/ToastCustom.dart';
import 'WebConstant.dart';
import 'important_keys.dart';

class ApiController {
  final Dio _dio = Dio();

  /// Google Address Api
  Future<GoogleAddressApiResponse?> getGoogleAddressApi({required String primaryText, required String secondaryText}) async {
    GoogleAddressApiResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        var encodedAddressData = Uri.encodeComponent("$primaryText $secondaryText");

        Response response = await _dio.get("https://maps.google.com/maps/api/geocode/json?key=${ImportantKey.kGooglePlacesSdkKey}&address=$encodedAddressData", options: Options(followRedirects: false, validateStatus: (status) => true));
        PrintLog.printLog("Response:: $response");
        if (response.data != null && response.statusCode == 200) {
          result = GoogleAddressApiResponse.fromJson(response.data);
          return result;
        } else {
          ToastCustom.showToast(msg: response.statusMessage.toString() ?? "");
        }
      } catch (error) {
        PrintLog.printLog("Exception_Main: $error");
        return result;
      }
    } else {
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }

  /// Login Api
  Future<LoginModel?> getLoginApi({context, required String url, dictParameter, String? token}) async {
    LoginModel? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestPostForApi(context: context, url: url, dictParameter: dictParameter, token: token ?? '');
        if (response?.data != null && response!.statusCode == 200) {
          result = LoginModel.fromJson(response.data);
          return result;
        } else {
          ToastCustom.showToast(msg: response?.statusMessage.toString() ?? "");
        }
      } catch (e) {
        PrintLog.printLog("Exception_main1s: $e");
        return result;
      }
    } else {
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }

  /// Logout Api
  Future getLogoutApi({context, required String url, dictParameter, String? token}) async {
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestGetForApi(context: context, url: url, dictParameter: dictParameter, token: authToken);
        if (response?.data != null && response!.statusCode == 200) {
          return response;
        }
      } catch (e) {
        PrintLog.printLog("Exception_main1s: $e");
      }
    } else {
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }

  ///Forgot Password
  Future<ForgotPasswordApiResponse?> getForgotPasswordApi({context, required String url, dictParameter, String? token}) async {
    ForgotPasswordApiResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestPostForApi(context: context, url: url, dictParameter: dictParameter, token: token ?? '');
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
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }

  ///Setup Pin Api
  Future<SetUpPinModel?> setMPinAPi({context, required String url, dictParameter, String? token}) async {
    SetUpPinModel? _result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestPostForApi(context: context, url: url, dictParameter: dictParameter, token: token ?? '');
        if (response?.data != null && response!.statusCode == 200) {
          _result = SetUpPinModel.fromJson(response.data);
          return _result;
        } else {
          ToastCustom.showToast(msg: response?.statusMessage.toString() ?? "");
        }
      } catch (e) {
        PrintLog.printLog("Exception_main1s: $e");
        return _result;
      }
    } else {
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }

  ///Create Patient Api
  Future<CreatePatientModelResponse?> createPatientApi({context, required String url, dictParameter, String? token}) async {
    CreatePatientModelResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestPostForApi(context: context, url: url, dictParameter: dictParameter, token: token ?? '');
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
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }

  /// Driver Create Patient Api
  Future<DriverCreatePatientApiResponse?> driverCreatePatientApi({context, required String url, dictParameter}) async {
    DriverCreatePatientApiResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestPostForApi(context: context, url: url, dictParameter: dictParameter, token: authToken);
        if (response?.data != null && response!.statusCode == 200) {
          result = DriverCreatePatientApiResponse.fromJson(response.data);
          return result;
        } else {
          return result;
        }
      } catch (e) {
        PrintLog.printLog("Exception_main1s: $e");
        return result;
      }
    } else {
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }

  /// Driver Process Scan  Api
  Future<ProcessScanApiResponse?> driverProcessScanApi({context, required String url, dictParameter}) async {
    ProcessScanApiResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestPostForApi(context: context, url: url, dictParameter: dictParameter, token: authToken);
        if (response?.data != null && response!.statusCode == 200) {
          result = ProcessScanApiResponse.fromJson(response.data);
          return result;
        } else {
          return result;
        }
      } catch (e) {
        PrintLog.printLog("Exception_main1s: $e");
        return result;
      }
    } else {
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }

  ///UPDATE CUSTOMER WITH ORDER
  Future<UpdateCustomerWithOrderModel?> updateCustomerWithOrder({context, required String url, dictParameter, String? token}) async {
    UpdateCustomerWithOrderModel? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestPostForApi(context: context, url: url, dictParameter: dictParameter, token: token ?? '');
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
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }

  ///Notification Api
  Future<NotificationApiResponse?> getNotificaitonApi({context, required String url, dictParameter, String? token}) async {
    NotificationApiResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestGetForApi(context: context, url: url, dictParameter: dictParameter, token: token);
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
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }

  ///Notification Count Api
  Future<NotificationCountApiResponse?> getNotificationCountApi({context, required String url, dictParameter, String? token}) async {
    NotificationCountApiResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestGetForApi(context: context, url: url, dictParameter: dictParameter, token: token);
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
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }

  ///Driver Dashboard Api
  Future<GetDeliveryApiResponse?> getDriverDashboardApi({context, required String url, dictParameter, String? token}) async {
    GetDeliveryApiResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestGetForApi(context: context, url: url, dictParameter: dictParameter, token: token);
        if (response?.data != null && response?.statusCode == 200) {
          result = GetDeliveryApiResponse.fromJson(response?.data);
          return result;
        } else {
          return result;
        }
      } catch (e) {
        PrintLog.printLog("Exception_main1: $e");
        return result;
      }
    } else {
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }

  ///Driver Dashboard Api
  Future<GetPharmacyInfoResponse?> getPharmacyInfoApi({context, required String url, dictParameter, String? token}) async {
    GetPharmacyInfoResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestGetForApi(context: context, url: url, dictParameter: dictParameter, token: token);
        if (response?.data != null && response?.statusCode == 200) {
          result = GetPharmacyInfoResponse.fromJson(response?.data);
          return result;
        } else {
          return result;
        }
      } catch (e) {
        PrintLog.printLog("Exception_main1: $e");
        return result;
      }
    } else {
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }

  ///Update Vehicle Miles Api
  Future<UpdateVehicleMilesResponse?> updateMilesApi({context, required String url, dictParameter, String? token}) async {
    UpdateVehicleMilesResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestPostForApi(context: context, url: url, dictParameter: dictParameter, token: token ?? "");
        if (response?.data != null && response?.statusCode == 200) {
          result = UpdateVehicleMilesResponse.fromJson(response?.data);
          return result;
        }
      } catch (e) {
        PrintLog.printLog("Exception_main1: $e");
        return result;
      }
    } else {
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }

  /// Driver Routes Api
  Future<GetRouteListResponse?> getDriverRoutesApi({context, required String url, dictParameter, String? token}) async {
    GetRouteListResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestGetForApi(context: context, url: url, dictParameter: dictParameter, token: token);
        if (response?.data != null && response?.statusCode == 200) {
          result = GetRouteListResponse.fromJson(response?.data);
          return result;
        } else {
          return result;
        }
      } catch (e) {
        PrintLog.printLog("Exception_main1: $e");
        return result;
      }
    } else {
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }

  /// Get parcel box list Api
  Future<GetParcelBoxApiResponse?> getParcelBoxApi({context, required String url, dictParameter, String? token}) async {
    GetParcelBoxApiResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestGetForApi(context: context, url: url, dictParameter: dictParameter, token: token);
        if (response?.data != null && response?.statusCode == 200) {
          result = GetParcelBoxApiResponse.fromJson(response?.data);
          return result;
        } else {
          return result;
        }
      } catch (e) {
        PrintLog.printLog("Exception_main1: $e");
        return result;
      }
    } else {
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }

  ///Pharmacy RoutesList Api
  Future<GetDriverRouteListModelResponse?> getRouteListApiPharmacy({context, required String url, dictParameter, String? token}) async {
    GetDriverRouteListModelResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestGetForApi(context: context, url: url, dictParameter: dictParameter, token: token);
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
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }

  ///Pharmacy Driver List Get Api
  Future<dynamic> getDriverListPharmacy({context, required String url, dictParameter, String? token}) async {
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestGetForApi(context: context, url: url, dictParameter: dictParameter, token: token);
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
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }

  ///Driver Profile Api
  Future<DriverProfileApiResponse?> getDriverProfileApi({required String url, dictParameter, String? token}) async {
    DriverProfileApiResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestGetForApi(context: G.Get.overlayContext!, url: url, dictParameter: dictParameter, token: token);
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
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }

  ///Get Vehicle List Api
  Future<VehicleListApiResponse?> getVehicleListApi({context, required String url, dictParameter, String? token}) async {
    VehicleListApiResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestGetForApi(context: context, url: url, dictParameter: dictParameter, token: token);
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
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }

  /// Get Order Details Api
  Future<OrderDetailResponse?> getOrderDetailApi({context, required String url, dictParameter, String? token}) async {
    OrderDetailResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestGetForApi(context: context, url: url, dictParameter: dictParameter, token: token);
        if (response?.data != null && response?.statusCode == 200) {
          result = OrderDetailResponse.fromJson(response?.data);
          return result;
        } else {
          return result;
        }
      } catch (e) {
        PrintLog.printLog("Exception_main1: $e");
        return result;
      }
    } else {
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }

  /// Update Storage or CD Api
  Future<UpdateOrderStorageOrCDResponse?> updateStorageOrCDApi({context, required String url, dictParameter, String? token}) async {
    UpdateOrderStorageOrCDResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestPostForApi(context: context, url: url, dictParameter: dictParameter, token: token ?? "");
        if (response?.data != null && response?.statusCode == 200) {
          result = UpdateOrderStorageOrCDResponse.fromJson(response?.data);
          return result;
        } else {
          return result;
        }
      } catch (e) {
        PrintLog.printLog("Exception_main1: $e");
        return result;
      }
    } else {
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }

  /// Delete Order by Order ID Api
  Future<Response?> deleteOrderByOrderIDApi({required context, String? url, formData}) async {
    try {
      Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $authToken", "Connection": "Keep-Alive", "Keep-Alive": "timeout=5, max=1000"};

      PrintLog.printLog("Headers: $headers");
      PrintLog.printLog("Url:  $url");
      PrintLog.printLog("Token:  $authToken");
      PrintLog.printLog("formData: $formData");

      BaseOptions options = BaseOptions(baseUrl: WebApiConstant.BASE_URL_PHARMACY, receiveTimeout: const Duration(minutes: 1), connectTimeout: const Duration(minutes: 1), headers: headers);

      _dio.options = options;
      Response response = await _dio.get(url!,
          data: formData,
          options: Options(
            followRedirects: false,
            validateStatus: (status) => true,
            headers: headers,
          ));

      PrintLog.printLog("Response: $response");

      // if(response.data["authenticated"] == false){
      //   // PopupCustom.logoutPopUP(context: context);
      // }else if(response.statusCode == 200){
      //   return response;
      // }
      return response;
    } catch (error) {
      PrintLog.printLog("Exception_Main: $error");
      return null;
    }
  }

  /// Update Delivery Status Api
  Future<Response?> updateDeliveryStatusApi({required context, String? url, formData}) async {
    try {
      Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $authToken", "Connection": "Keep-Alive", "Keep-Alive": "timeout=5, max=1000"};

      PrintLog.printLog("Headers: $headers");
      PrintLog.printLog("Url:  $url");
      PrintLog.printLog("Token:  $authToken");
      PrintLog.printLog("formData: $formData");

      BaseOptions options = BaseOptions(baseUrl: WebApiConstant.BASE_URL, receiveTimeout: const Duration(minutes: 1), connectTimeout: const Duration(minutes: 1), headers: headers);

      _dio.options = options;
      Response response = await _dio.post(url!,
          data: formData,
          options: Options(
            followRedirects: false,
            validateStatus: (status) => true,
            headers: headers,
          ));

      PrintLog.printLog("Response: $response");

      // if(response.data["authenticated"] == false){
      //   // PopupCustom.logoutPopUP(context: context);
      // }else if(response.statusCode == 200){
      //   return response;
      // }
      return response;
    } catch (error) {
      PrintLog.printLog("Exception_Main: $error");
      return null;
    }
  }

  ///Get Patient Api
  Future<GetPatientApiResposne?> getPatientApi({context, required String url, dictParameter, String? token}) async {
    GetPatientApiResposne? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestGetForApi(context: context, url: url, dictParameter: dictParameter, token: token);
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
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }

  ///Process Scan Api
  Future<DriverProcessScan?> processScanApi({context, required String url, dictParameter, String? token}) async {
    DriverProcessScan? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestPostForApi(context: context, url: url, dictParameter: dictParameter, token: authToken);
        if (response?.data != null && response?.statusCode == 200) {
          result = DriverProcessScan.fromJson(response?.data);
          return result;
        } else {
          return result;
        }
      } catch (e) {
        PrintLog.printLog("Exception_main1: $e");
        return result;
      }
    } else {
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }

  /// Upload vir  Data

  Future<VirUploadApiModel?> virUploadApi({
    context,
    required String url,
    required dictData,
    token,
  }) async {
    VirUploadApiModel? result;

    if (await ConnectionValidator().check()) {
      try {
        final response = await requestPostForApi(context: context, url: url, dictParameter: dictData, token: authToken);
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

  /// Create order Api
  Future<DriverCreateOrderApiResponse?> driverCreateOrderApi({context, required String url, dictParameter, String? token}) async {
    DriverCreateOrderApiResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestPostForApi(context: context, url: url, dictParameter: dictParameter, token: authToken);
        if (response?.data != null && response?.statusCode == 200) {
          result = DriverCreateOrderApiResponse.fromJson(response?.data);
          return result;
        } else {
          return result;
        }
      } catch (e) {
        PrintLog.printLog("Exception_main1: $e");
        return result;
      }
    } else {
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }

  /// Get Medicine List Api
  Future<SearchMedicineListApiResponse?> getMedicineListApi({context, required String url, dictParameter, String? token}) async {
    SearchMedicineListApiResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestGetForApi(context: context, url: url, dictParameter: dictParameter, token: token);
        if (response?.data != null && response?.statusCode == 200) {
          result = SearchMedicineListApiResponse.fromJson(response?.data);
          return result;
        } else {
          return result;
        }
      } catch (e) {
        PrintLog.printLog("Exception_main1: $e");
        return result;
      }
    } else {
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }

  /// Get Delivery Master Data Api
  Future<GetDeliveryMasterDataResponse?> getDeliveryMasterDataApi({context, required String url, dictParameter, String? token}) async {
    GetDeliveryMasterDataResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestGetForApi(context: context, url: url, dictParameter: dictParameter, token: token);
        if (response?.data != null && response?.statusCode == 200) {
          result = GetDeliveryMasterDataResponse.fromJson(response?.data);
          return result;
        } else {
          return result;
        }
      } catch (e) {
        PrintLog.printLog("Exception_main1: $e");
        return result;
      }
    } else {
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }

  ///Get All Delivery Api
  Future<AllDeliveryApiResponse?> getAllDeliveryApi({context, required String url, dictParameter, String? token}) async {
    AllDeliveryApiResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestGetForApi(context: context, url: url, dictParameter: dictParameter, token: token);
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
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }

  ///Get Pharmacy Profile Api
  Future<PharmacyProfileApiResponse?> getPharmacyProfileApi({context, required String url, dictParameter, String? token}) async {
    PharmacyProfileApiResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestGetForApi(context: context, url: url, dictParameter: dictParameter, token: token);
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
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }

  ///Get Driver List Api
  Future<DriverListApiResponse?> getDriverListApi({context, required String url, dictParameter, String? token}) async {
    DriverListApiResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestGetForApi(context: context, url: url, dictParameter: dictParameter, token: token);
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
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }

  ///Pharmacy Get Nursing Home
  Future<NursingHomeApiResponse?> getNursingHomeApi({context, required String url, dictParameter, String? token}) async {
    NursingHomeApiResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestGetForApi(context: context, url: url, dictParameter: dictParameter, token: token);
        if (response?.data != null && response?.statusCode == 200) {
          result = NursingHomeApiResponse.fromJson(response?.data);
          return result;
        } else {
          return result;
        }
      } catch (e) {
        PrintLog.printLog("Exception_main1: $e");
        return result;
      }
    } else {
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }

  ///Get Boxes Api
  Future<GetBoxesApiResponse?> getBoxesApi({context, required String url, dictParameter, String? token}) async {
    GetBoxesApiResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestGetForApi(context: context, url: url, dictParameter: dictParameter, token: token);
        if (response?.data != null && response?.statusCode == 200) {
          result = GetBoxesApiResponse.fromJson(response?.data);
          return result;
        } else {
          return result;
        }
      } catch (e) {
        PrintLog.printLog("Exception_main1: $e");
        return result;
      }
    } else {
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }

  ///Update Nursing Order Api
  Future<UpdateNursingOrderApiResposne?> updateNursingOrderApi({context, required String url, dictParameter, String? token}) async {
    UpdateNursingOrderApiResposne? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestPostForApi(context: context, url: url, dictParameter: dictParameter, token: token ?? '');
        if (response?.data != null && response?.statusCode == 200) {
          result = UpdateNursingOrderApiResposne.fromJson(response?.data);
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
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }

  ///Create Notification Api
  Future<CreateNotificationApiResponse?> getCreateNotificationApi({context, required String url, dictParameter, String? token}) async {
    CreateNotificationApiResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestGetForApi(context: context, url: url, dictParameter: dictParameter, token: token);
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
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }
///Create Driver new notification
  Future driverCreateNotification({context, required String url, dictParameter, String? token}) async {
    var result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestPostForApi(context: context, url: url, dictParameter: dictParameter, token: authToken);
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
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }

  ///Get Nursing Home Orders
  Future<NursingOrderApiResponse?> getNursingHomeOrderApi({context, required String url, dictParameter, String? token}) async {
    NursingOrderApiResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestGetForApi(context: context, url: url, dictParameter: dictParameter, token: token);
        if (response?.data != null && response?.statusCode == 200) {
          result = NursingOrderApiResponse.fromJson(response?.data);
          return result;
        } else {
          return result;
        }
      } catch (e) {
        PrintLog.printLog("Exception_main1: $e");
        return result;
      }
    } else {
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }

  ///Lunch Break Api
  Future<LunchBreakApiResponse?> getLunchBreakApi({context, required String url, dictParameter, String? token}) async {
    LunchBreakApiResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestPostForApi(context: context, url: url, dictParameter: dictParameter, token: token ?? '');
        if (response?.data != null && response?.statusCode == 200) {
          result = LunchBreakApiResponse.fromJson(response?.data);
          return result;
        }
      } catch (e) {
        PrintLog.printLog("Exception_main1: $e");
        return result;
      }
    } else {
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }

  ///Update Profile Api
  Future<UpdateProfileApiResponse?> getUpdateProfileApi({context, required String url, dictParameter, String? token}) async {
    UpdateProfileApiResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestPostForApi(context: context, url: url, dictParameter: dictParameter, token: token ?? '');
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
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }

  /// Get Deliveries with route start api
  Future<GetDeliveryApiResponse?> getDeliveriesWithRouteStartApi({context, required String url, dictParameter, String? token}) async {
    GetDeliveryApiResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestGetForApi(context: context, url: url, dictParameter: dictParameter, token: token ?? '');
        if (response?.data != null && response?.statusCode == 200) {
          result = GetDeliveryApiResponse.fromJson(response?.data);
          return result;
        } else {}
      } catch (e) {
        PrintLog.printLog("Exception_main1: $e");
        return result;
      }
    } else {
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }

  /// Get Reschedule order api
  Future<RescheduleDeliveryResponse?> rescheduleOrderApi({context, required String url, dictParameter}) async {
    RescheduleDeliveryResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestGetForApi(context: context, url: url, dictParameter: dictParameter, token: authToken);
        if (response?.data != null && response?.statusCode == 200) {
          result = RescheduleDeliveryResponse.fromJson(response?.data);
          return result;
        } else {}
      } catch (e) {
        PrintLog.printLog("Exception_main1: $e");
        return result;
      }
    } else {
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }

  /// Make next order api
  Future<MakeNextApiResponse?> makeNextApi({context, required String url, dictParameter}) async {
    MakeNextApiResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestGetForApi(context: context, url: url, dictParameter: dictParameter, token: authToken);
        if (response?.data != null && response?.statusCode == 200) {
          result = MakeNextApiResponse.fromJson(response?.data);
          return result;
        } else {}
      } catch (e) {
        PrintLog.printLog("Exception_main1: $e");
        return result;
      }
    } else {
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }

  ///Save Notification Api
  Future<SaveNotificationApiResponse?> getSaveNotificationApi({context, required String url, dictParameter, String? token}) async {
    SaveNotificationApiResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestPostForApi(context: context, url: url, dictParameter: dictParameter, token: token ?? '');
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
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }

  ///Get vehicle inspection report status Api
  Future<GetInspectionDataModel?> getVehicleInspectionReportStatus({context, required String url, dictParameter, String? token}) async {
    GetInspectionDataModel? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestGetForApi(context: context, url: url, dictParameter: dictParameter, token: token ?? '');
        if (response?.data != null && response?.statusCode == 200) {
          result = GetInspectionDataModel.fromJson(response?.data);
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
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }

  Future<Response?> requestGetForApi({required context, String? url, Map<String, dynamic>? dictParameter, String? token}) async {
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

      BaseOptions options = BaseOptions(baseUrl: WebApiConstant.BASE_URL, receiveTimeout: Duration(minutes: 1), connectTimeout: Duration(minutes: 1), headers: headers, validateStatus: (_) => true);

      _dio.options = options;
      Response response = await _dio.get(url!, queryParameters: dictParameter);
      PrintLog.printLog("Response_headers: ${response.headers}");
      PrintLog.printLog("Response_data: ${response.data}");

      if (response.data["authenticated"] == false) {
        // PopupCustom.logoutPopUP(context: context);
      }
      return response;
    } catch (error) {
      PrintLog.printLog("Exception_Main: $error");
      return null;
    }
  }

  Future<Response?> requestPostForApi({required context, required String url, required Map<String, dynamic> dictParameter, required String token}) async {
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

      BaseOptions options = BaseOptions(baseUrl: WebApiConstant.BASE_URL, receiveTimeout: const Duration(minutes: 1), connectTimeout: const Duration(minutes: 1), headers: headers);
      _dio.options = options;
      Response response = await _dio.post(url, data: dictParameter, options: Options(followRedirects: false, validateStatus: (status) => true, headers: headers));
      // if(response.data["authenticated"] == false){
      //   // PopupCustom.logoutPopUP(context: context);
      // }
      PrintLog.printLog("Response: $response");
      PrintLog.printLog("Response_headers: ${response.headers}");
      PrintLog.printLog("Response_real_url: ${response.realUri}");
      return response;
    } catch (error) {
      PrintLog.printLog("Exception_Main: $error");
      return null;
    }
  }

  Future<Response?> requestMultipartApi({required context, String? url, formData, String? token}) async {
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

      BaseOptions options = BaseOptions(baseUrl: WebApiConstant.BASE_URL, receiveTimeout: Duration(minutes: 1), connectTimeout: Duration(minutes: 1), headers: headers);

      _dio.options = options;
      Response response = await _dio.post(url!,
          data: formData,
          options: Options(
            followRedirects: false,
            validateStatus: (status) => true,
            headers: headers,
          ));

      PrintLog.printLog("Response: $response");

      if (response.data["authenticated"] == false) {
        // PopupCustom.logoutPopUP(context: context);
      }
      return response;
    } catch (error) {
      PrintLog.printLog("Exception_Main: $error");
      return null;
    }
  }

  /// Background data api
  Future<Response?> postFormBackgroundDataAPI({required context, String? url, formData}) async {
    try {
      Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $authToken", "Connection": "Keep-Alive", "Keep-Alive": "timeout=5, max=1000"};

      PrintLog.printLog("Headers: $headers");
      PrintLog.printLog("Url:  $url");
      PrintLog.printLog("Token:  $authToken");
      PrintLog.printLog("formData: $formData");

      BaseOptions options = BaseOptions(baseUrl: WebApiConstant.BASE_URL, receiveTimeout: const Duration(minutes: 1), connectTimeout: const Duration(minutes: 1), headers: headers);

      _dio.options = options;
      Response response = await _dio.post(url!,
          data: formData,
          options: Options(
            followRedirects: false,
            validateStatus: (status) => true,
            headers: headers,
          ));

      PrintLog.printLog("Response: $response");

      if (response.data["authenticated"] == false) {
        // PopupCustom.logoutPopUP(context: context);
      } else if (response.statusCode == 200) {
        return response;
      }
      return response;
    } catch (error) {
      PrintLog.printLog("Exception_Main: $error");
      return null;
    }
  }

  /// Background data api
  Future<Response?> startRoutesAPI({required context, String? url, dictParameter}) async {
    try {
      Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $authToken", "Connection": "Keep-Alive", "Keep-Alive": "timeout=5, max=1000"};

      PrintLog.printLog("Headers: $headers");
      PrintLog.printLog("Url:  $url");
      PrintLog.printLog("Token:  $authToken");
      PrintLog.printLog("formData: $dictParameter");

      BaseOptions options = BaseOptions(baseUrl: WebApiConstant.BASE_URL, receiveTimeout: const Duration(minutes: 1), connectTimeout: const Duration(minutes: 1), headers: headers);

      _dio.options = options;
      Response response = await _dio.get(url!,
          data: dictParameter,
          options: Options(
            followRedirects: false,
            validateStatus: (status) => true,
            headers: headers,
          ));

      PrintLog.printLog("Response: $response");

      // if(response.data["authenticated"] == false){
      //   // PopupCustom.logoutPopUP(context: context);
      // }else if(response.statusCode == 200){
      //   return response;
      // }
      return response;
    } catch (error) {
      PrintLog.printLog("Exception_Main: $error");
      return null;
    }
  }

  /// End Route Api
  Future<Response?> endRoutesAPI({required context, String? url, dictParameter}) async {
    try {
      Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $authToken", "Connection": "Keep-Alive", "Keep-Alive": "timeout=5, max=1000"};

      PrintLog.printLog("Headers: $headers");
      PrintLog.printLog("Url:  $url");
      PrintLog.printLog("Token:  $authToken");
      PrintLog.printLog("formData: $dictParameter");

      BaseOptions options = BaseOptions(baseUrl: WebApiConstant.BASE_URL, receiveTimeout: const Duration(minutes: 1), connectTimeout: const Duration(minutes: 1), headers: headers);

      _dio.options = options;
      Response response = await _dio.get(url!,
          data: dictParameter,
          options: Options(
            followRedirects: false,
            validateStatus: (status) => true,
            headers: headers,
          ));

      PrintLog.printLog("Response: $response");

      // if(response.data["authenticated"] == false){
      //   // PopupCustom.logoutPopUP(context: context);
      // }else if(response.statusCode == 200){
      //   return response;
      // }
      return response;
    } catch (error) {
      PrintLog.printLog("Exception_Main: $error");
      return null;
    }
  }

  /// End Route Api
  Future<Response?> completeDataUploadAPI({required context, String? url, dictParameter}) async {
    try {
      Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $authToken", "Connection": "Keep-Alive", "Keep-Alive": "timeout=5, max=1000"};

      PrintLog.printLog("Headers: $headers");
      PrintLog.printLog("Url:  $url");
      PrintLog.printLog("Token:  $authToken");
      PrintLog.printLog("formData: $dictParameter");

      BaseOptions options = BaseOptions(baseUrl: WebApiConstant.BASE_URL, receiveTimeout: const Duration(minutes: 1), connectTimeout: const Duration(minutes: 1), headers: headers);

      _dio.options = options;
      Response response = await _dio.post(url!,
          data: dictParameter,
          options: Options(
            followRedirects: false,
            validateStatus: (status) => true,
            headers: headers,
          ));

      PrintLog.printLog("Response: $response");

      // if(response.data["authenticated"] == false){
      //   // PopupCustom.logoutPopUP(context: context);
      // }else if(response.statusCode == 200){
      //   return response;
      // }
      return response;
    } catch (error) {
      PrintLog.printLog("Exception_Main: $error");
      return null;
    }
  }

  ///driver list api for pharmacy
  Future<dynamic> requestGetForDriverListApi({required context, String? url, Map<String, dynamic>? dictParameter, String? token}) async {
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

      BaseOptions options = BaseOptions(baseUrl: WebApiConstant.BASE_URL, receiveTimeout: const Duration(minutes: 1), connectTimeout: Duration(minutes: 1), headers: headers, validateStatus: (_) => true);

      _dio.options = options;
      Response response = await _dio.get(url!, queryParameters: dictParameter);
      return response;
    } catch (error) {
      PrintLog.printLog("Exception_Main in get driver list: $error");
      return null;
    }
  }

  ///delivery  list api for pharmacy
  Future getPharmacyDeliveryListApi({context, required String url, dictParameter, String? token}) async {
    PharmacyProfileApiResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestGetForApi(context: context, url: url, dictParameter: dictParameter, token: token);
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
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }

  Future<Response?> logOutApi({required context, String? url}) async {
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

      BaseOptions options = BaseOptions(baseUrl: WebApiConstant.BASE_URL, receiveTimeout: const Duration(minutes: 1), connectTimeout: const Duration(minutes: 1), headers: headers, validateStatus: (_) => true);

      _dio.options = options;
      Response response = await _dio.get(url!, queryParameters: {"": ""});
      PrintLog.printLog("Response_headers: ${response.headers}");
      PrintLog.printLog("Response_data: ${response.data}");

      if (response.data.toString().toLowerCase() == "success") {
        AppSharedPreferences.clearSharedPref().then((value) {
          G.Get.offAllNamed(loginScreenRoute);
          G.Get.deleteAll();
        });
      } else {
        CustomLoading().show(context, false);
      }
      return response;
    } catch (error) {
      CustomLoading().show(context, false);
      PrintLog.printLog("Exception_Main: $error");
      return null;
    }
  }

  ///delivery  list api for pharmacy
  Future<P_FetchDeliveryListModel?> fetchPharmacyDeliveryListapi({context, required String url, dictParameter, String? token}) async {
    P_FetchDeliveryListModel? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestGetForApi(context: context, url: url, dictParameter: dictParameter, token: token);
        if (response?.data != null && response?.statusCode == 200) {
          result = P_FetchDeliveryListModel.fromJson(response?.data);
          return result;
        } else {
          return result;
        }
      } catch (e) {
        PrintLog.printLog("Exception_main1: $e");
        return result;
      }
    } else {
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }

  ///Get Driver Routes Api
  Future<DeliveryScheduleApiResponse?> getDeliveryScheduleApi({context, required String url, dictParameter, String? token}) async {
    DeliveryScheduleApiResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestGetForApi(context: context, url: url, dictParameter: dictParameter, token: token);
        if (response?.data != null && response?.statusCode == 200) {
          result = DeliveryScheduleApiResponse.fromJson(response?.data);
          return result;
        } else {
          return result;
        }
      } catch (e) {
        PrintLog.printLog("Exception_main1: $e");
        return result;
      }
    } else {
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }

  ///Create Order Api
  Future<CreateOrderApiResponse?> getCreateOrderApi({context, required String url, dictParameter, String? token}) async {
    CreateOrderApiResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestPostForApi(context: context, url: url, dictParameter: dictParameter, token: token ?? '');
        if (response?.data != null && response?.statusCode == 200) {
          result = CreateOrderApiResponse.fromJson(response?.data);
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
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }

  ///Get Driver Routes Api
  Future<DriverRoutePointsApiResponse?> getDriverRoutePointsApi({context, required String url, dictParameter, String? token}) async {
    DriverRoutePointsApiResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestGetForApi(context: context, url: url, dictParameter: dictParameter, token: token);
        if (response?.data != null && response?.statusCode == 200) {
          result = DriverRoutePointsApiResponse.fromJson(response?.data);
          return result;
        } else {
          return result;
        }
      } catch (e) {
        PrintLog.printLog("Exception_main1: $e");
        return result;
      }
    } else {
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }

  /// Get Medicine List Api
  Future<MedicineListApiResponse?> p_getMedicineListApi({context, required String url, dictParameter, String? token}) async {
    MedicineListApiResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestGetForApi(context: context, url: url, dictParameter: dictParameter, token: token);
        if (response?.data != null && response?.statusCode == 200) {
          result = MedicineListApiResponse.fromJson(response?.data);
          return result;
        } else {
          return result;
        }
      } catch (e) {
        PrintLog.printLog("Exception_main1: $e");
        return result;
      }
    } else {
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }

  ///Sent Notification Api
  Future<SentNotificationApiResponse?> getSentNotificationApi({context, required String url, dictParameter, String? token}) async {
    SentNotificationApiResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestGetForApi(context: context, url: url, dictParameter: dictParameter, token: token);
        if (response?.data != null && response?.statusCode == 200) {
          result = SentNotificationApiResponse.fromJson(response?.data);
          return result;
        } else {
          return result;
        }
      } catch (e) {
        PrintLog.printLog("Exception_main1: $e");
        return result;
      }
    } else {
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }

  /// Delete Nursing Order Api
  Future<Response?> deleteNursingOrderApi({required context, String? url, formData}) async {
    try {
      Map<String, String> headers = {"Content-type": "application/json", "Authorization": "Bearer $authToken", "Connection": "Keep-Alive", "Keep-Alive": "timeout=5, max=1000"};

      PrintLog.printLog("Headers: $headers");
      PrintLog.printLog("Url:  $url");
      PrintLog.printLog("Token:  $authToken");
      PrintLog.printLog("formData: $formData");

      BaseOptions options = BaseOptions(baseUrl: WebApiConstant.BASE_URL, receiveTimeout: const Duration(minutes: 1), connectTimeout: const Duration(minutes: 1), headers: headers);

      _dio.options = options;
      Response response = await _dio.get(url!,
          data: formData,
          options: Options(
            followRedirects: false,
            validateStatus: (status) => true,
            headers: headers,
          ));

      PrintLog.printLog("Response: $response");

      if (response.data["authenticated"] == false) {
        // PopupCustom.logoutPopUP(context: context);
      } else if (response.statusCode == 200) {
        return response;
      }
      return response;
    } catch (error) {
      PrintLog.printLog("Exception_Main: $error");
      return null;
    }
  }

  ///Process Scan Api
  Future<ProcessScanApiResponse?> getProcessScanApi({context, required String url, dictParameter, String? token}) async {
    ProcessScanApiResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestPostForApi(context: context, url: url, dictParameter: dictParameter, token: token ?? '');
        if (response?.data != null && response?.statusCode == 200) {
          result = ProcessScanApiResponse.fromJson(response?.data);
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
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }

  ///Get Map Routes Api
  Future<GetMapRoutesApiResponse?> getMapRoutesApi({context, required String url, dictParameter, String? token}) async {
    GetMapRoutesApiResponse? result;
    if (await ConnectionValidator().check()) {
      try {
        final response = await requestGetForApi(context: context, url: url, dictParameter: dictParameter, token: token);
        if (response?.data != null && response?.statusCode == 200) {
          result = GetMapRoutesApiResponse.fromJson(response?.data);
          return result;
        } else {
          return result;
        }
      } catch (e) {
        PrintLog.printLog("Exception_main1: $e");
        return result;
      }
    } else {
      ToastCustom.showToast(msg: networkToastString);
    }
    return null;
  }
}
