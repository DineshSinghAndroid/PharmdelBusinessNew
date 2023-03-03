import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/Helper/Colors/custom_color.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';

import '../../../Controller/WidgetController/NotificationWidget.dart/notificationCardWidget.dart';

class PharmacyNotificationScreen extends StatefulWidget {
  const PharmacyNotificationScreen({super.key});

  @override
  State<PharmacyNotificationScreen> createState() =>
      _PharmacyNotificationScreenState();
}

class _PharmacyNotificationScreenState
    extends State<PharmacyNotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
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
                          itemCount: 3,
                          itemBuilder: (context, i) {
                            return NotificationCardWidget(
                              name: "Name",
                              messsage: "Notification Message",
                              time: "02:15",
                            );
                          }),
                    ),
            ),   
            Container()         
          ],
        ),
      ),
    );
  }
}
