import 'package:intl/intl.dart';

class WebConstant {
  static const String APP_VERSION = "1.14";
  static const String iOS_APP_VERSION = "12";
  static const String USER_TYPE = "userType"; //Branch Admin + OR +
  static const String USER_LASTTIME = "lastTime"; //Branch Admin + OR +
  static const String ACCESS_TOKEN = "token";
  static const String END_ROUTE_AT = "endRouteAt";
  static const String START_ROUTE_FROM = "startRouteFrom";
  static const String USER_ID = "userId";
  static const String DEVICE_ID = "device_id";
  static const String PHARMACY_ID_FOR_SOCKET = "pharmacy_id";
  static const String DRIVER_TYPE = "driverType";
  static const String USER_NAME = "name";
  static const String USER_EMAIL = "email";
  static const String USER_MOBILE = "mobile";

  static const String ROUTE_NAME = "route_name";
  static const String ROUTE_ID = "route_id";
  static const String BRANCH_ID = "branchid";
  static const String DELIVERY_TIME = "delivery time";
  static const String IS_ADDRESS_UPDATED = "address_updated";

  static const String GOOGLE_API_KEY =
      "AIzaSyBNHJl7_F47ZzPbhrZGweI_dPgehUSNb8E"; //"AIzaSyCNCobhUuf5nWFLz3ET-p8eCUOazDIx_HM";//"AIzaSyCs7fM_5fM4YyUOqbH8l_4GFNTonfrjMmw";
  static const String MAPBOX_TIKEN_KEY =
      "pk.eyJ1IjoiYXBwbndlYnRlc3RpbmciLCJhIjoiY2t4eWZ3cXY3MnE0YjJ1bXZjeG1rdDdqaiJ9.lK3Xk1D-9ZPMZ7WfYdoXWA"; //"AIzaSyCs7fM_5fM4YyUOqbH8l_4GFNTonfrjMmw";

  static const String Status_total = "total";
  static const String Status_picked_up = "Pickedup";
  static const String Status_out_for_delivery = "OutForDelivery";
  static const String Status_delivered = "Completed";
  static const String Status_failed = "Failed";
  static const String IS_ROUTE_START = "isRouteStart";
  static const String IS_LOGIN = "isLogin";
  static const String START_MILES = "startMiles";
  static const String VEHICLE_ID = "vehicle_id";
  static const String SHOW_POPUP = "showPopUp";
  static const String VIR_Value = "vehicleInspectionReport";
  static const String END_MILES = "endMiles";
  static const String PHARMACY_ID = "pharmacyId";
  static const String IS_PRES_CHARGE = "isPresCharge";
  static const String IS_DEL_CHARGE = "isDelCharge";

  static const String SOCKET_URL = 'wss://pharmdel.com:3000'; //socket live url
  // static const String SOCKET_URL = 'wss://pharmdel.co.uk:3000'; // socket staging url

  //===============================================API=============================================
  //Local
   static final String BASEURL = "https://www.pharmdel.com"; //Live url0
  // static final String BASEURL = "https://www.pharmdel.co.uk"; //Staging url

  static final String SENTRY_KEY = 'https://f0b19f0ee11740bbaab4453a30a51828@o1271692.ingest.sentry.io/6464324';

  static final String BASE_URL = BASEURL + "/api/Delivery/v22/";
  static final String BASE_URL_PHARMACY = BASEURL + "/api/Pharmacy/v22/";

  static final String PRIVACY_URL = BASEURL + "/privacy-policy-app";
  static final String TERMS_URL = BASEURL + "/terms-condition-app";

  static final LOGIN_URL = BASE_URL + "Login?";
  static final UPDATE_MILES = BASE_URL + "updateMiles";

  static final DELIVERY_LIST_URL = BASE_URL_PHARMACY + 'Delivery';
  static final DELETE_NURSING_ORDER = BASE_URL_PHARMACY + 'deleteOrderByOrderId';
  static final UPDATE_NURSING_ORDER = BASE_URL_PHARMACY + 'updateStorageByOrderId';
  static final BASE_URL_UPLOADIMAGE = BASE_URL_PHARMACY + 'imageUpload';
  static final COLLECTION_LIST_URL = BASE_URL_PHARMACY + "GetCollection?firstName=";
  static final PATAINET_LIST_URL = BASE_URL_PHARMACY + "GetPatient?firstName=";
  static final GET_PROFILE_URL_PHARMACY = BASE_URL_PHARMACY + "GetProfile";
  static final GET_LOGOUT_URL_PHARMACY = BASE_URL_PHARMACY + "Logout";
  static final GET_NOTIFICATION_PHARMACY = BASE_URL_PHARMACY + "GetNotifications";
  static final NOTIFICATIONS = BASE_URL_PHARMACY + "Notifications";
  static final CREATE_NOTIFICATION = BASE_URL_PHARMACY + "CreateNotification";
  static final SAVE_NOTIFICATION = BASE_URL_PHARMACY + "SaveNotification";
  static final GET_MEDICINELIST_PHARMACY = BASE_URL_PHARMACY + "GetMedicineList";
  static final GET_NOTIFICATION_DRIVER = BASE_URL + "GetNotifications";
  static final GET_ROUTE_URL_PHARMACY = BASE_URL_PHARMACY + "GetRoutes";
  static final GET_DeliveryMasterData_URL_PHARMACY = BASE_URL_PHARMACY + "getDeliveryMasterData";
  static final CREATE_PATIENT_URL = BASE_URL_PHARMACY + "createPatient";
  static final GET_ROUTE_FOR_PHARMACY = BASE_URL_PHARMACY + "RouteFromPharmacy";
  static final PHARMACY_STATUS_UPDATE_URL = BASE_URL_PHARMACY + "Complete";
  static final PHARMACY_SIGNATURE_UPLOAD_URL = BASE_URL_PHARMACY + "Acknowledge";
  static final PHARMACY_LIST_URL = BASE_URL_PHARMACY + "GetOrder?orderId=";
  static final GetPHARMACYDriverListByRoute = BASE_URL_PHARMACY + "GetDriverListByRoute";
  static final ORDER_DETAILS_LIST_URL = BASE_URL + "GetOrder?orderId=";

  // static final COLLECT_ORDER_LIST_URL      = BASE_URL + "Complete";
  static final DELIVERY_STATUS_UPDATE_URL = BASE_URL + "Complete";
  static final DELIVERY_SIGNATURE_UPLOAD_URL = BASE_URL + "Acknowledge";
  static final FORGOT_PASSWORD_URL = BASE_URL + "ForgotPassword?customerEmail=";
  static final SIGNUP_URL = BASE_URL + "customerHotelQR/signup?";
  static final HOME_WIDGETS_URL = BASE_URL + "api/v1/attendance/homedata.php?";
  static final SEND_TOKEN_URL = BASE_URL + "api/v1/Delivery/CreateToken";

  static final GET_PROFILE_URL = BASE_URL + "GetDriverProfile";
  static final GET_UPDATE_PROFILE_URL = BASE_URL + "updateProfile";
  static final GET_LOGOUT_URL = BASE_URL + "Logout";
  static final GET_ROUTE_URL = BASE_URL + "GetRoutes";
  static final GET_VEHICLE_INFO = BASE_URL + "getVehicleList";
  static final UPDATE_ROUTE_URL = BASE_URL + "api/v1/Delivery/UpdateRoute";
  static final CHECK_COLLECTION_ORDER_URL = BASE_URL_PHARMACY + "CheckOrderByOrderId";
  static final GetDriverListByRoute = BASE_URL + "api/v1/Driver/GetDriverListByRoute";
  static final SAVE_DATA_WITH_SOCKET = BASE_URL + "SaveSocketData";
  static final SETPIV_DRIVER = BASE_URL + "setPin";
  static final GET_PARCEL_BOX = BASE_URL_PHARMACY + "getParcelBoxData";
  static final GET_PHARMACY_INFO = BASE_URL_PHARMACY + "getPharmacyInfo";
  static final GET_NURSING_BY_PHARMACY = BASE_URL + "getNhomeByPharmacy?pharmacy_id=";

  // -------------------------------------------------

  //Branch Admin
  static final REGISTER_CUSTOMER_WITH_ORDER = BASE_URL_PHARMACY + "processScan";
  static final UUDATE_CUSTOMER_WITH_ORDER = BASE_URL_PHARMACY + "createOrder";
  static final GET_ALL_SHELF_BY_BRANCH_ADMIN = BASE_URL_PHARMACY + "GetShelfByBranchId";
  static final SCAN_ASSIGN_TO_SHELF_PARCEL = BASE_URL_PHARMACY + "getpatientdetailsbyorderId";
  static final ADD_ASSIGN_TO_SHELF_PARCEL = BASE_URL_PHARMACY + "assingtoshelfbyorderid";
  static final UPDATEAPP_URL = BASE_URL_PHARMACY + "checkUpdateApp";
  static final UPLOAD_IMG = BASE_URL_PHARMACY + "imageUpload?order_image";
  static final GET_NURSING_HOME = BASE_URL_PHARMACY + "getNursingHomes";
  static final GET_TOTE = BASE_URL_PHARMACY + "getBoxesByNursingHome?nursing_id=";
  static final CREATE_CUSTOMER = BASE_URL_PHARMACY + "createCustomer";
  static final GET_NURSING_ORDERS = BASE_URL_PHARMACY + "getNursingOrder";

  //Driver
  static final GET_DELIVERY_LIST = BASE_URL + "GetDeliveryList";
  static final GetNotificationCount = BASE_URL + "GetNotificationCount";
  static final GET_SORTEDLIST_BY_DURATION = BASE_URL + "GetDelivarieswithRouteShort";
  static final SCAN_ORDER_BY_DRIVER = BASE_URL + "ScanOrderByDriver";
  static final SCAN_ORDER_BULK_BY_DRIVER = BASE_URL + "BulkScanOrderByDriver";
  static final SCAN_ORDER_BY_DRIVER_TO_COMPLETE = BASE_URL + "checkcustomerwithorder";
  static final START_ROUTE_BY_DRIVER = BASE_URL + "UpdateOrderStatusWithStartRoute";
  static final GETALLDELIVERY = BASE_URL + "GetAllDelivery";
  static final GET_DRIVER_POINTS = BASE_URL_PHARMACY + "DriverRoutePoints";
  static final END_ROUTE_BY_DRIVER = BASE_URL + "endroutebydrvier";
  static final MAKE_NEXT_BY_DRIVER = BASE_URL + "MakeNextOrderSort";
  static final BULK_RESCHEDULE = BASE_URL + "BulkReschedule";
  static final BULK_RESCHEDULE_Pharmacy = BASE_URL_PHARMACY + "BulkReschedule";
  static final UPDATE_BREAK_TIME = BASE_URL + "updateBreakTime";
  static final INSPECTION_SUBMIT = BASE_URL + "submitInspection";
  static final GET_INSPECTION_DATA = BASE_URL + "getInspectionData";

  //Master
  static final ALL_QUESTION = BASE_URL + "AllQuestions";

  //------------------------------------------------------------
  static DateFormat formate = DateFormat("yyyy-MM-dd");

  static String kQuickPin = "quickPin";

  static const String APP_STORE_URL = "https://apps.apple.com/in/app/pharmdel-business/id1608513104";
  static const String PLAY_STORE_URL = "https://play.google.com/store/apps/details?id=com.pharmdel_business";
  static const String INTERNET_NOT_AVAILABE = "Something went wrong, Failed connection with server.";
  static const String INTERNET_NOT_AVAILABENEW = "Something went wrong, Failed connection with Internet.";

  static const String ERRORMESSAGE = "OOPS! something went wrong";

  //work statrt by dk
  static const String SUCESSFULLY_UPDATED = "Successfully updated";
  static const String CLOSE = "Close";
  static const String LOGOUT = "Logout";
  static const String ARE_YOU_SURE_LOGOUT = "Are you sure to logout?";
  static const String CANCEL = "CANCEL ";
  static const String YES = "YES ";
  static const String DELIVERY_LIST = "Delivery List";
  static const String Check_Again = "Check Again";
  static const String Click_Images = "Click Images";
//VIR

//WebConstant.Check_Again
}
