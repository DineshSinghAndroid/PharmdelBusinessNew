import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import '../../Controller/WidgetController/AdditionalWidget/Default Functions/defaultFunctions.dart';
import '../../Controller/WidgetController/AdditionalWidget/RadioTileCustom/radioTileCustom.dart';
import '../../Controller/WidgetController/StringDefine/StringDefine.dart';

class UpdateStatusScreen extends StatefulWidget {
  const UpdateStatusScreen({super.key});

  @override
  State<UpdateStatusScreen> createState() => _UpdateStatusScreenState();
}

class _UpdateStatusScreenState extends State<UpdateStatusScreen> {
  int? isTileSelected;
  List<String> statusTypeItems = [
    'Out For Delivery',
    'Completed',
    'Failed',
    'Cancelled',
    'Received',
    'Requested',
    'Ready',
    'PickedUp',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColors.materialAppThemeColor,
          title: BuildText.buildText(
            text: "Order ID : ",
            // ${widget.id != null ? widget.id : ""}${widget.pmr_type != null && (widget.pmr_type == "titan" || widget.pmr_type == "nursing_box") && widget.pNo != null && widget.pNo.isNotEmpty ? ", P/N : ${widget.pNo}" : ""}",
            color: AppColors.blackColor,
            size: 18,
          ),
          leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: CircleAvatar(
                  backgroundColor: AppColors.whiteColor,
                  child: Icon(
                    Icons.arrow_back,
                    color: AppColors.blackColor,
                  ),
                ),
              ))),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.person_outline,
                        color: AppColors.yetToStartColor,
                      ),
                      buildSizeBox(0.0, 5.0),
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BuildText.buildText(
                                text: kPatientDetails,
                                color: AppColors.yetToStartColor,
                                weight: FontWeight.w500,
                                size: 16),
                            buildSizeBox(10.0, 0.0),
                            BuildText.buildText(
                              text: 'Patient Name',
                              size: 14,
                              color: AppColors.blackColor,
                              weight: FontWeight.bold,
                            ),
                            buildSizeBox(5.0, 0.0),
                            Container(
                              child: BuildText.buildText(
                                text: "Address",
                                size: 14,
                                color: AppColors.blackColor,
                              ),
                            ),
                            buildSizeBox(10.0, 0.0),
                            BuildText.buildText(text: '+4413543131564'),
                            buildSizeBox(15.0, 0.0),
                            buildSizeBox(10.0, 0.0),
                            BuildText.buildText(
                                text: kExistingNote,
                                color: AppColors.yetToStartColor,
                                weight: FontWeight.w500,
                                size: 15),
                            BuildText.buildText(
                                text: 'Delivery Notesssssss.....',
                                color: Colors.blue.shade900,
                                weight: FontWeight.w500,
                                size: 15),
                          ],
                        ),
                      ),
                      const Spacer(),

                      ///Map and Phone Icons
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              MapsLauncher.launchCoordinates(
                                37.4220041, //lat will be dynamic 
                                -122.0862462,  //lng will be dynamic
                                'Google Headquarters are here');
                              BuildText.buildText(text: 'LAUNCH COORDINATES');
                            },
                            child: Image.asset(
                              strIMG_Map,
                              height: 30,
                              width: 30,
                            ),
                          ),
                          buildSizeBox(10.0, 0.0),
                          InkWell(
                            onTap: () async {
                              DefaultFuntions.launchPhone('+918094705928');
                            },
                            child: CircleAvatar(
                                backgroundColor: AppColors.greenColor,
                                radius: 15.0,
                                child: Icon(
                                  Icons.call,
                                  color: AppColors.whiteColor,
                                  size: 22,
                                )),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                buildSizeBox(15.0, 0.0),
                
                ///Radio Tile 
                Row(
                  children: [
                    RadioTileCusotm(
                      text: kPickedUp,
                      bgColor: AppColors.greenColor,
                      onTap: () {},
                    ),
                    buildSizeBox(0.0, 25.0),
                    RadioTileCusotm(
                      text: kCancel,
                      bgColor: AppColors.redColor,
                      onTap: () {},
                    )
                  ],
                ),
                buildSizeBox(25.0, 0.0),

                ///DropDown
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      border: Border.all(color: Colors.grey.shade700),
                      borderRadius: BorderRadius.circular(50.0)),
                  child: Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          // value: "Recieved",
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: AppColors.blackColor),
                          underline: Container(
                            height: 2,
                            color: AppColors.blackColor,
                          ),
                          onChanged: (String? newValue) {
                            // if (newValue == "Completed") {
                            //   calculateAmount();
                            // }
                            // if ("Out For Delivery" != newValue)
                            //   setState(() {
                            //     dropdownValue = newValue;
                            //   });
                            // if ("PickedUp" == newValue) getParcelBoxData(widget.driverId);
                          },
                          items: statusTypeItems
                              .map<DropdownMenuItem<String>>((String? value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value!,
                                style: TextStyle(
                                    color: "Out For Delivery" != value
                                        ? Colors.black
                                        : Colors.grey),
                              ),
                            );
                          }).toList(),
                        ),
                      )),
                ),
                buildSizeBox(40.0, 0.0),
                ButtonCustom(
                  onPress: () {},
                  text: kUpdateStatus,
                  textSize: 15,
                  buttonWidth: Get.width,
                  buttonHeight: 50,
                  borderRadius: BorderRadius.circular(10),
                  backgroundColor: AppColors.blueColorLight,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
