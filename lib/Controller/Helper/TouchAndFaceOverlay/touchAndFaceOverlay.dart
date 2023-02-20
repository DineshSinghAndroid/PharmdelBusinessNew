import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../StringDefine/StringDefine.dart';
import '../TextController/BuildText/BuildText.dart';

class TouchAndFaceIdOverlay extends StatefulWidget {
  const TouchAndFaceIdOverlay({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => TouchAndFaceIdOverlayState();
}

class TouchAndFaceIdOverlayState extends State<TouchAndFaceIdOverlay> with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? scaleAnimation;

  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1700));
    scaleAnimation = CurvedAnimation(parent: controller!, curve: Curves.elasticInOut);

    controller!.addListener(() {
      setState(() {});
    });
    controller!.forward();
  }

  @override
  Widget build(BuildContext context) {
    //progressDialog = new ProgressDialog(context);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    /*progressDialog.style(
        message: "Please wait...",
        borderRadius: 4.0,
        backgroundColor: Colors.white);*/
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation!,
          child: Container(
              margin: const EdgeInsets.all(20.0),
              padding: const EdgeInsets.all(15.0),
              height: 330.0,
              decoration: ShapeDecoration(color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
              child: Column(
                children: <Widget>[
                  buildSizeBox(50.0, 0.0),
                  const Text(
                    kTouchAndFaceNtAct,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15),
                  ),                
                  buildSizeBox(50.0, 0.0),
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[                
                      Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 10.0, top: 10.0, bottom: 10.0),
                          child: SizedBox(
                              height: 35.0,
                              width: 110.0,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                ),
                                child: const Text(
                                  kCancel,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 13.0),
                                ),
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                              ))),                    
                    ],
                  )),
                buildSizeBox(10.0, 0.0),
                ],
              )),
        ),
      ),
    );
  }
}