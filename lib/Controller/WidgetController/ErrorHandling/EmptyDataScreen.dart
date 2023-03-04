
import 'package:flutter/material.dart';

class EmptyDataScreen extends StatefulWidget {
  EmptyDataScreen({Key? key,required this.isShowBtn,required this.string,required this.onTap,this.isShowBackBtn}) : super(key: key);
  final OnTapRefresh? onTap;
  final String? string;
  final bool? isShowBtn;
  bool? isShowBackBtn;
  @override
  State<EmptyDataScreen> createState() => _EmptyDataScreenState();
}

class _EmptyDataScreenState extends State<EmptyDataScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(margin: const EdgeInsets.only(top: 60), height: 250, child: Image.asset("assets/images/img_no_data.png")),
          ),
          const SizedBox(),
        ],
      ),
    )
    );
  }
}
typedef OnTapRefresh = void Function();
