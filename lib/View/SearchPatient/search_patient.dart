import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:pharmdel/Controller/WidgetController/Loader/LoadScreen/LoadScreen.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';
<<<<<<< HEAD
import '../../Controller/ProjectController/SearchPatient/search_patient_controller.dart';
=======
import '../../Controller/PharmacyControllers/P_NursingHomeController/p_nursinghome_controller.dart';
import '../../Controller/ProjectController/GetPatientController/getPatientController.dart';
>>>>>>> 8b081882a3eced9002e51a19f4537178dbc5c90a
import '../../Controller/WidgetController/AdditionalWidget/PatientListWidget/patientListWidget.dart';

class SearchPatientScreen extends StatefulWidget {
  bool? isBulkScan;
  bool? isRouteStart;
  String? driverId;
  String? driverType;
  String? routeId;
  String? bulkScanDate;
  String? nursingHomeId;
  String? parcelBoxId;
  String? toteId;
  // callGetOrderApi callApi;
  // BulkScanMode callPickedApi;
  SearchPatientScreen({
  this.bulkScanDate,
  this.driverId,
  this.driverType,
  this.isBulkScan,
  this.isRouteStart,
  this.nursingHomeId,
  this.parcelBoxId,
  this.routeId,
  this.toteId
  });

  @override
  State<SearchPatientScreen> createState() => _SearchPatientScreenState();
}

class _SearchPatientScreenState extends State<SearchPatientScreen> {


<<<<<<< HEAD
  SearchPatientController searchCtrl = Get.put(SearchPatientController());

=======
GetPatientContoller patCtrl = Get.put(GetPatientContoller());
NursingHomeController nurHmCtrl = Get.put(NursingHomeController());
TextEditingController searchTextCtrl = TextEditingController();

bool? noData = false;
bool? isLoading = false;
 
>>>>>>> 8b081882a3eced9002e51a19f4537178dbc5c90a

@override
 void initState() {
    super.initState();        
  }

  @override
  void dispose() {
    Get.delete<SearchPatientController>();
    super.dispose();
  }

@override
Widget build(BuildContext context,) {
    return GetBuilder<SearchPatientController>(
      init: searchCtrl,
      builder: (controller) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SafeArea(
<<<<<<< HEAD
            child: LoadScreen(
              widget: Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: AppBar(
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
                  flexibleSpace: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(left: 30),
                    color: Colors.transparent,
                    child: Container(
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: TextFormField(
                        textAlign: TextAlign.start,
                        controller: controller.searchTextCtrl,
                        decoration: const InputDecoration(
                            focusColor: Colors.white,
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            filled: true,
                            fillColor: Colors.transparent,
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.black38),
                            hintText: kSearchPat),
                            onChanged: (value) => controller.onTypingText(value: value.trim(),context: context),

                      ),
                    ),
                  ),
                ),
                body: Container(
                  height: Get.height,width: Get.width,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(strImgHomeBg),
                          fit: BoxFit.cover,
                          alignment: Alignment.bottomCenter
                      )
                  ),
                  child: controller.patientData != null && controller.patientData!.isNotEmpty && controller.searchTextCtrl.text.toString().trim().length > 2 ?
                  ListView.builder(
=======
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
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
                flexibleSpace: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(left: 30),
                  color: AppColors.whiteColor,
                  child: Container(
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: TextFormField(
                      textAlign: TextAlign.start,
                      controller: searchTextCtrl,
                      decoration: InputDecoration(
                          focusColor: AppColors.whiteColor,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          filled: true,
                          fillColor: AppColors.transparentColor,
                          border: InputBorder.none,
                          hintStyle: const TextStyle(color: Colors.black38),
                          hintText: kSearchPat),
                          onChanged: (value) async {
                              if(value.toString().trim().isNotEmpty && value.length > 1){
                                await controller.getPatientApi(context: context, firstName: value.toString().trim());
                              }else{
                                setState(() {
                                  controller.patientData?.clear();
                                });
                              }
                          },
                    ),
                  ),
                ),
              ),
              body: SafeArea(
                  child: Stack(children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset(
                      strIMG_HomeBg,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),

                ///Patient List
                controller.patientData != null && controller.patientData!.isNotEmpty && searchTextCtrl.text.toString().trim().length > 2 ?
                ListView.builder(
>>>>>>> 8b081882a3eced9002e51a19f4537178dbc5c90a
                      itemCount: controller.patientData?.length ?? 0,
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return  PateintListWidget(
<<<<<<< HEAD
                          onTap: ()=> controller.onTapPatient(context: context,index: index),
                          context: context,
                          firstName: controller.patientData?[index].firstName ?? "",
                          middleName: controller.patientData?[index].middleName ?? "",
                          lastName:  controller.patientData?[index].lastName ?? "",
                          address:  controller.patientData?[index].address1 ?? "",
                          dob: controller.patientData?[index].dob ?? "",
                        );
=======
                        context: context,
                        firstName: controller.patientData?[index].firstName ?? "",
                        middleName: controller.patientData?[index].middleName ?? "",
                        lastName:  controller.patientData?[index].lastName ?? "",
                        address:  controller.patientData?[index].address1 ?? "",
                        dob: controller.patientData?[index].dob ?? "",
                        onTap: (){
                          if(widget.isBulkScan == false){
                            controller.onTileClicked(index: index, context: context).then((value) {
                            if(controller.isSuccess == true){
                              Get.toNamed(deliveryScheduleManualScreenRoute);
                            }
                          });
                          } else{
                            Navigator.of(context).pop(controller.patientData?[index]);
                          }
                        },
                      );
>>>>>>> 8b081882a3eced9002e51a19f4537178dbc5c90a
                      }
                  ) :
                  controller.searchTextCtrl.text.toString().trim().length > 3 && controller.patientData == null || controller.searchTextCtrl.text.toString().trim().length > 3 && controller.patientData!.isEmpty?
                  SizedBox(
                    height: 200,
                    child: Center(
                      child: BuildText.buildText(text: kNoPatAvl,size: 24,color: AppColors.blackColor.withOpacity(0.4))
                    ),
                  ):const SizedBox.shrink(),
                )
              ),
              isLoading: controller.isLoading,
            ),
          ),
        );
      },
    );
  }
}
