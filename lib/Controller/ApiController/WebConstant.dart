class WebApiConstant {

  /// Socket Url
  static const String SOCKET_URL = 'wss://pharmdel.com:3000'; //socket live url
  // static const String SOCKET_URL = 'wss://pharmdel.co.uk:3000'; // socket staging url

  ///Google Api Key
  static const String GOOGLE_API_KEY                         = "AIzaSyAE6nVrsXWIXPFY6e7D0IQ9KACpv46HWw4";


  static const String BASE_URL_DOMAIN                        =  "https://www.pharmdel.com";
<<<<<<< HEAD
  static const String BASE_URL                               =  BASE_URL_DOMAIN +"/api/Delivery/v24/";
  static const String BASE_URL_PHARMACY                      =  BASE_URL_DOMAIN +"/api/Pharmacy/v24/";
=======
  static const String BASE_URL                               =  "$BASE_URL_DOMAIN/api/Delivery/v22/";
  static const String BASE_URL_PHARMACY                      =  "$BASE_URL_DOMAIN/api/Pharmacy/v22/";
>>>>>>> 8b081882a3eced9002e51a19f4537178dbc5c90a

  /// Public
  static const String API_URL_INTRO                          =  "${BASE_URL}intro";
  static const String SETPIV_DRIVER                          =  "${BASE_URL}setPin";
  static const String LOGINURL_DRIVER                        =  "${BASE_URL}Login";
  static const String TERMS_URL                              =  "$BASE_URL_DOMAIN/terms-condition-app";
  static const String PRIVACY_URL                            =  "$BASE_URL_DOMAIN/privacy-policy-app";
  static const String NOTIFICATION_URL                       =  "${BASE_URL}GetNotifications";
  static const String GET_DRIVER_PROFILE_URL                 =  "${BASE_URL}GetDriverProfile";
  static const String GET_NOTIFICATION_COUNT                 =  "${BASE_URL}GetNotificationCount";
  static const String GET_DELIVERY_LIST                      =  "${BASE_URL}GetDeliveryList";
  static const String GET_DRIVER_ROUTES                      =  "${BASE_URL}GetRoutes";
  static const String GET_UPDATE_ORDER_STATUS_WITH_START_ROUTES =  "${BASE_URL}UpdateOrderStatusWithStartRoute";
  static const String GET_VEHICLE_LIST_URL                   =  "${BASE_URL}getVehicleList";
  static const String FORGOT_PASSWORD_URL                    =  "${BASE_URL}ForgotPassword?customerEmail=";
  static const String LUNCH_BREAK_URL                        =  "${BASE_URL}updateBreakTime";
  static const String DELIVERY_SIGNATURE_UPLOAD_URL          =  "${BASE_URL}Acknowledge";
  static const String SCAN_ORDER_BY_DRIVER                   =  "${BASE_URL}ScanOrderByDriver";
  static const String GET_ALL_DELIVERY                       =  "${BASE_URL}GetAllDelivery";
  static const String GET_UPDATE_PROFILE_URL                 =  "${BASE_URL}updateProfile";
  static const String END_ROUTE_BY_DRIVER                    ="${BASE_URL}endroutebydrvier";

  static const String UPDATE_CUSTOMER_WITH_CREATE_ORDER      =  "${BASE_URL_PHARMACY}createOrder";
  static const String CREATE_PATIENT_URL                     =  "${BASE_URL_PHARMACY}createPatient";
  static const String GET_PHARMACY_INFO                      ="${BASE_URL_PHARMACY}getPharmacyInfo";

  static const String LOGOUT_URL_PHARMACY                    =  "${BASE_URL_PHARMACY}Logout";
  static const String Logout_URL                             =  "${BASE_URL}Logout";

  static const GET_SORTEDLIST_BY_DURATION                    = "${BASE_URL}GetDelivarieswithRouteShort";
  static const UPDATE_MILES                                  = "${BASE_URL}updateMiles";
  static const UPDATE_DELIVERY_STATUS_URL                    = "${BASE_URL}Complete";
  static const RESCHEDULE_DELIVERY_URL                       = "${BASE_URL}BulkReschedule";
  static const MAKE_NEXT_BY_DRIVER                           = "${BASE_URL}MakeNextOrderSort";
  static const PROCESS_SCAN_URL                              = "${BASE_URL_PHARMACY}processScan";
  static const UPDATE_STORAGE_BY_ORDER_ID                    = "${BASE_URL_PHARMACY}updateStorageByOrderId";
  static const DELETE_ORDER_BY_ORDER_ID                      = "${BASE_URL_PHARMACY}deleteOrderByOrderId";
  static const GET_MEDICINE_LIST                             = "${BASE_URL_PHARMACY}GetMedicineList";
  static const GET_DELIVERY_MASTER_DATA_API                  = "${BASE_URL_PHARMACY}getDeliveryMasterData";

  ///Pharmacy
  static const String GET_PATIENT_LIST_URL                   =  "${BASE_URL_PHARMACY}GetPatient";
  static const String Get_PHARMACY_DriverList_ByRoute        =  "${BASE_URL_PHARMACY}GetDriverListByRoute";
  static const String GET_PHARMACY_PARCEL_BOX_URL            =  "${BASE_URL_PHARMACY}getParcelBoxData";
  static const String GET_PHARMACY_PATIENT_DETAILS           =  "${BASE_URL_PHARMACY}getpatientdetailsbyorderId";
  static const String GET_PHARMACY_NOTIFICATION              =  "${BASE_URL_PHARMACY}GetNotifications";
  static const String GET_ROUTE_URL_PHARMACY                 =  "${BASE_URL_PHARMACY}GetRoutes";
  static const String GET_PHARMACY_PROFILE_URL               =  "${BASE_URL_PHARMACY}GetProfile";
  static const String GET_PHARMACY_CREATE_NOTIFICATION       =  "${BASE_URL_PHARMACY}CreateNotification";
  static const String GET_PHARMACY_SAVE_NOTIFICATION         =  "${BASE_URL_PHARMACY}SaveNotification";
  static const String GET_PHARMACY_UPDATE_NURSING_ORDER      =  "${BASE_URL_PHARMACY}updateStorageByOrderId";
  static const String GET_PHARMACY_DELETE_NURSING_ORDER      =  "${BASE_URL_PHARMACY}deleteOrderByOrderId";
  static const String GET_PHARMACY_DELIVERY_LIST             =  "${BASE_URL_PHARMACY}Delivery";
  static const String GET_PHARMACY_NURSING_HOME              =  "${BASE_URL_PHARMACY}getNursingHomes";
  static const String GET_PHARMACY_BOXES                     =  "${BASE_URL_PHARMACY}getBoxesByNursingHome";
  static const String GET_PHARMACY_SIGNATURE_UPLOAD_URL      =  "${BASE_URL_PHARMACY}Acknowledge";
  static const String GET_SENT_NOTIFICATION_URL              =  "${BASE_URL_PHARMACY}Notifications";
  static const String GET_MAP_ROUTE_FOR_PHARMACY             =  "${BASE_URL_PHARMACY}RouteFromPharmacy";
  static const String GET_PHARMACY_DRIVER_ROUTE_POINTS       =  "${BASE_URL_PHARMACY}DriverRoutePoints";
  static const String GET_PHARMACY_DELIVERY_MASTER_URL       =  "${BASE_URL_PHARMACY}getDeliveryMasterData";
  static const String GET_PHARMACY_CREATE_ORDER_URL          =  "${BASE_URL_PHARMACY}createOrder";
  static const String GET_PHARMACY_MEDICINE_LIST             =  "${BASE_URL_PHARMACY}GetMedicineList";
<<<<<<< HEAD
  static const String GET_PHARMACY_PROCESS_SCAN_URL                  =  "${BASE_URL_PHARMACY}getBoxesByNursingHome";
=======
  static const String GET_PHARMACY_PROCESS_SCAN_URL          =  "${BASE_URL_PHARMACY}processScan";
>>>>>>> 8b081882a3eced9002e51a19f4537178dbc5c90a


}
