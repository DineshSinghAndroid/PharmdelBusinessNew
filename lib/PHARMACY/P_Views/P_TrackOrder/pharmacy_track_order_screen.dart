
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';
import '../../../Controller/PharmacyControllers/P_TrackOrderController/pharmacy_track_order_controller.dart';
import '../../../Controller/WidgetController/AdditionalWidget/Other/other_widget.dart';

class TrackOrderScreenPharmacy extends StatefulWidget {
  const TrackOrderScreenPharmacy({Key? key}) : super(key: key);

  @override
  State<TrackOrderScreenPharmacy> createState() => _TrackOrderScreenPharmacyState();
}

class _TrackOrderScreenPharmacyState extends State<TrackOrderScreenPharmacy> {
  PharmacyTrackOrderController pTrkOdrCtrl = Get.put(PharmacyTrackOrderController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PharmacyTrackOrderController>(
      init: pTrkOdrCtrl,
      builder: (controller) {
        return SafeArea(
          child: Scaffold(
            appBar: CustomAppBar.appBar(
                backgroundColor: AppColors.transparentColor,
                onTap: () {
                  Get.back();
                },
                centerTitle: true,
                title: kRoute),
                body: SingleChildScrollView(
                child: Container(
                decoration: const BoxDecoration(image: DecorationImage(image: AssetImage(strImg_PharmacyBg),fit: BoxFit.cover)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                height: Get.height,                
                child: Column(
                  children: [
                    buildSizeBox(20.0, 0.0),
                
                          ///Select Route
                          Flexible(
                          child: WidgetCustom.pharmacyTopSelectWidget(
                          title: controller.selectedroute != null ? controller.selectedroute?.routeName.toString() ?? "" : kSelectRoute,
                          onTap:()async{
                            controller.onTapSelectedRoute(context:context,controller:controller.getNurHomeCtrl);
                          },),
                            ),
                          buildSizeBox(20.0, 0.0),
                
                           ///Select Driver
                           controller.selectedroute != null ?
                           Flexible(
                          child: WidgetCustom.pharmacyTopSelectWidget(
                          title: controller.selectedDriver != null ? controller.selectedDriver?.firstName.toString() ?? "" : kSelectDriver,
                          onTap:()=> controller.onTapSelectedDriver(context:context,controller:controller.getNurHomeCtrl),),
                            ) : const SizedBox.shrink(),
                
                           controller.selectedroute != null ?
                          buildSizeBox(20.0, 0.0) : const SizedBox.shrink(),
                
                    /// Select Date
                    InkWell(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2015, 8), lastDate: DateTime(2101));
                        setState(() {
                          pTrkOdrCtrl.selectedDate = pTrkOdrCtrl.formatter.format(picked!);
                          pTrkOdrCtrl.showDatedDate = pTrkOdrCtrl.formatterShow.format(picked);
                          if (pTrkOdrCtrl.selectedDriverPosition! > 0 && pTrkOdrCtrl.selectedRouteID > 0) {}
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.only(left: 10.0, top: 10, bottom: 10, right: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0), color: AppColors.whiteColor,
                          //border: Border.all(color: Colors.grey[400]),
                        ),
                        child: Row(
                          children: [
                            BuildText.buildText(text: pTrkOdrCtrl.showDatedDate),
                            const Spacer(),
                            const Icon(Icons.calendar_today_sharp),
                          ],
                        ),
                      ),
                    ),
                   ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
