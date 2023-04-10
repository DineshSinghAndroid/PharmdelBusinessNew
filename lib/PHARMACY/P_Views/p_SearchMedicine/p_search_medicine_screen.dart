import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';
import '../../../Controller/PharmacyControllers/P_MedicineListController/p_medicineListController.dart';
import '../../../Controller/WidgetController/AdditionalWidget/SearchMedicineWidget/searchMedicineCardWidget.dart';

class SearchMedicineScreen extends StatefulWidget {
  const SearchMedicineScreen({super.key});

  @override
  State<SearchMedicineScreen> createState() => _SearchMedicineScreenState();
}

class _SearchMedicineScreenState extends State<SearchMedicineScreen> {

GetMedicineListController medsListCtrl = Get.put(GetMedicineListController());

TextEditingController searchTextCtrl = TextEditingController();

bool? noData = false;
bool? isLoading = false;
bool isSearchShow = false;
 

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
    return GetBuilder<GetMedicineListController>(
      init: medsListCtrl,
      builder: (controller) {
        return GestureDetector(
          onTap: (){
            FocusScope.of(context).requestFocus(FocusNode());
            isSearchShow = false;
          },
          child: SafeArea(
            child: Scaffold(              
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                elevation: 1.5,
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
                    height: 42,
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: TextFormField(                      
                      textAlign: TextAlign.start,
                      controller: searchTextCtrl,
                      decoration: InputDecoration(
                        suffixIcon: Transform.translate(
                          offset: const Offset(10, 0),
                          child: isSearchShow == false ? Icon(Icons.search,color: AppColors.blackColor,size: 28,) : InkWell(
                            onTap: () {
                              setState(() {
                                searchTextCtrl.clear();                                
                              });
                            },
                            child: Icon(Icons.clear,color: AppColors.blackColor,size: 28,))),
                          focusColor: AppColors.whiteColor,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          filled: true,
                          fillColor: Colors.transparent,
                          border: InputBorder.none,
                          hintStyle: const TextStyle(color: Colors.black38),
<<<<<<< HEAD
                          hintText: kSearchMedicine),
=======
                          hintText: kSearchMeds),
>>>>>>> 8b081882a3eced9002e51a19f4537178dbc5c90a
                          onChanged: (value) async {
                              if(value.toString().trim().isNotEmpty && value.length > 1){                                
                                await controller.medicineListApi(context: context, searchValue: value.toString().trim());                                
                              }else{
                                setState(() {
                                  controller.medicineData?.medicineListData?.clear();
                                  isSearchShow = true;
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
<<<<<<< HEAD
=======

>>>>>>> 8b081882a3eced9002e51a19f4537178dbc5c90a
                ///Medicine List
                controller.medicineData?.medicineListData != null && controller.medicineData!.medicineListData!.isNotEmpty && searchTextCtrl.text.toString().trim().length > 2 ?
                ListView.builder(
                      itemCount: controller.medicineData?.medicineListData?.length ?? 0,
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return SearchMedicineCardWidget(
                          medicineName: controller.medicineData?.medicineListData?[index].name ?? "",
                          vtmName: controller.medicineData?.medicineListData?[index].vtmName ?? "",
                          packSize: controller.medicineData?.medicineListData?[index].packSize ?? "",
                          isCDShow: controller.medicineData?.medicineListData?[index].drugInfo != null && controller.medicineData!.medicineListData![index].drugInfo!.isNotEmpty,
                          onTapSelect: (){
                            Navigator.of(context).pop(controller.medicineData?.medicineListData?[index]);
                          },
                        );
                      }
                       ) : SizedBox(height: Get.height - 400,
                        child: Center(child: BuildText.buildText(text: 'No Medicine Available',size: 18,color: AppColors.greyColor)),
                       )
              ]))),
          ),
        );
      },
    );
  }
}
