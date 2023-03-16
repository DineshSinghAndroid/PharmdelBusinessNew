import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/Helper/Colors/custom_color.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../Controller/Helper/ConnectionValidator/ConnectionValidator.dart';
import '../../../Controller/PharmacyControllers/P_NotificationController/p_notification_controller.dart';
import '../../../Controller/RouteController/RouteNames.dart';
import '../../../Controller/WidgetController/ErrorHandling/EmptyDataScreen.dart';
import '../../../Controller/WidgetController/ErrorHandling/ErrorDataScreen.dart';
import '../../../Controller/WidgetController/ErrorHandling/NetworkErrorScreen.dart';
import '../../../Controller/WidgetController/Loader/LoadScreen/LoadScreen.dart';
import '../../../Controller/WidgetController/NotificationWidget.dart/notificationCardWidget.dart';
import '../../../Controller/WidgetController/Popup/PopupCustom.dart';
import '../../../Controller/WidgetController/RefresherIndicator/RefreshIndicatorCustom.dart';

class PharmacyNotificationScreen extends StatefulWidget {
  const PharmacyNotificationScreen({super.key});

  @override
  State<PharmacyNotificationScreen> createState() =>
      _PharmacyNotificationScreenState();
}

class _PharmacyNotificationScreenState extends State<PharmacyNotificationScreen> {

  PharmacyNotificationController phrNotfCtrl = Get.put(PharmacyNotificationController());
  RefreshController refreshController = RefreshController();  

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
      await phrNotfCtrl.sentNotificationApi(context: context, pageNo: '1');
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
                init();
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
              RefreshIndicatorCustom(
              refreshController: refreshController,
              onRefresh: (){
                refreshController.refreshCompleted();
                init();
              },
                child: Padding(
                  padding: const EdgeInsets.only(top: 8,),
                  child: ListView.builder(                          
                      shrinkWrap: true,   
                      physics: const AlwaysScrollableScrollPhysics(),                                               
                      itemCount: controller.notificationData?.length ?? 0,
                      itemBuilder: (context, index) {
                        return NotificationCardWidget(
                          name: controller.notificationData?[index].name ?? "",
                          messsage: controller.notificationData?[index].message ?? "",
                          time:controller.notificationData?[index].created ?? "",
                        );
                      }),
                ),
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
                    itemCount: controller.sentNotificationData?.length ?? 0,
                    physics: const AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return NotificationCardWidget(
                        onTap: (){
                          showDialog(
                          barrierDismissible: true,
                          context: context, 
                          builder: (context) {
                            return NotificationInfo(
                              notificationName: controller.sentNotificationData?[index].name ?? "",
                              type: controller.sentNotificationData?[index].type ?? "",
                              userName: controller.sentNotificationData?[index].user ?? "",
                              message: controller.sentNotificationData?[index].message ?? "",
                              dateAdded: controller.sentNotificationData?[index].dateAdded ?? "",
                            );
                          },);
                        },
                        time: controller.sentNotificationData?[index].dateAdded ?? "", 
                        messsage: controller.sentNotificationData?[index].message ?? "", 
                        name: controller.sentNotificationData?[index].name ?? "");
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
