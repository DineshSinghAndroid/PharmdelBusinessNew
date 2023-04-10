import 'package:flutter/material.dart';
import 'package:pharmdel/Controller/Helper/Colors/custom_color.dart';
import '../StringDefine/StringDefine.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class LoadingWidget extends StatelessWidget {
  double height = 50.00;
  double width = 50.00;

  LoadingWidget({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Container(  
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10)
      ),    
      height: height,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              height: 120.00,
              width: 120.00,
              padding: const EdgeInsets.all(10),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white
              ),
              child: Center(
<<<<<<< HEAD
                  child: Image.asset(strGIF_LOADING)
              )
          ),
        ],
      ),
    );
  }
}

class LoadingWidget2 extends StatelessWidget {
  double height = 60.00;
  double width = 60.00;

  LoadingWidget2({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: height,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: SpinKitRing(
                color: AppColors.deepOrangeColor,
                size: 42.0,lineWidth: 5,
              ),
          ),
=======
                  child: SizedBox(                   
                      height: 150.0,
                      width: 300.0,
                      child: Image.asset(strGIF_LOADING),
                      ))),
>>>>>>> 8b081882a3eced9002e51a19f4537178dbc5c90a
        ],
      ),
    );
  }
}