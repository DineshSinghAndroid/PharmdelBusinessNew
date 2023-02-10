// @dart=2.9
import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class NetworkUtil {
  // next three lines makes this class a Singleton
  static NetworkUtil _instance = new NetworkUtil.internal();

  NetworkUtil.internal();

  factory NetworkUtil() => _instance;

  final JsonDecoder _decoder = new JsonDecoder();

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  Future<dynamic> get(String url, String token) {
    // print('$url $token');
    Map<String, String> headers = {'Accept': 'application/json', "Content-type": "application/json", "Authorization": 'Bearer $token'};
    return http.get(Uri.parse(url), headers: headers).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode == 401) {
        Fluttertoast.showToast(msg: "Session Expired, Login Again", toastLength: Toast.LENGTH_LONG);
        Map<String, dynamic> map = {"code": statusCode.toString()};
        return map;
      } else if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return _decoder.convert(res);
    });
  }

  Future<dynamic> postLogin(String url, {Map headers, body, encoding}) {
    return http.post(Uri.parse(url), body: body, headers: headers, encoding: encoding).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return _decoder.convert(res);
    });
  }

  Future<dynamic> post(String url, String deliveryId, String remarks, String deliveredTo, var deliveryStatus, Map<String, String> data, String token) {
    Map<String, String> head = {'Accept': 'application/json', 'Content-type': 'application/json', 'Authorization': 'Bearer $token'};
    List orderid = [];
    orderid.add(deliveryId.toString());
    Map<String, dynamic> jsonObject = {
      'deliveryId': orderid,
      'remarks': remarks,
      'deliveredTo': deliveredTo,
      'deliveryStatus': deliveryStatus,
      'rescheduleDate': data["rescheduleDate"],
      'parcel_box_id': data["parcel_box_id"],
      'payment_method': data['payment_method'],
      'del_charge': data['del_charge'],
      'payment_remark': data['payment_remark'],
      'subs_id': data['subs_id'],
      'rx_invoice': data['rx_invoice'],
      'rx_charge': data['rx_charge'],
    };
    final j = json.encode(jsonObject);
    return http.post(Uri.parse(url), body: j, headers: head).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode == 401) {
        Fluttertoast.showToast(msg: "Session Expired, Login Again", toastLength: Toast.LENGTH_LONG);
        return '401';
      } else if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return _decoder.convert(res);
    });
  }

  Future<dynamic> postSign(String url, String deliveryId, String sign, String token) {
    Map<String, String> head = {'Accept': 'application/json', 'Content-type': 'application/json', 'Authorization': 'Bearer $token'};
    Map<String, dynamic> jsonObject = {
      'deliveryId': int.parse(deliveryId),
      'baseSignature': sign,
    };
    final j = json.encode(jsonObject);
    return http.post(Uri.parse(url), body: j, headers: head).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode == 401) {
        Fluttertoast.showToast(msg: "Session Expired, Login Again", toastLength: Toast.LENGTH_LONG);
        return '401';
      } else if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return _decoder.convert(res);
    });
  }
}

//MARK:- FONTS STYLE
const kTextFieldTextStyle = TextStyle(color: Colors.black, fontSize: 18.0, fontFamily: 'CalibriRegular', fontWeight: FontWeight.normal);

const kButtonTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 18.0,
  fontWeight: FontWeight.bold,
  fontFamily: 'CalibriBold',
);
