import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';
import 'package:pharmdel/Controller/WidgetController/AppBar/app_bar.dart';
import '../../Controller/ProjectController/NotificationController/notification_controller.dart';
import '../../Controller/WidgetController/ErrorHandling/EmptyDataScreen.dart';
import '../../Controller/WidgetController/Loader/LoadScreen/LoadScreen.dart';
import '../../Controller/WidgetController/NotificationWidget.dart/notificationCardWidget.dart';
import '../../Controller/WidgetController/RefresherIndicator/RefreshIndicatorCustom.dart';
import '../../Controller/WidgetController/StringDefine/StringDefine.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  NotificationController notificationCtrl = Get.put(NotificationController());

  @override
  void initState() {
    init();
    super.initState();
  }
  @override
  void dispose() {
    Get.delete<NotificationController>();
    super.dispose();
  }

  Future<void> init() async {
      await notificationCtrl.notificationApi(context: context,screenIndex: 0).then((value) async {
        await notificationCtrl.notificationApi(context: context,screenIndex: 1);
      });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationController>(
      init: notificationCtrl,
      builder: (controller) {
        return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBarCustom.appBarStyle2(
                title: kMyNotification,size: 18,
                bottom:  TabBar(
                  tabs: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: BuildText.buildText(text: kReceived,size: 16)
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: BuildText.buildText(text: kSent,size: 16)
                    ),
                  ],
                ),
              ),
              body: LoadScreen(
                widget: TabBarView(
                  physics: const ClampingScrollPhysics(),
                  children: [

                    /// Received Notification
                    controller.receivedNotificationData != null && controller.receivedNotificationData!.isNotEmpty ?
                    Scaffold(
                        body: RefreshIndicatorCustom(
                          refreshController: controller.refreshController,
                          onRefresh: ()=> controller.onRefresh(context: context, screenIndex: 0),
                          child: Container(
                            margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 90),
                            child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: controller.receivedNotificationData?.length ?? 0,
                                itemBuilder: (context, i) {
                                  return NotificationCardWidget(
                                    name: controller.receivedNotificationData?[i].name ?? "",
                                    messsage: controller.receivedNotificationData?[i].message ?? "",
                                    time: controller.receivedNotificationData?[i].created ?? "",
                                  );
                                }
                            ),
                          ),
                        )
                    ):
                      controller.isEmpty == true ?
                    EmptyDataScreen(
                      onTap: () {
                        init();
                      },
                      isShowBtn: false,
                      string: kEmptyData,
                    ) : const SizedBox.shrink(),

                    /// Create Notification
                    Scaffold(
                      floatingActionButton: FloatingActionButton(
                        backgroundColor: Colors.orange,
                        child: const Icon(Icons.add,color: Colors.white),
                        onPressed: ()=> controller.onTapCreateNotification(context: context),
                      ),
                      body: SingleChildScrollView(
                        padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 90),
                        child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: controller.sendNotificationData?.length ?? 0,
                            itemBuilder: (context, i) {
                              return NotificationCardWidget(
                                name: controller.sendNotificationData?[i].name ?? "",
                                messsage: controller.sendNotificationData?[i].message ?? "",
                                time: controller.sendNotificationData?[i].created ?? "",
                              );
                            }),
                      ),
                    ),
                  ],
                ),
                isLoading: controller.isLoading,
              ),
            ));
      },
    );
  }
}
