import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../Controller/Helper/ConnectionValidator/ConnectionValidator.dart';
import '../../Controller/ProjectController/NotificationController/notificationController.dart';
import '../../Controller/RouteController/RouteNames.dart';
import '../../Controller/WidgetController/ErrorHandling/EmptyDataScreen.dart';
import '../../Controller/WidgetController/ErrorHandling/ErrorDataScreen.dart';
import '../../Controller/WidgetController/ErrorHandling/NetworkErrorScreen.dart';
import '../../Controller/WidgetController/Loader/LoadScreen/LoadScreen.dart';
import '../../Controller/WidgetController/NotificationWidget.dart/notificationCardWidget.dart';
import '../../Controller/WidgetController/RefresherIndicator/RefreshIndicatorCustom.dart';
import '../../Controller/WidgetController/StringDefine/StringDefine.dart';
import 'createNotificationDriver.dart';

class NotificatinScreen extends StatefulWidget {
  String customerId;
  int screen1or2;

  NotificatinScreen({super.key, required this.screen1or2, required this.customerId});

  @override
  State<NotificatinScreen> createState() => _NotificatinScreenState();
}

class _NotificatinScreenState extends State<NotificatinScreen> {
  NotificationController notfCtrl = Get.put(NotificationController());
  RefreshController refreshController = RefreshController();

  @override
  void initState() {
    notfCtrl.screen1or2 = widget.screen1or2;
     init();
    super.initState();
  }

  Future<void> init() async {
    notfCtrl.isNetworkError = false;
    notfCtrl.isEmpty = false;
    if (await ConnectionValidator().check()) {
      await notfCtrl.notificationApi(context: context);
    } else {
      notfCtrl.isNetworkError = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationController>(
      init: notfCtrl,
      builder: (controller) {
        return DefaultTabController(

            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title:Text(
                  kMyNotification,
                  style: TextStyle(color: Colors.black),
                ),

                centerTitle: true,
                backgroundColor: Colors.white,
                // backgroundColor: CustomColors.darkPinkColor,
                // automaticallyImplyLeading: true,
                leading: InkWell(
                  onTap: () {
                    if (mounted) Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                bottom: TabBar(
                  onTap: (value) {
                    notfCtrl.screen1or2 = value;
                    print(value);
                    setState(() {});
                    init();
                  },
                  tabs: const[
                     Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        kReceived,
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                      ),
                    ),
                      Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Text(
                       kSend,
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                physics: const NeverScrollableScrollPhysics(),

                children: [
                  LoadScreen(
                    widget: controller.isError
                        ? ErrorScreen(
                            onTap: () {
                              init();
                            },
                          )
                        : controller.isNetworkError
                            ? NoInternetConnectionScreen(
                                onTap: () {
                                  init();
                                },
                              )
                            : controller.isEmpty
                                ? EmptyDataScreen(
                                    onTap: () {
                                      init();
                                    },
                                    isShowBtn: false,
                                    string: kEmptyData,
                                  )
                                : controller.notificationData != null && controller.isEmpty == false
                                    ? Scaffold(
                                        body: controller.notificationData!.isNotEmpty
                                            ? RefreshIndicatorCustom(
                                                refreshController: refreshController,
                                                onRefresh: () {
                                                  refreshController.refreshCompleted();
                                                  init();
                                                },
                                                child: Container(
                                                  margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 90),
                                                  child: ListView.builder(
                                                      physics: const NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount: controller.notificationData?.length,
                                                      itemBuilder: (context, i) {
                                                        return NotificationCardWidget(
                                                          name: controller.notificationData?[i].name ?? "",
                                                          messsage: controller.notificationData?[i].message ?? "",
                                                          time: controller.notificationData?[i].created ?? "",
                                                        );
                                                      }),
                                                ),
                                              )
                                            : EmptyDataScreen(
                                                onTap: () {
                                                  init();
                                                },
                                                isShowBtn: false,
                                                string: kEmptyData,
                                              ),
                                      )
                                    : const SizedBox.shrink(),
                    isLoading: controller.isLoading,
                  ),
                  Scaffold(
                    floatingActionButton: FloatingActionButton(
                      backgroundColor: Colors.orange,
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Get.toNamed(createNotificationDriver,arguments: CreateNotificationDriver(
                            customerId: widget.customerId,
                        ),);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateNotificationDriver(
                                      customerId: '',
                                    )));
                      },
                    ),
                    body: SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 90),
                        child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: controller.notificationData?.length,
                            itemBuilder: (context, i) {
                              return NotificationCardWidget(
                                name: controller.notificationData?[i].name ?? "",
                                messsage: controller.notificationData?[i].message ?? "",
                                time: controller.notificationData?[i].created ?? "",
                              );
                            }),
                      ),
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }
}
