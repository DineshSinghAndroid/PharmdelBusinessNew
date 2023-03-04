import 'package:flutter/material.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';

class PharmacyDeliveryListScreen extends StatefulWidget {
  const PharmacyDeliveryListScreen({super.key});

  @override
  State<PharmacyDeliveryListScreen> createState() =>
      _PharmacyDeliveryListScreenState();
}

class _PharmacyDeliveryListScreenState
    extends State<PharmacyDeliveryListScreen> {
  String dropdownvalue = 'Select Route';

  var items = [
    'north',
    'south',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          centerTitle: true,
          iconTheme: IconThemeData(color: AppColors.blackColor),
          actionsIconTheme: IconThemeData(color: AppColors.blackColor),
          title: BuildText.buildText(
              text: kDeliveryList, color: AppColors.blackColor, size: 18),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Row(
                children: [
                  InkWell(
                      onTap: () {},
                      child: Icon(
                        Icons.search,
                        color: AppColors.blackColor,
                      )),
                  buildSizeBox(0.0, 10.0),
                  InkWell(
                      onTap: () {},
                      child: Icon(Icons.refresh, color: AppColors.blackColor)),
                  buildSizeBox(0.0, 10.0),
                  InkWell(
                      onTap: () {},
                      child: Icon(
                        Icons.person,
                        color: AppColors.blackColor,
                      ))
                ],
              ),
            )
          ],
        ),
        body: Stack(
          children: [
            Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset(strIMG_HomeBg)),
            // DropdownButtonHideUnderline(
            //   child: DropdownButton(
            //       value: dropdownvalue,
            //       icon: const Icon(Icons.keyboard_arrow_down),
            //       items: items.map((String items) {
            //         return DropdownMenuItem(
            //           value: items,
            //           child: BuildText.buildText(text: items),
            //         );
            //       }).toList(),
            //       onChanged: (String? newValue) {
            //         setState(() {
            //           dropdownvalue = newValue!;
            //         });
            //       },
            //     ),
            // ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(5),
                    width: 140,
                    height: 50,
                    decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BuildText.buildText(text: kSelectRoute),
                        const Icon(Icons.arrow_drop_down)
                      ],
                    ),
                  ),
                  buildSizeBox(10.0, 0.0),
                  Row(
                    children: [
                      InkWell(
                        onTap: (){},
                        child: Chip(
                          label: BuildText.buildText(
                              text: kToday, color: AppColors.whiteColor),
                          backgroundColor: AppColors.blueColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                        ),
                      ),
                      buildSizeBox(0.0, 8.0),
                      InkWell(
                        onTap: (){},
                        child: Chip(
                          label: BuildText.buildText(
                              text: kTomorrow, color: AppColors.whiteColor),
                          backgroundColor: AppColors.blueColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                        ),
                      ),
                      buildSizeBox(0.0, 8.0),
                      InkWell(
                        onTap: (){},
                        child: Chip(
                          label: Row(
                            children: [
                              Icon(
                                Icons.calendar_month,
                                color: AppColors.whiteColor,
                                size: 20,
                              ),
                              buildSizeBox(0.0, 5.0),
                              BuildText.buildText(
                                  text: kSelect, color: AppColors.whiteColor),
                            ],
                          ),
                          backgroundColor: AppColors.blueColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                        ),
                      ),
                    ],
                  ),
                  buildSizeBox(25.0, 0.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: DefaultWidget.topCounter(
                              bgColor: AppColors.blueColor,
                              label: kTotal,
                              counter: '0',
                              onTap: () {
                                setState(() {});
                              })),
                      // Flexible(
                      //     flex: 1,
                      //     fit: FlexFit.tight,
                      //     child: DefaultWidget.topCounter(
                      //         bgColor: AppColors.yetToStartColor,
                      //         label: kOnTheWay,
                      //         counter: '0',
                      //         onTap: () {
                      //           setState(() {});
                      //         })),
                      Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: DefaultWidget.topCounter(
                              bgColor: AppColors.greyColorDark,
                              label: kPickedUp,
                              counter: '0',
                              onTap: () {
                                setState(() { });
                              })),
                      Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: DefaultWidget.topCounter(
                              bgColor: AppColors.greenAccentColor,
                              label: kDelivered,
                              counter: '0',
                              onTap: () {
                                setState(() {});
                              })),
                      Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: DefaultWidget.topCounter(
                              bgColor: AppColors.redColor.withOpacity(0.9),
                              label: kFailed,
                              counter: '0',
                              onTap: () {
                                setState(() {});
                              })),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
