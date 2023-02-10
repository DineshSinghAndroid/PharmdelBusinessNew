import 'dart:math';
import 'package:flutter/material.dart';
import 'LoadingWidget.dart';

class CustomLoading{

  // bool isDialogShowing = false;
  BuildContext? contextDialog;
  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();
  static final CustomLoading _singleton = CustomLoading._internal();

  factory CustomLoading() {
    return _singleton;
  }

  CustomLoading._internal();



  Future<bool> show(BuildContext context)async{
    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          // user must tap button for close dialog!
          barrierColor: Colors.transparent,
          builder: (BuildContext context) {
            contextDialog = context;
            return WillPopScope(
              onWillPop: () async => false,
              child: Dialog(
                key: Key(getRandomString(10)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
                insetPadding: const EdgeInsets.all(20),
                backgroundColor: Colors.transparent,
                child: LoadingWidget(),
              ),
            );
          });
      return Future.value(true);
    }catch(_){
      return Future.value(true);
    }
  }

  Future<bool> hide(BuildContext context)async{
    try {
      Navigator.pop(contextDialog!);
      return Future.value(true);
    }catch(_){
      return Future.value(true);
    }
  }




  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

}