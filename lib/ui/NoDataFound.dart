// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmdel_business/util/RetryClickListner.dart';

class NoDataFound extends StatefulWidget {
  RetryClickListner clickListner;

  NoDataFound(RetryClickListner this.clickListner) : super();

  @override
  _NoDataFound createState() => _NoDataFound();
}

class _NoDataFound extends State<NoDataFound> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(margin: EdgeInsets.only(top: 60), height: 250, child: Image.asset("assets/img_no_data.png")),
          ),
          SizedBox(),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: InkWell(
          //     onTap: (){
          //       widget.clickListner.onClickListner();
          //     },
          //     child: Container(
          //       width: 70,
          //         alignment: Alignment.center,
          //         decoration: BoxDecoration(
          //           color: Colors.red,
          //           borderRadius: BorderRadius.all(Radius.circular(20)),
          //         ),
          //         padding: EdgeInsets.all(10),
          //         child: Text(
          //           "Retry",
          //           style: TextStyle(color: Colors.white, fontSize: 18),
          //         )),
          //   ),
          // ),
        ],
      ),
    );
  }
}
