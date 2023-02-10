//@dart=2.9
import 'package:flutter/material.dart';

import '../main.dart';
import 'loading_screen.dart';

bool isDialogShoing = false;
BuildContext contexDialog;

class CustomLoading {
  static final CustomLoading _singleton = CustomLoading._internal();

  factory CustomLoading() {
    return _singleton;
  }

  CustomLoading._internal();

  Future<bool> showLoadingDialog(BuildContext context, bool isShowing) async {
    try {
      if (!isDialogShoing && isShowing) {
        isDialogShoing = true;
        showDialog(
            context: context,
            barrierDismissible: false,
            // user must tap button for close dialog!
            builder: (BuildContext context) {
              contexDialog = context;
              return WillPopScope(
                onWillPop: () async => false,
                child: Dialog(
                  key: Key(getRandomString(10)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                  insetPadding: EdgeInsets.all(20),
                  backgroundColor: Colors.transparent,
                  child: LoaderTransparent(),
                ),
              );
            });
        return Future.value(true);
      } else {
        if (!isShowing && isDialogShoing) {
          isDialogShoing = false;
          Navigator.pop(contexDialog);
        }
        return Future.value(true);
      }
    } catch (_) {
      return Future.value(true);
    }
  }
}
