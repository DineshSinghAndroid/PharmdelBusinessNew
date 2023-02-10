import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmdel_business/model/ProcessScanResponse.dart';

import '../../util/text_style.dart';

class CustomerListWidget extends StatelessWidget {
  OrderInfoResponse dataList;
  int position = 0;

  CustomerListWidget(this.dataList, this.position) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dataList.patientsList.customerName != null ? dataList.patientsList.customerName[position] ?? "N/A" : "N/A",
            style: TextStyleblueGrey14, //e98559
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "User ID",
                      style: TextStyleblueGrey14,
                    ),
                    Text("${dataList.patientsList.userId[position] != null ? dataList.patientsList.userId[position] : "N/A"}")
                  ],
                ),
              ),
              Spacer(),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "NHS No",
                      style: TextStyleblueGrey14,
                    ),
                    Text("${dataList.patientsList.nhsNumber != null ? dataList.patientsList.nhsNumber[position] : "N/A"}")
                  ],
                ),
              ),
              Spacer(),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "DOB",
                      style: TextStyleblueGrey14,
                    ),
                    Text(dataList.patientsList.dob[position] ?? "N/A")
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
            height: 1,
            color: Colors.grey,
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Address",
                  style: TextStyleblueGrey14,
                ),
                Text("${dataList.patientsList.address != null ? dataList.patientsList.address[position] : "N/A"}")
              ],
            ),
          )
        ],
      ),
    );
  }
}
