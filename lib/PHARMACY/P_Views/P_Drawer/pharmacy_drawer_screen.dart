import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pharmdel/Controller/Helper/LogoutController/logout_controller.dart';

import '../../../Controller/Helper/Shared Preferences/SharedPreferences.dart';
import '../../../Controller/Helper/TextController/BuildText/BuildText.dart';
import '../../../Controller/RouteController/RouteNames.dart';
import '../../../Controller/WidgetController/AdditionalWidget/ExpansionTileCard/expansionTileCardWidget.dart';
import '../../../Controller/WidgetController/Loader/LoadingScreen.dart';
import '../../../Controller/WidgetController/Popup/CustomDialogBox.dart';
import '../../../Controller/WidgetController/StringDefine/StringDefine.dart';
import '../../../main.dart';

class PharmacyDrawerScreen extends StatefulWidget {
  String userName = '';
  String address1 = '';
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
  State<PharmacyDrawerScreen> createState() => _PharmacyDrawerScreenState();
}

class _PharmacyDrawerScreenState extends State<PharmacyDrawerScreen> {
  @override
  Widget build(BuildContext context) {
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
                                      widget.userName = "",
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
                                        widget.userName ?? "",
                                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 2.0),
                                      child: Text(
                                        widget.email ?? "",
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 2.0),
                                      child: Text(
                                        widget.mobile ?? "",
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
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  ExpansionTileCard(
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
                                  widget.mobile ?? "Not Found",
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
                                  widget.email ?? "Not Found",
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
                                  widget.address1 ?? "Not Found",
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
                  DrawerListTiles(text: 'Change Pin', ontap: () {}),
                  const Divider(),
                  DrawerListTiles(text: 'Create Patient', ontap: () {}),
                  const Divider(),
                  DrawerListTiles(text: 'My Notification', ontap: () {
                    Get.toNamed(pharmacyNotificationScreenRoute);
                  }),
                  const Divider(),
                  DrawerListTiles(text: 'Privacy Policy', ontap: () {}),
                  const Divider(),
                  DrawerListTiles(text: 'Terms of user', ontap: () {}),
                  const Divider(),
                  // DrawerListTiles(text: 'Logout', ontap:validateAndLogout(context)),
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
                  child: Text("VERSION V.${widget.versionCode} ", style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w400)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InkWell DrawerListTiles({required String text, ontap,}) {
    return InkWell(
      onTap: ontap,
      child: Container(
        margin: EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              text,
              style: TextStyle(fontSize: 17, color: Colors.black),
            ),
            Icon(
              Icons.arrow_forward_ios_sharp,
              size: 17,
            ),
          ],
        ),
      ),
    );
  }


}
