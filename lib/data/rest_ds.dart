import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pharmdel_business/data/web_constent.dart';
import 'package:pharmdel_business/model/User.dart';
import 'package:pharmdel_business/util/network_utils.dart';

import '../main.dart';

class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();

  Future<Map<String, Object>> loginGetMethod(String username, String password, String deviceName, String fcm_token) {
    String url = WebConstant.LOGIN_URL + "email=" + username + "&password=" + password + "&device_name=" + deviceName + "&fcm_token=" + fcm_token;
    // print(url);
    logger.i(url);
    return _netUtil.postLogin(url).then((dynamic res) {
      // print("restttt"+res.toString());
      //  if (res == null) throw new Exception(res["error_msg"]);
      return res;
    });
  }

  Future<Map<String, Object>> deliverylistGetMethod(String userId, String token) {
    return _netUtil.get(WebConstant.DELIVERY_LIST_URL, token).then((dynamic res) {
      //print(res.toString());
      // if (res == null) throw new Exception(res["error_msg"]);

      return res;
    });
  }

  Future<Map<String, Object>> deliveryStatusUpdate(String deliveryId, String remarks, String deliveredTo, var deliveryStatus, Map<String, String> map, String token) {
    logger.i(WebConstant.PHARMACY_STATUS_UPDATE_URL);
    logger.i(map);
    return _netUtil.post(WebConstant.PHARMACY_STATUS_UPDATE_URL, deliveryId, remarks, deliveredTo, deliveryStatus, map, token).then((dynamic res) {
      //print(res.toString());
      logger.i(res);
      // if (res == null) throw new Exception(res["error_msg"]);

      return res;
    });
  }

  Future<Map<String, Object>> deliverySignUpload(String deliveryId, String sign, String token) {
    return _netUtil.postSign(WebConstant.DELIVERY_SIGNATURE_UPLOAD_URL, deliveryId, sign, token).then((dynamic res) {
      //print(res.toString());
      // if (res == null) throw new Exception(res["error_msg"]);

      return res;
    });
  }

  Future<http.Response> deliveryListGetMethod(String userId, String token) {
    return http.post(
      Uri.parse(WebConstant.DELIVERY_LIST_URL),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'userId': userId,
        'token': token,
      }),
    );
  }

  Future<Map<String, dynamic>> homeMenu(String userId, String token) {
    return _netUtil.get(WebConstant.HOME_WIDGETS_URL + "userId=" + userId, token).then((dynamic res) {
      // print(res.toString());
      //  if (res == null) throw new Exception(res["error_msg"]);

      return res;
    });
  }

  Future getHomeData(String userId, String userType) {
    var url = WebConstant.HOME_WIDGETS_URL + "userId=" + userId + "&userType=" + userType;
    return http.get(Uri.parse(url));
  }

  Future<User> login(String username, String password) {
    return _netUtil.postLogin(WebConstant.LOGIN_URL, body: {"username": username, "password": password}).then((dynamic res) {
      // print(res.toString());
      if (res["error"]) throw new Exception(res["error_msg"]);
      return new User.map(res["user"]);
    });
  }
}
