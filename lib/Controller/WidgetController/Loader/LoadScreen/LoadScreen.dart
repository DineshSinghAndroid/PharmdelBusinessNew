
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import '../LoadingWidget.dart';



class LoadScreen extends  StatefulWidget{
  LoadScreen({Key? key,required this.widget, required this.isLoading,this.isLoaderChange}) : super(key: key);
  Widget? widget;
  bool? isLoading;
  bool? isLoaderChange;

  @override
  State<LoadScreen> createState() => _LoadScreenState();
}

class _LoadScreenState extends State<LoadScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: widget.isLoaderChange == true ?
      LoadingOverlay(
          isLoading: widget.isLoading ?? false,
          opacity: 1.0,
          color: Colors.black12,
          progressIndicator:  LoadingWidget2(),
          child: widget.widget!
      )
    : LoadingOverlay(
        isLoading: widget.isLoading ?? false,
        opacity: 1.0,
        color: Colors.black45,
        progressIndicator: LoadingWidget(),
        child: widget.widget!
      ),
    );
  }
}