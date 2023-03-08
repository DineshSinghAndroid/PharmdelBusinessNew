import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/Helper/Colors/custom_color.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';
import '../../../Controller/Helper/ConnectionValidator/ConnectionValidator.dart';
import '../../../Controller/PharmacyControllers/P_NotificationController/p_notification_controller.dart';
import '../../../Controller/RouteController/RouteNames.dart';
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
      await phrNotfCtrl.createNotificationApi(context: context);
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

              ///Recieve Notification
              SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                        margin: const EdgeInsets.all(8),
                        child: ListView.builder(                          
                            shrinkWrap: true,
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
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: controller.createNotificationData?.staffManagerInfo?.length ?? 0,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return NotificationCardWidget(
                        time: '12:00', 
                        messsage: controller.createNotificationData?.staffManagerInfo?[index].role ?? "", 
                        name: controller.createNotificationData?.staffManagerInfo?[index].name ?? "");
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
