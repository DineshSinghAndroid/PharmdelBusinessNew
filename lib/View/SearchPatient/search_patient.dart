import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:pharmdel/Controller/WidgetController/Loader/LoadScreen/LoadScreen.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';
import '../../Controller/ProjectController/SearchPatient/search_patient_controller.dart';
import '../../Controller/WidgetController/AdditionalWidget/PatientListWidget/patientListWidget.dart';

class SearchPatientScreen extends StatefulWidget {
  const SearchPatientScreen({super.key});

  @override
  State<SearchPatientScreen> createState() => _SearchPatientScreenState();
}

class _SearchPatientScreenState extends State<SearchPatientScreen> {


  SearchPatientController searchCtrl = Get.put(SearchPatientController());


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
                      itemCount: controller.patientData?.length ?? 0,
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return  PateintListWidget(
                          onTap: ()=> controller.onTapPatient(context: context,index: index),
                          context: context,
                          firstName: controller.patientData?[index].firstName ?? "",
                          middleName: controller.patientData?[index].middleName ?? "",
                          lastName:  controller.patientData?[index].lastName ?? "",
                          address:  controller.patientData?[index].address1 ?? "",
                          dob: controller.patientData?[index].dob ?? "",
                        );
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
