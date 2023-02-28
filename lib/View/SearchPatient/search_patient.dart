import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';
import '../../Controller/ProjectController/GetPatientController/getPatientController.dart';
import '../../Controller/WidgetController/AdditionalWidget/PatientListWidget/patientListWidget.dart';

class SearchPatientScreen extends StatefulWidget {
  const SearchPatientScreen({super.key});

  @override
  State<SearchPatientScreen> createState() => _SearchPatientScreenState();
}

class _SearchPatientScreenState extends State<SearchPatientScreen> {


GetPatientContoller patCtrl = Get.put(GetPatientContoller());
TextEditingController searchTextCtrl = TextEditingController();

bool? noData = false;
bool? isLoading = false;

@override
 void initState() {
    super.initState();
  }

  @override
  void dispose() {
    searchTextCtrl.dispose();
    super.dispose();
  }

@override
Widget build(BuildContext context,) {
    return SafeArea(
      child: GetBuilder<GetPatientContoller>(
        init: patCtrl,
        builder: (controller) {
          return GestureDetector(
            onTap: (){
              FocusScope.of(context).requestFocus(FocusNode());
            },
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
                  color: Colors.transparent,
                  child: Container(
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: TextFormField(
                      textAlign: TextAlign.start,
                      controller: searchTextCtrl,
                      decoration: const InputDecoration(
                          focusColor: Colors.white,
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          filled: true,
                          fillColor: Colors.transparent,
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.black38),
                          hintText: kSearchPat),
                          onChanged: (value) async {
                              if(value.toString().trim().isNotEmpty && value.length > 3){
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
                controller.patientData != null && controller.patientData!.isNotEmpty && searchTextCtrl.text.toString().trim().length > 2 ?
                ListView.builder(                  
                      itemCount: controller.patientData?.length ?? 0,
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return  PateintListWidget( 
                        onTap: (){},                                           
                        context: context,
                        firstName: controller.patientData?[index].firstName ?? "",
                        middleName: controller.patientData?[index].middleName ?? "",
                        lastName:  controller.patientData?[index].lastName ?? "",
                        address:  controller.patientData?[index].address1 ?? "",
                        dob: controller.patientData?[index].dob ?? "",
                      );  
                      }
                       ) : const SizedBox.shrink()
              ]))),
          );
        },
      ),
    );
  }
}
