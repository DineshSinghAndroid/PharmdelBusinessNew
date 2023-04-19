import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalenderCustom{
    CalenderCustom._privateConstructor();
    static final CalenderCustom instance = CalenderCustom._privateConstructor();

  static Future<DateTime> getCalenderDate()async{
    DateTime date = DateTime.now();

    await showDatePicker(
        context: Get.overlayContext!,
        initialDate: DateTime(date.year, date.month, date.day),
        firstDate: DateTime(date.year, date.month, date.day),
        lastDate: DateTime(2050),
        builder: (BuildContext? context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: const ColorScheme.light(primary: Colors.orangeAccent),
              buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child ?? Container(height: 50,width: 50,color: Colors.black,),
          );
        }).then((value) {
          if(value != null){
            date = value;
            return value;
          }
    });
    return date;
  }
}