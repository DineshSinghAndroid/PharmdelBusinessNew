import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../Helper/ColorController/CustomColors.dart';


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
      color: Colors.black12,
      child: Center(
        child: Container(
          height: 50,
          width: 50,
          padding: const EdgeInsets.all(5.0),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white
          ),
          child: Center(
            child: SpinKitSpinningLines(
              color: CustomColors.loaderColor,
              lineWidth: 8,
              itemCount: 1,
              size: 50.0
            ),
          ),
        ),
      ),
    );
  }
}