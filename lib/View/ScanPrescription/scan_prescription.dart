import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import '../../Controller/WidgetController/AdditionalWidget/CustomerListWidget/customer_list_widget.dart';
import '../../Controller/WidgetController/StringDefine/StringDefine.dart';

class ScanPrescriptionScreen extends StatefulWidget {
  const ScanPrescriptionScreen({super.key});

  @override
  State<ScanPrescriptionScreen> createState() => _ScanPrescriptionScreenState();
}

class _ScanPrescriptionScreenState extends State<ScanPrescriptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.materialAppThemeColor,
        centerTitle: true,
        title: BuildText.buildText(
          text: kCstmList,
          color: AppColors.blackColor,
          size: 18
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: AppColors.blackColor,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: 
            // orderInfo != null && orderInfo.patientsList != null && orderInfo.patientsList.userId != null && orderInfo.patientsList.userId.length > 0 && orderInfo.patientsList.userId[0].toString().isNotEmpty ? 
                Container(
                    margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 90),
                    child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 5,
                        // orderInfo != null ? orderInfo.patientsList.userId.length : 0,
                        itemBuilder: (context, index) {
                          return CustomerListWidget(
                            address: "address", 
                            customerName: "customerName", 
                            dob: "dob", 
                            nhsNumber: "nhsNumber", 
                            position: 0, 
                            // selectedListner: index, 
                            userId: "userId",
                            );
                        }),
                  )
                // : const SizedBox(),
          ),
           Align(
            alignment: Alignment.bottomCenter,
            child: MaterialButton(
                onPressed: (){
                  Get.toNamed(searchPatientScreenRoute);
                },
                color: AppColors.colorOrange,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    BuildText.buildText(
                      text: kAddNewCustomer,
                      color: AppColors.whiteColor,                      
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }  
}

abstract class CustomerSelectedListner {
  void isSelected(dynamic userid, dynamic position, dynamic altAddress);
}