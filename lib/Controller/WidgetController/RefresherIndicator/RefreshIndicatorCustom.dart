
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class RefreshIndicatorCustom extends StatelessWidget{
  RefreshController refreshController;
  Function()? onRefresh;
  Widget child;
  RefreshIndicatorCustom({Key? key,required this.refreshController,required this.onRefresh,required this. child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header:  const WaterDropHeader(
          waterDropColor: Colors.white,
          refresh: SizedBox.shrink(),
          complete: SizedBox.shrink(),
          failed: SizedBox.shrink(),
          idleIcon: SizedBox.shrink(),
        ),
        controller: refreshController,
        onRefresh: onRefresh,
        child:child
    );

  }
}