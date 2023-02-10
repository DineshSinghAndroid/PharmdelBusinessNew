import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:pharmdel_business/model/assign_to_shelf_model.dart';

class RxDetailWidget extends StatelessWidget {
  MedicineDetail dataList;

  RxDetailWidget(MedicineDetail this.dataList) : super();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      // color: CustomColors.lightPinkColor,
      // shape: Border.all(color:Colors.grey, width: 1,),
      elevation: 3,
      margin: EdgeInsets.only(left: 5, right: 5, top: 11, bottom: 2),
      child: Column(
        children: [
          Container(
            // decoration: BoxDecoration(
            //     color: Colors.white, borderRadius: BorderRadius.circular(20)),
            margin: EdgeInsets.only(top: 8, left: 15, right: 8, bottom: 8),
            padding: EdgeInsets.only(bottom: 10),
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
                            dataList.medicineName ?? "N/A",
                            style: TextStyle(fontFamily: "Montserrat", color: Colors.blue), //e98559
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
                                      "Dosage",
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                    ),
                                    Text(dataList.dosage ?? "N/A")
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
                                      "Quantity",
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                    ),
                                    Text(dataList.quantity ?? "N/A")
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
                                      "Days",
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                    ),
                                    Text(dataList.days ?? "N/A")
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
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Drug Type",
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                    ),
                                    Text(dataList.drugType.toString().isEmpty ? "N/A" : dataList.drugType)
                                  ],
                                ),
                              ),
                              Spacer(),
                              Flexible(
                                fit: FlexFit.tight,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Remark",
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                    ),
                                    Text(dataList.remarks ?? "N/A"),
                                  ],
                                ),
                              ),
                            ],
                          )
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
