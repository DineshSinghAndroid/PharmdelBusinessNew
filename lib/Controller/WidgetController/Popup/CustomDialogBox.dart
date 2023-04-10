 import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../Helper/Colors/custom_color.dart';
import '../../Helper/TextController/BuildText/BuildText.dart';
import '../StringDefine/StringDefine.dart';
 // import 'package:progress_dialog/progress_dialog.dart';

class CustomDialogBox extends StatefulWidget {
  final String ? title, descriptions, btnDone, btnNo;
  final Image ? img;
  final Widget ? closeIcon, descriptionWidget;
  final Widget ? textField;
  final Widget ? cameraIcon;
  final Widget ?button1;
  final Widget ? button2;
  final OnClicked ?onClicked;
  final Icon? icon;

    CustomDialogBox({  Key? key, this.icon, this.button1, this.button2, this.cameraIcon,  this.textField, this.onClicked,
    this.title, this.descriptions, this.btnDone, this.img, this.btnNo, this.closeIcon, this.descriptionWidget}) : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      insetPadding: EdgeInsets.all(20),
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 10, top: 45, right: 10, bottom: 20),
          margin: EdgeInsets.only(top: 45),
          decoration: BoxDecoration(shape: BoxShape.rectangle, color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [
            BoxShadow(color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
          ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (widget.title != null)
                Text(
                  widget.title ??'',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
              if (widget.title != null)
                SizedBox(
                  height: 15,
                ),
              if (widget.descriptionWidget != null) widget.descriptionWidget!,
              if (widget.descriptions != null)
                Text(
                  widget.descriptions??'',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              if (widget.descriptions != null || widget.descriptionWidget != null)
                SizedBox(
                  height: 22,
                ),
              if (widget.textField != null) widget.textField!,
              if (widget.textField != null)
                SizedBox(
                  height: 10,
                ),
              if (widget.cameraIcon != null) widget.cameraIcon!,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.button1 != null) widget.button1!,
                  Spacer(),
                  if (widget.button2 != null) widget.button2!,
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.btnNo != null)
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: TextButton(
                        // color: widget.btnDone == "End Route" ? Colors.grey : Colors.transparent,
                          style: TextButton.styleFrom(
                            fixedSize: Size.fromHeight(30),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            if (widget.onClicked != null) widget.onClicked!(false);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0.0, right: 10),
                            child: Text(
                              widget.btnNo!,
                              style: TextStyle(fontSize: 18, color: widget.btnNo == "Reoptimise stops" ? Colors.blueAccent : Colors.black),
                              textAlign: TextAlign.start,
                            ),
                          )),
                    ),
                  Spacer(),
                  if (widget.btnDone != null)
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                          style: TextButton.styleFrom(
                            fixedSize: Size.fromHeight(30),
                          ),
                          // color: widget.btnDone == "End Route" ? Colors.orange : Colors.transparent,
                          onPressed: () {
                            // stopWatchTimer.onResetTimer();
                            // stopWatchTimer.onEnded();
                            Navigator.pop(context);
                            if (widget.onClicked != null) widget.onClicked!(true);
                          },
                          child: Text(
                            widget.btnDone!,
                            style: TextStyle(
                                fontSize: 18,
                                color: widget.btnDone == "End Route"
                                    ? Colors.red
                                    : widget.btnDone == "Skip"
                                    ? Colors.orange
                                    : Colors.black),
                          )),
                    ),
                ],
              ),
            ],
          ),
        ),
        if (widget.closeIcon != null) widget.closeIcon!,
        if (widget.img != null || widget.icon != null)
          Positioned(
            left: 20,
            right: 20,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 45,
              child: Container(
                  width: 60,
                  height: 60,
                  child: widget.descriptions == 'Please wait\nWe are updating your offline deliveries.' || widget.descriptions == "Please wait\nWe are updating deliveries and ending route."
                      ? new CircularProgressIndicator(
                    value: null,
                    strokeWidth: 3.0,
                  )
                      : widget.img != null
                      ? widget.img
                      : widget.icon),
            ),
          ),
      ],
    );
  }
}

typedef OnClicked = void Function(bool value);

 class SuccessOrderDialog extends StatelessWidget {
   const SuccessOrderDialog({super.key});

   @override
   Widget build(BuildContext context) {
     return Dialog(
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
       child: Container(
         height: 200,
         decoration: BoxDecoration(
             color: AppColors.whiteColor,
             borderRadius: BorderRadius.circular(15)
         ),
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           crossAxisAlignment: CrossAxisAlignment.center,
           children: [
             Image.asset(strImg_tick),
             buildSizeBox(20.0, 0.0),
             BuildText.buildText(text: kOdrCrtdSucc,size: 16)
           ],
         ),
       ),
     );
   }
 }