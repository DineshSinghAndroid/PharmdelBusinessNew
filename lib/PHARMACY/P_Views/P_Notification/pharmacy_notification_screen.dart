import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/Helper/Colors/custom_color.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';

import '../../../Controller/Helper/ConnectionValidator/ConnectionValidator.dart';
import '../../../Controller/PharmacyControllers/P_NotificationController/p_notification_controller.dart';
import '../../../Controller/WidgetController/ErrorHandling/EmptyDataScreen.dart';
import '../../../Controller/WidgetController/ErrorHandling/ErrorDataScreen.dart';
import '../../../Controller/WidgetController/ErrorHandling/NetworkErrorScreen.dart';
import '../../../Controller/WidgetController/Loader/LoadScreen/LoadScreen.dart';
import '../../../Controller/WidgetController/NotificationWidget.dart/notificationCardWidget.dart';

class PharmacyNotificationScreen extends StatefulWidget {
  const PharmacyNotificationScreen({super.key});

  @override
  State<PharmacyNotificationScreen> createState() =>
      _PharmacyNotificationScreenState();
}

class _PharmacyNotificationScreenState extends State<PharmacyNotificationScreen> {

  PharmacyNotificationController phrNotfCtrl = Get.put(PharmacyNotificationController());

  @override
  void initState() {    
    init();
    super.initState();
  }

  Future<void> init() async {
    phrNotfCtrl.isNetworkError = false;
    phrNotfCtrl.isEmpty = false;
    if (await ConnectionValidator().check()) {
      await phrNotfCtrl.notificationApi(context: context);
    } else {
      phrNotfCtrl.isNetworkError = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PharmacyNotificationController>(
      init: phrNotfCtrl,
      builder: (controller) {
        return  LoadScreen(
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
            string: kEmptyData,)
           : controller.notificationData != null && controller.isEmpty == false ?
           DefaultTabController(
              animationDuration: const Duration(milliseconds: 500),
              length: 2,
              child: Scaffold(
          appBar: AppBar(
            title: BuildText.buildText(
              text: kMyNotifiaction,
              color: AppColors.blackColor,  
              size: 16        
            ),
            centerTitle: true,
            backgroundColor: AppColors.whiteColor,        
            leading: InkWell(
              onTap: () {
                Get.back();
              },
              child: Icon(
                Icons.arrow_back,
                color: AppColors.blackColor,
              ),
            ),
            bottom: TabBar(
              indicatorColor: AppColors.colorOrange,
              tabs: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: BuildText.buildText(
                    text: kReceived,
                    size: 16,
                    color: AppColors.blackColor,                
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: BuildText.buildText(
                    text: kSent,
                    size: 16,
                    color: AppColors.blackColor,                
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(                    
            physics: const NeverScrollableScrollPhysics(),
            children: [
              SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                        margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 90),
                        child: ListView.builder(                          
                            shrinkWrap: true,
                            itemCount: controller.notificationData?.length ?? 0,
                            itemBuilder: (context, i) {
                              return NotificationCardWidget(
                                name: controller.notificationData?[i].name ?? "",
                                messsage: controller.notificationData?[i].message ?? "",
                                time:controller.notificationData?[i].created ?? "",
                              );
                            }),
                      ),
              ),   
              Container()         
            ],
          ),
              ),
            ) : const SizedBox.shrink(),
            isLoading: controller.isLoading,
        );
      },
    );
  }
}
