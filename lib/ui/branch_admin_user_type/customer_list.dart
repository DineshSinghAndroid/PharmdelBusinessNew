// @dart=2.9
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmdel_business/model/ProcessScanResponse.dart';
import 'package:pharmdel_business/ui/branch_admin_user_type/scan_prescription.dart';
import 'package:pharmdel_business/util/text_style.dart';

class CustomerListWidgetNew extends StatelessWidget {
  OrderInfoResponse dataList;
  int position = 0;

  CustomerSelectedListner selectedListner;

  CustomerListWidgetNew(this.dataList, this.position, this.selectedListner) : super();

  @override
  Widget build(BuildContext context) {
    // return Text("hi");
    // initializeDateFormatting('IST');
    return Card(
      color: Colors.primaries[Random().nextInt(Colors.primaries.length)].shade100,
      // color: CustomColors.lightPinkColor,
      margin: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 8, left: 3, right: 8, bottom: 8),
            padding: EdgeInsets.only(bottom: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 10.0),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${dataList.patientsList.customerName[position] ?? "N/A"}" ?? "",
                            style: TextStyleblueGrey14,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Divider(
                            height: 1,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "UserID : ${dataList.patientsList.userId[position] ?? "N/A"}" ?? "",
                            style: TextStyleblueGrey14,
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            "DOB : ${dataList.patientsList.dob[position] ?? "N/A"}" ?? "",
                            style: TextStyleblueGrey14,
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            "NHS No : ${dataList.patientsList.nhsNumber[position] ?? "N/A"}" ?? "",
                            style: TextStyleblueGrey14,
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            "Address : ${dataList.patientsList.address != null ? dataList.patientsList.address[position] ?? "N/A" : "N/A"}" ?? "",
                            style: TextStyleblueGrey14,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: MaterialButton(
                                onPressed: () {
                                  // print(dataList.patientsList.userId[position]);
                                  selectedListner.isSelected(dataList.patientsList.userId[position], position, dataList.patientsList.alt_address[position]);
                                },
                                color: Colors.blue,
                                child: Text(
                                  "Select Customer", //"Add Customer",
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
