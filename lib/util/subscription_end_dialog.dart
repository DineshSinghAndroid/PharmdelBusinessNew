// @dart=2.9
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:progress_dialog/progress_dialog.dart';

class SubscriptionEndDialog extends StatefulWidget {
  final String btnDone, btnNo;
  final OnClicked onClicked;

  const SubscriptionEndDialog({Key key, this.btnDone, this.btnNo, this.onClicked}) : super(key: key);

  @override
  _SubscriptionEndDialogState createState() => _SubscriptionEndDialogState();
}

class _SubscriptionEndDialogState extends State<SubscriptionEndDialog> {
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
              Text(
                "Alert...",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "This patient's subscription has been end",
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 22,
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
                            if (widget.onClicked != null) widget.onClicked(false);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0.0, right: 10),
                            child: Text(
                              widget.btnNo,
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
                            Navigator.pop(context);
                            if (widget.onClicked != null) widget.onClicked(true);
                          },
                          child: Text(
                            widget.btnDone,
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
        Positioned(
          top: 55.0,
          right: 10.0,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.clear),
          ),
        ),
        Positioned(
          left: 20,
          right: 20,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 45,
            child: Container(width: 60, height: 60, child: Image.asset("assets/sad.png")),
          ),
        ),
      ],
    );
  }
}

typedef OnClicked = void Function(bool value);
