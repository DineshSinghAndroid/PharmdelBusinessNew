import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/Helper/Colors/custom_color.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';
import 'package:pharmdel/Controller/WidgetController/AppBar/app_bar.dart';
import 'package:pharmdel/Controller/WidgetController/Loader/LoadScreen/LoadScreen.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';
import '../../Controller/ProjectController/VechicleInspectionReportController/vir_controller.dart';
import 'click_vir_images.dart';

class VechicleInspectionReportScreen extends StatefulWidget {
  VechicleInspectionReportScreen({super.key});

  @override
  State<VechicleInspectionReportScreen> createState() => _VechicleInspectionReportScreenState();
}

<<<<<<< HEAD
class _VechicleInspectionReportScreenState extends State<VechicleInspectionReportScreen> {
  VirController virCtrl = Get.put(VirController());
=======
TextEditingController remarkController = TextEditingController();

class _MyCustomWidgetState extends State<VechileInspectionReportScreen> {
  final VirHomeScreenController _virCtrl = Get.put(VirHomeScreenController());
>>>>>>> 1d5859b538144cf52161ec87240ef171c1138d10

  @override
  void initState() {
    initData();
    super.initState();
    _virCtrl.vechicleId = widget.vehicleId;
    print("widget vehicle id is :::>> ${widget.vehicleId}");
  }
  @override
  void dispose() {
    Get.delete<VirController>();
    super.dispose();
  }

  Future<void> initData()async{
    await virCtrl.fetchUpdatedData(context: context);
  }

  @override
  Widget build(BuildContext context) {

    return GetBuilder<VirController>(
      init: virCtrl,
      builder: (controller) {
        return LoadScreen(
          widget: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              backgroundColor: AppColors.blackColor,
              appBar: AppBarCustom.appBarStyle2(
                title: kVehicleInspectionReport,
                  titleColor: AppColors.whiteColor,
                  size: 18,
                  backgroundColor: AppColors.blueColor,
                centerTitle: true
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.only(left: 20.0,right: 20.0,top: 50.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      /// Title
                      BuildText.buildText(
                          text: kPickAService,
                        size: 32,color: AppColors.whiteColor,weight: FontWeight.bold
                      ),
                      buildSizeBox(30.0, 0.0),

                      /// Btn list
                      ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.all(Get.width / 30),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.servicePageList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return ClickInspectionImagesScreen(
                                    index: index
                                  );
                                },
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              margin: EdgeInsets.only(bottom: Get.width / 20),
                              height: Get.width / 6,
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.4),
                                borderRadius: const BorderRadius.all(Radius.circular(20)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 40,
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                      controller.servicePageList[index].icon,
                                    size: 32,
                                    color: AppColors.whiteColor
                                  ),
                                  BuildText.buildText(
                                      text: controller.servicePageList[index].title,
                                      size: 22,color: AppColors.whiteColor,weight: FontWeight.w500
                                  ),
                                  Icon(
                                      controller.servicePageList[index].isCompleted == true ?
                                      Icons.check_box : Icons.arrow_forward_ios_outlined,
                                    color: AppColors.whiteColor
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      /// Submit
                      MaterialButton(
                        onPressed: ()=> controller.fetchUpdatedData(context: context),
                        color: AppColors.whiteColor,
                        child: BuildText.buildText(text: kSubmit)
                      ),
                    ],
                  ),
                ),
              ),
          ),
          ),
          isLoading: controller.isLoading,
        );
      },
    );
  }
}
