
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';


class CustomerListScreen extends StatelessWidget {
  int position = 0;


  CustomerListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Text("hi");
    // initializeDateFormatting('IST');
    return Card(
      color: Colors.primaries[Random().nextInt(Colors.primaries.length)].shade100,
      // color: AppColors.lightPinkColor,
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
                          //Customer Name
                          BuildText.buildText(text: ""),
                          buildSizeBox(4.0,0.0),
                          const Divider(height: 1,color: Colors.grey,),
                          buildSizeBox(10.0,0.0),
                          //Customer ID
                          BuildText.buildText(text: ""),
                         buildSizeBox(3.0,0.0),
                          //Customer DOB
                          BuildText.buildText(text: ""),
                          buildSizeBox(3.0,0.0),
                          //NHS Number
                         BuildText.buildText(text: ""),
                         buildSizeBox(3.0,0.0),
                          //Customer Address
                          BuildText.buildText(text: ""),
                          // Text(
                          //   "Address : ${dataList.patientsList.address != null ? dataList.patientsList.address[position] ?? "N/A" : "N/A"}" ?? "",
                          //   style: TextStyleblueGrey14,
                          // ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: MaterialButton(
                                onPressed: () {
                                  // print(dataList.patientsList.userId[position]);
                                  // selectedListner.isSelected(dataList.patientsList.userId[position], position, dataList.patientsList.alt_address[position]);
                                },
                                color: Colors.blue,
                                child: BuildText.buildText(text: "Select Customer"),
                          ),
                      )],
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
