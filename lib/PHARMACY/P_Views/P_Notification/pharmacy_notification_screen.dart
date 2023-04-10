import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/Helper/Colors/custom_color.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';
import '../../../Controller/Helper/ConnectionValidator/ConnectionValidator.dart';
import '../../../Controller/Helper/PrintLog/PrintLog.dart';
import '../../../Controller/PharmacyControllers/P_NotificationController/p_notification_controller.dart';
import '../../../Controller/RouteController/RouteNames.dart';
import '../../../Controller/WidgetController/ErrorHandling/EmptyDataScreen.dart';
import '../../../Controller/WidgetController/ErrorHandling/ErrorDataScreen.dart';
import '../../../Controller/WidgetController/Loader/LoadScreen/LoadScreen.dart';
import '../../../Controller/WidgetController/NotificationWidget.dart/notificationCardWidget.dart';
import '../../../Controller/WidgetController/Popup/PopupCustom.dart';
<<<<<<< HEAD
import 'notification_info.dart';
=======
>>>>>>> 8b081882a3eced9002e51a19f4537178dbc5c90a

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
    phrNotfCtrl.scrollController.addListener(scrollListner);
    Future.delayed(const Duration(milliseconds: 100),(){
      init();
    });
    super.initState();
  }

  Future<void> init() async {
    phrNotfCtrl.pageNo = 1;
    phrNotfCtrl.isNetworkError = false;
    phrNotfCtrl.isEmpty = false;
    if (await ConnectionValidator().check()) {
      await phrNotfCtrl.notificationApi(context: context);
      await phrNotfCtrl.sentNotificationApi(context: context, pageNo: phrNotfCtrl.pageNo);
    } else {      
      phrNotfCtrl.isNetworkError = true;      
    }
    setState(() {});
  }

 void scrollListner() {
    if(phrNotfCtrl.scrollController.position.maxScrollExtent == phrNotfCtrl.scrollController.offset){
      PrintLog.printLog("check: ${phrNotfCtrl.getNextPage}");
      if(phrNotfCtrl.getNextPage){
        phrNotfCtrl.pageNo++;
        phrNotfCtrl.sentNotificationApi(context: context, pageNo: phrNotfCtrl.pageNo);
      }
    }else if(phrNotfCtrl.scrollController.position.minScrollExtent == phrNotfCtrl.scrollController.offset){

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
              size: 18        
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
              onTap: (value) {
                // init();
              },
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
            physics: const AlwaysScrollableScrollPhysics(),                         
            dragStartBehavior: DragStartBehavior.start,
            children: [          
              ///Recieve Notification
              Padding(
                padding: const EdgeInsets.only(top: 8,),
                child: ListView.builder(                          
                    shrinkWrap: true,   
                    physics: const AlwaysScrollableScrollPhysics(),                                               
                    itemCount: controller.notificationData?.length ?? 0,
                    itemBuilder: (context, index) {
<<<<<<< HEAD
                      return P_NotificationCardWidget(
=======
                      return NotificationCardWidget(
>>>>>>> 8b081882a3eced9002e51a19f4537178dbc5c90a
                        name: controller.notificationData?[index].name ?? "",
                        message: controller.notificationData?[index].message ?? "",
                        time:controller.notificationData?[index].created ?? "",
                      );
                    }),
              ), 
          
              ///Sent Notification  
              Scaffold(
                floatingActionButton: Transform.translate(
                  offset: const Offset(-10, -15),
                  child: Tooltip(
                    message: kCreateNotification,
                    child: FloatingActionButton(
                      backgroundColor: AppColors.colorOrange,
                      child: const Icon(Icons.add),
                      onPressed: (){                        
                        Get.toNamed(pharmacyCreateNotificationScreeenRoute);
                      },
                      ),
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: ListView.builder(
                    controller: controller.scrollController,
                    itemCount: controller.sentNotificationList?.length ?? 0,
                    physics: const AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
<<<<<<< HEAD
                      return P_NotificationCardWidget(
=======
                      return NotificationCardWidget(
>>>>>>> 8b081882a3eced9002e51a19f4537178dbc5c90a
                        onTap: (){
                          showDialog(
                          barrierDismissible: true,
                          context: context, 
                          builder: (context) {
                            return NotificationInfo(
                              notificationName: controller.sentNotificationList?[index].name ?? "",
                              type: controller.sentNotificationList?[index].type ?? "",
                              userName: controller.sentNotificationList?[index].user ?? "",
                              message: controller.sentNotificationList?[index].message ?? "",
                              dateAdded: controller.sentNotificationList?[index].dateAdded ?? "",
                            );
                          },);
                        },
                        time: controller.sentNotificationList?[index].dateAdded ?? "",                         
                        message: controller.sentNotificationList?[index].user ?? "",///UserName
                        name: controller.sentNotificationList?[index].name ?? "");
                    },
                  ),
                ),
              )
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
