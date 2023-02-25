

 import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastCustom{

  static showToast({required String msg}){
    Fluttertoast.showToast( msg:msg,textColor: Colors.white);
  }

}