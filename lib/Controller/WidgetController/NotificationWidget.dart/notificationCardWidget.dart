import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';

class NotificationCardWidget extends StatelessWidget {
  String? name;
  String? message;
  String? time;
  VoidCallback? onTap;
NotificationCardWidget({super.key, required this.time, required this.message, required this.name, this.onTap});

  Random math = Random();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: Colors.primaries[Random().nextInt(Colors.primaries.length)].shade100,
        // color: AppColors.lightPinkColor,
        margin: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8, left: 3, right: 8, bottom: 8),
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(                     
                        height: 45,
                        width: 45,
                        decoration: const BoxDecoration(                   
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.notifications,
                          size: 30,
                          color: Colors.orange[300],
                        ),
                      ),
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
                              text: name ?? "",
                              style: const TextStyle(
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                           buildSizeBox(10.0, 0.0),
                            BuildText.buildText(
                              text:  message ?? "",
                              style: const TextStyle(
                                fontFamily: "Montserrat",
                              ),
                            ),
                          ],
                        ),
                      ),                  
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [               
                          Text(
                            time ?? "",
                            style: const TextStyle(fontFamily: "Montserrat", fontSize: 10),
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
      ),
    );
  }
}