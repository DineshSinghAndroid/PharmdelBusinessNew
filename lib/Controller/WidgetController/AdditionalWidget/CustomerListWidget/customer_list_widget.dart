import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import '../../../../View/ScanPrescription/scan_prescription.dart';
import '../../StringDefine/StringDefine.dart';


class CustomerListWidget extends StatelessWidget {
  
  String? customerName;
  String? userId;
  String? dob;
  String? nhsNumber;
  String? address;
  int? position = 0;
  CustomerSelectedListner? selectedListner;

  CustomerListWidget({Key? key,required this.address, required this.customerName, required this.dob, required this.nhsNumber, required this.position, this.selectedListner, required this.userId }) : super(key: key);

  @override
  Widget build(BuildContext context) { 
    return Card(
      color: Colors.primaries[Random().nextInt(Colors.primaries.length)].shade100,
      // color: CustomColors.lightPinkColor,
      margin: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8, left: 3, right: 8, bottom: 8),
            padding: const EdgeInsets.only(bottom: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 10.0),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BuildText.buildText(
                            text: customerName!,
                            style: TextStyleblueGrey14,
                          ),
                          buildSizeBox(4.0, 0.0),
                          const Divider(height: 1,color: Colors.grey,),
                          buildSizeBox(10.0, 0.0),
                          BuildText.buildText(
                            text: userId!,
                            style: TextStyleblueGrey14,
                          ),
                          buildSizeBox(4.0, 0.0),
                          BuildText.buildText(
                            text: dob!,
                            style: TextStyleblueGrey14,
                          ),
                          buildSizeBox(3.0, 0.0),
                          BuildText.buildText(
                            text: nhsNumber!,
                            style: TextStyleblueGrey14,
                          ),
                          buildSizeBox(3.0, 0.0),
                          BuildText.buildText(
                            text: address!,
                            style: TextStyleblueGrey14,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: MaterialButton(
                                onPressed: () {                                  
                                  // selectedListner.isSelected(dataList.patientsList.userId[position], position, dataList.patientsList.alt_address[position]);
                                },
                                color: AppColors.blueColor,
                                child: BuildText.buildText(
                                  text: kSelCustomer,
                                  style: TextStyle6White,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
