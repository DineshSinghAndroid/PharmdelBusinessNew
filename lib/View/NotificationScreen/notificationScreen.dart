import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/Helper/Colors/custom_color.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../Controller/Helper/ConnectionValidator/ConnectionValidator.dart';
import '../../Controller/Helper/StringDefine/StringDefine.dart';
import '../../Controller/ProjectController/NotificationController/notificationController.dart';
import '../../Controller/WidgetController/ErrorHandling/EmptyDataScreen.dart';
import '../../Controller/WidgetController/ErrorHandling/ErrorDataScreen.dart';
import '../../Controller/WidgetController/ErrorHandling/NetworkErrorScreen.dart';
import '../../Controller/WidgetController/Loader/LoadScreen/LoadScreen.dart';
import '../../Controller/WidgetController/NotificationWidget.dart/notificationCardWidget.dart';
import '../../Controller/WidgetController/RefresherIndicator/RefreshIndicatorCustom.dart';
import '../../Controller/WidgetController/StringDefine/StringDefine.dart';

class NotificatinScreen extends StatefulWidget {
  const NotificatinScreen({super.key});

  @override
  State<NotificatinScreen> createState() => _NotificatinScreenState();
}

class _NotificatinScreenState extends State<NotificatinScreen> {
  NotificationController notfCtrl = Get.put(NotificationController());
  RefreshController refreshController = RefreshController();

  @override
  void initState() {
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
        return LoadScreen(
          widget: controller.isError ?
            ErrorScreen(
            onTap: () {
              init();
            },
          ) : controller.isNetworkError ?
            NoInternetConnectionScreen(
            onTap: () {
              init();
            },
          ) : controller.isEmpty ?
            EmptyDataScreen(
            onTap: () {
              init();
            },
            isShowBtn: false,
            string: kEmptyData,
          ) : controller.notificationData != null && controller.isEmpty == false ?
          Scaffold(
            appBar: AppBar(
              title: BuildText.buildText(text: kMyNotifiaction, size: 18),
              centerTitle: true,
              backgroundColor: AppColors.whiteColor,
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
            ),
            body: controller.notificationData!.isNotEmpty ?
             RefreshIndicatorCustom(
                refreshController: refreshController,
              onRefresh: (){
                refreshController.refreshCompleted();
                init();
              },
               child: Container(
                margin:
                    const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 90),
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
             ) : EmptyDataScreen(
              onTap: () {
                init();
              },
              isShowBtn: false,
              string: kEmptyData,
            ),
          ) : 
          const SizedBox.shrink(),
          isLoading: controller.isLoading,
        );
      },
    );
  }
}
