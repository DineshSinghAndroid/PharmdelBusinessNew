//@dart=2.9
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoaderTransparent extends StatelessWidget {
  double height = 60.00;
  double width = 60.00;
  Color colorValue;

  LoaderTransparent({this.colorValue});

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
          Container(
              height: 150.00,
              width: 200.00,
              // decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15.00), boxShadow: [
                // BoxShadow(
                //   color: Colors.grey,
                //   spreadRadius: 5,
                //   blurRadius: 7,
                //   offset: Offset(0, 3), // changes position of shadow
                // ),
              // ]),
              child: Center(
                  child: SizedBox(
                      height: 150.0,
                      width: 300.0,
                      child: Lottie.network('https://assets4.lottiefiles.com/packages/lf20_wfsunjgd.json'),
                      // child: Image.asset(
                      //   'assets/loading.gif',
                      //   fit: BoxFit.fill,
                      // ) // use you custom loader or default loader
                      ))),
        ],
      ),
    );
  }
}
