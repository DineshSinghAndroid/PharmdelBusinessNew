
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import '../LoadingWidget.dart';



class LoadScreen extends  StatefulWidget{
  LoadScreen({Key? key,required this.widget, required this.isLoading}) : super(key: key);
  Widget? widget;
  bool? isLoading;

  @override
  State<LoadScreen> createState() => _LoadScreenState();
}

class _LoadScreenState extends State<LoadScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: LoadingOverlay(
          isLoading: widget.isLoading!,
          opacity: 1.0,
          color: Colors.black45,
          progressIndicator: LoadingWidget(),
          child: widget.widget!
      ),
    );
  }
}