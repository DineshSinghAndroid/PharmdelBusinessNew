import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../Controller/WidgetController/AdditionalWidget/ExpansionTileCard/expansionTileCardWidget.dart';

class PharmacyDrawerScreen extends StatelessWidget {
  String userName ='';

  var email;

  var mobile;

  var versionCode;

  PharmacyDrawerScreen({
    super.key,
      required this.userName,
    required this.email,
    required this.mobile,
    required this.versionCode,
  });

  @override
  Widget build(BuildContext context) {
    String address1 ='Not Found';

    return SafeArea(
      child: Container(
        color: Colors.white,
        height: Get.height,
        width: Get.width * 0.8,
        child: Column(
          children: [
            Container(
              height: 130,
              color: const Color(0xFFF8A340),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                height: 65,
                                width: 65,
                                decoration: BoxDecoration(
                                    boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 8, spreadRadius: 1, offset: Offset(0, 0))],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50)),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50.0),
                                    child: Center(
                                        child: Text(
                                      userName =  "",
                                      style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400),
                                    )))),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 2.0),
                                      child: Text(
                                        userName ?? "",
                                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 2.0),
                                      child: Text(
                                        email ?? "",
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 2.0),
                                      child: Text(
                                        mobile ?? "",
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),

              child: Column(
                children: [
                  Container(
                    child: ExpansionTileCard(
                      animateTrailing: true,
                      title: const Text('Personal Info'),
                      leading: const Icon(
                        Icons.person,
                        size: 20,
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ), // height: 200,

                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.mobile_friendly_sharp,
                                    color: Colors.black,
                                    size: 12,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    mobile ?? "Not Found",
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.email,
                                    color: Colors.grey,
                                    size: 12,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    email ?? "Not Found",
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_city_outlined,
                                    color: Colors.grey,
                                    size: 12,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    address1 ?? "Not Found",
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ],
                      onExpansionChanged: (value) {
                        // if (value) {
                        //   Future.delayed(const Duration(milliseconds: 500),
                        //           () {
                        //         for (var i = 0; i < cardKeyList.length; i++) {
                        //           if (cardKeyList == i) {
                        //             cardKeyList[i].currentState?.collapse();
                        //           }
                        //         }
                        //       });
                        // }
                      },
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Change Pin",
                            style: TextStyle(color: Colors.black, fontSize: 17),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black,
                            size: 17,
                          )
                        ],
                      ),
                    ),
                  ),
                  const Divider(),

                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Create Patient",
                            style: TextStyle(color: Colors.black, fontSize: 17),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black,
                            size: 17,
                          )
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationScreen()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "My Notification",
                            style: TextStyle(color: Colors.black, fontSize: 17),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 17,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Privacy Policy",
                            style: TextStyle(fontSize: 17, color: Colors.black),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 17,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Terms of use",
                            style: TextStyle(fontSize: 17, color: Colors.black),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 17,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Logout",
                            style: TextStyle(fontSize: 17, color: Colors.black),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 17,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                ],
              ),
            ),
            const Spacer(),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("VERSION V.${versionCode} ", style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w400)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
