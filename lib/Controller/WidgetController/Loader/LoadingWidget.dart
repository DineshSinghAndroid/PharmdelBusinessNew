import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../StringDefine/StringDefine.dart';


class LoadingWidget extends StatelessWidget {
  double height = 60.00;
  double width = 60.00;

  LoadingWidget({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Container(      
      height: height,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              height: 150.00,
              width: 200.00,          
              child: Center(
                  child: SizedBox(                   
                      height: 150.0,
                      width: 300.0,
                      child: Image.asset(strGIF_LOADING),
                      ))),
        ],
      ),
    );
  }
}