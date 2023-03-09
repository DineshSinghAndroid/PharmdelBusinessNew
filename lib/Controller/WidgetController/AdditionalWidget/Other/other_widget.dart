import 'package:flutter/material.dart';
import '../../../Helper/TextController/BuildText/BuildText.dart';
import '../../StringDefine/StringDefine.dart';

class WidgetCustom{
  WidgetCustom._privateConstructor();
  static final WidgetCustom instance = WidgetCustom._privateConstructor();


  static Widget drawerBtn({required Function() onTap,required String title, required IconData icon}){
    return ListTile(
        onTap: onTap,
        visualDensity: const VisualDensity(vertical: -1,horizontal: -4),
        leading: Icon(icon,size: 20),
        title:BuildText.buildText(text: title)
    );
  }
  static Widget drawerPersonalInfoWidget({String? title, required IconData icon}){
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Icon( icon,color: Colors.grey,size: 12,),
          buildSizeBox(0.0, 10.0),
          BuildText.buildText(text: title ?? kNotFound)
        ],
      ),
    );
  }
}