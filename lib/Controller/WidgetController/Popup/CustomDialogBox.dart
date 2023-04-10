 import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
<<<<<<< HEAD

import '../../Helper/Colors/custom_color.dart';
import '../../Helper/TextController/BuildText/BuildText.dart';
=======
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';

>>>>>>> 8b081882a3eced9002e51a19f4537178dbc5c90a
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
      children: [
        Container(
          padding: const EdgeInsets.only(left: 10, top: 45, right: 10, bottom: 20),
          margin: const EdgeInsets.only(top: 45),
          decoration: BoxDecoration(shape: BoxShape.rectangle, color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [
            BoxShadow(color: AppColors.blackColor, offset: const Offset(0, 10), blurRadius: 10),
          ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (widget.title != null)
                BuildText.buildText(
                  text: widget.title ??'',
                  size: 22,
                  weight: FontWeight.w600,                  
                ),
              if (widget.title != null)
                buildSizeBox(15.0, 0.0),
              if (widget.descriptionWidget != null) widget.descriptionWidget!,
              if (widget.descriptions != null)
                BuildText.buildText(
                  text: widget.descriptions??'',
                  size: 14,                  
                  textAlign: TextAlign.center,
                ),
              if (widget.descriptions != null || widget.descriptionWidget != null)
                buildSizeBox(22.0, 0.0),
              if (widget.textField != null) widget.textField!,
              if (widget.textField != null)
                buildSizeBox(10.0, 0.0),
              if (widget.cameraIcon != null) widget.cameraIcon!,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.button1 != null) widget.button1!,
                  const Spacer(),
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
                            fixedSize: const Size.fromHeight(30),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            if (widget.onClicked != null) widget.onClicked!(false);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0.0, right: 10),
                            child: BuildText.buildText(
                              text: widget.btnNo!,
                              style: TextStyle(fontSize: 18, color: widget.btnNo == "Reoptimise stops" ? Colors.blueAccent : Colors.black),
                              textAlign: TextAlign.start,
                            ),
                          )),
                    ),
                  const Spacer(),
                  if (widget.btnDone != null)
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                          style: TextButton.styleFrom(
                            fixedSize: const Size.fromHeight(30),
                          ),
                          // color: widget.btnDone == "End Route" ? Colors.orange : Colors.transparent,
                          onPressed: () {
                            // stopWatchTimer.onResetTimer();
                            // stopWatchTimer.onEnded();
                            Navigator.pop(context);
                            if (widget.onClicked != null) widget.onClicked!(true);
                          },
                          child: BuildText.buildText(
                            text: widget.btnDone!,
                            size: 18,                                                        
                            color: widget.btnDone == "End Route"
                                    ? AppColors.redColor
                                    : widget.btnDone == "Skip"
                                    ? AppColors.colorOrange
                                    : AppColors.blackColor),
                          ),
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
              backgroundColor: AppColors.whiteColor,
              radius: 45,
              child: SizedBox(
                  width: 60,
                  height: 60,
                  child: widget.descriptions == 'Please wait\nWe are updating your offline deliveries.' || widget.descriptions == "Please wait\nWe are updating deliveries and ending route."
                      ? const CircularProgressIndicator(
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

<<<<<<< HEAD
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
=======


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
>>>>>>> 8b081882a3eced9002e51a19f4537178dbc5c90a
