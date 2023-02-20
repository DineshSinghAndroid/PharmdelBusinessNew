class WebApiConstant {

  /// Auth key

  /// Live url
  // static const String BASE_URL_DOMAIN                        =  "http://192.168.29.105:8300";
  static const String BASE_URL_DOMAIN                        =  "https://www.pharmdel.com";
  static const String BASE_URL                               =  BASE_URL_DOMAIN +"/api/Delivery/v22/";

  /// Public
  static const String API_URL_INTRO                          =  "${BASE_URL}intro";
    static const String SETPIV_DRIVER                          =  "${BASE_URL}setPin";
  static const String LOGINURL_DRIVER                        =  "${BASE_URL}Login";
  static const String TERMS_URL                              =  "${BASE_URL}terms-condition-app";
  static const String PRIVACY_URL                            =  "${BASE_URL}privacy-policy-app";
  static const String NOTIFICATION_URL                       =  "${BASE_URL}GetNotifications";
  static const String GET_DRIVER_PROFILE_URL                 =  "${BASE_URL}GetDriverProfile";
 
}
