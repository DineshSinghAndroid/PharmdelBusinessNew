import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';
import '../../Controller/ProjectController/SearchMedicineController/search_medicine_controller.dart';
import '../../Model/SearchMedicine/search_medicine_response.dart';

class SearchMedicineScreen extends StatefulWidget {
  const SearchMedicineScreen({super.key});

  @override
  State<SearchMedicineScreen> createState() => _SearchMedicineScreenState();
}

class _SearchMedicineScreenState extends State<SearchMedicineScreen> {

  SearchMedicineController searchCtrl = Get.put(SearchMedicineController());


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<SearchMedicineController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context,) {
    return GetBuilder<SearchMedicineController>(
      init: searchCtrl,
      builder: (controller) {
        return GestureDetector(
          onTap: ()=>FocusScope.of(context).requestFocus(FocusNode()),
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
                        controller: controller.searchTextCtrl,
                        decoration: InputDecoration(
                            suffixIcon: Transform.translate(
                                offset: const Offset(10, 0),
                                child: controller.searchTextCtrl.text.isEmpty ?
                                Icon(Icons.search,color: AppColors.blackColor,size: 28,) :
                                InkWell(
                                    onTap: () => controller.onTapClear(),
                                    child: Icon(Icons.clear,color: AppColors.blackColor,size: 28,)
                                )
                            ),
                            focusColor: AppColors.whiteColor,
                            contentPadding:
                            const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            filled: true,
                            fillColor: Colors.transparent,
                            border: InputBorder.none,
                            hintStyle: const TextStyle(color: Colors.black38),
                            hintText: kSearchMedicine),
                        onChanged: (value) => controller.onTypingText(value: value, context: context),
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

                      ///Medicine List
                      controller.medicineData?.medicineListData != null && controller.medicineData!.medicineListData!.isNotEmpty && controller.searchTextCtrl.text.toString().trim().length > 2 ?
                      ListView.builder(
                          itemCount: controller.medicineData?.medicineListData?.length ?? 0,
                          physics: const ClampingScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            return DefaultWidget.searchMedicineWidget(
                              medicineName: controller.medicineData?.medicineListData?[index].name ?? "",
                              vtmName: controller.medicineData?.medicineListData?[index].vtmName ?? "",
                              packSize: controller.medicineData?.medicineListData?[index].packSize ?? "",
                              isCDShow: controller.medicineData?.medicineListData?[index].drugInfo != null && controller.medicineData!.medicineListData![index].drugInfo!.isNotEmpty && controller.medicineData?.medicineListData?[index].drugInfo.toString() != "0",
                              onTap:(){
                                FocusScope.of(context).unfocus();
                                SearchMedicineListData? data = controller.medicineData?.medicineListData?[index];
                                data?.days = "";
                                data?.quantity = "";
                                Navigator.of(context).pop(data);
                              },
                            );
                          }
                      )
                          : SizedBox(
                            height: Get.height - 400,
                            child: Center(
                                child: BuildText.buildText(text: 'No Medicine Available',size: 18,color: AppColors.greyColor)
                            ),
                          )
                    ]))),
          ),
        );
      },
    );
  }
}
