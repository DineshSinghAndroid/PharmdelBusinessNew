import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pharmdel_business/data/Notification.dart';

import 'notification.dart';

class NotificationWidget extends StatelessWidget {
  NotificationList dataList;
  NotificationSelectedListner selectedListner;

  Random math = Random();

  NotificationWidget(NotificationList this.dataList, NotificationSelectedListner this.selectedListner) : super();

  @override
  Widget build(BuildContext context) {
    // return Text("hi");
    // initializeDateFormatting('IST');
    DateFormat sdf = new DateFormat("dd-MM-yyyy HH:mm");
    DateTime date = sdf.parse(dataList.created);
    var now = DateTime.now();
    var days = now.difference(date).inDays;
    var hours = now.difference(date).inHours;
    var mintus = now.difference(date).inMinutes;
    String time = days > 0 ? days.toString() + "day" : (hours > 0 ? hours.toString() + "hr" : mintus.toString() + "min");
    return Card(
      color: Colors.primaries[Random().nextInt(Colors.primaries.length)].shade100,
      // color: CustomColors.lightPinkColor,
      margin: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 8, left: 3, right: 8, bottom: 8),
            padding: EdgeInsets.only(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      //color: Colors.grey,
                      // margin: EdgeInsets.only(top: 10),
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        // color: CustomColors.darkPinkColor,
                        // image: backgroundImage != null
                        //     ? new DecorationImage(image: backgroundImage, fit: BoxFit.cover)
                        //     : null,

                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.notifications,
                        size: 30,
                        color: Colors.orange[300],
                      ),
                    ),
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
                            dataList.name ?? "",
                            style: TextStyle(
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            dataList.message ?? "",
                            style: TextStyle(
                              fontFamily: "Montserrat",
                            ),
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(
                    //   width: MediaQuery.of(context).size.width * .15,
                    // ),
                    // Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // InkWell(
                        //   child: Icon(
                        //     Icons.delete,
                        //     color: CustomColors.darkPinkColor,
                        //   ),
                        //   onTap: (){
                        //     selectedListner.isSelected(1,  dataList);
                        //   },
                        // ),
                        Text(
                          time,
                          style: TextStyle(fontFamily: "Montserrat", fontSize: 10),
                        )
                      ],
                    )
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
