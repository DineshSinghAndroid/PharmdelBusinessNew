import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pharmdel/Controller/Helper/Shared%20Preferences/SharedPreferences.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Controller/Helper/Camera/CameraScreen.dart';
import '../../Controller/Helper/PrintLog/PrintLog.dart';
import '../../Controller/ProjectController/VechicleInspectionReportController/vir_click_imageas_controller.dart';
import '../../Controller/WidgetController/Loader/LoadingScreen.dart';
import 'images_data.dart';

class ClickInspectionImagesScreen extends StatefulWidget {
  String screenName;
  String vehicleId;

  ClickInspectionImagesScreen({Key? key, required this.screenName, required this.vehicleId}) : super(key: key);

  @override
  State<ClickInspectionImagesScreen> createState() => _ClickInspectionImagesScreenState();
}

class _ClickInspectionImagesScreenState extends State<ClickInspectionImagesScreen> {
  List<InspectionImages>? clickImages;

  List<InspectionImages>? tyreImages = [
    InspectionImages(type: "Front Left", baseCode: ""),
    InspectionImages(type: "Front Right", baseCode: ""),
    InspectionImages(type: "Back Left", baseCode: ""),
    InspectionImages(type: "Back Right", baseCode: ""),
  ];
  List<InspectionImages>? bodyImages = [
    InspectionImages(type: "Left", baseCode: ""),
    InspectionImages(type: "Right", baseCode: ""),
    InspectionImages(type: "Front", baseCode: ""),
    InspectionImages(type: "Back", baseCode: ""),
  ];
  List<InspectionImages>? insideImages = [
    InspectionImages(type: "Dashboard", baseCode: ""),
    InspectionImages(type: "Driver Seat", baseCode: ""),
    InspectionImages(type: "Passenger", baseCode: ""),
    InspectionImages(type: "Rear Seat", baseCode: ""),
  ];
  List<InspectionImages>? bootImages = [
    InspectionImages(type: "Spare Wheel", baseCode: ""),
    InspectionImages(type: "Tool Kit", baseCode: ""),
    InspectionImages(type: "Floor", baseCode: ""),
    InspectionImages(type: "Full Back", baseCode: ""),
  ];

  List<InspectionImages>? engineImages = [
    InspectionImages(type: "Pic 1", baseCode: ""),
    InspectionImages(type: "Pic 2", baseCode: ""),
    InspectionImages(type: "Pic 3", baseCode: ""),
    InspectionImages(type: "Pic 4", baseCode: ""),
  ];

  TextEditingController remarkController = TextEditingController();
  final VirClickImagesController _virController = Get.put(VirClickImagesController());

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    remarkController.dispose();
    super.dispose();
  }

  void init() async {
    if (widget.screenName.toString().toLowerCase() == "engine") {
      clickImages = engineImages;
    } else if (widget.screenName.toString().toLowerCase() == "tyre") {
      clickImages = tyreImages;
    } else if (widget.screenName.toString().toLowerCase() == "boot") {
      clickImages = bootImages;
    } else if (widget.screenName.toString().toLowerCase() == "inside") {
      clickImages = insideImages;
    } else if (widget.screenName.toString().toLowerCase() == "body") {
      clickImages = bodyImages;
    }
    final prefs = await SharedPreferences.getInstance();
    String vehicleIdFromApi = prefs.getString(AppSharedPreferences.vehicleId).toString();
    setState(() {
      widget.vehicleId = vehicleIdFromApi;
    });
    PrintLog.printLog("Widget vehicle is set to ${widget.vehicleId}");
  }

  @override
  Widget build(BuildContext context) {
    // _virController = Provider.of<VirClickImagesController>(context);

    return Scaffold(
      backgroundColor: Colors.white.withOpacity(1.0),
      appBar: AppBar(
        title: const Text(kClickImage),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              buildSizeBox(30.0, 0.0),
              Text(
                "Click ${widget.screenName} Images ",
                style: const TextStyle(fontSize: 32, color: Colors.black),
              ),
              buildSizeBox(50.0, 0.0),
              GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: clickImages?.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 6 / 7.5),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const CameraScreen())).then((value) async {
                        if (value != null) {
                          clickImages?[index].image = File(value);
                          final imageData = await File(value);
                          final image = await imageData.readAsBytes();
                          clickImages?[index].baseCode = base64Encode(image);
                          setState(() {});
                          PrintLog.printLog("Clicked  ${clickImages?[index].type.toString()}");
                        }
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      // height: 150,
                      width: 100,
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                        ),
                      ], borderRadius: const BorderRadius.all(Radius.circular(5))),
                      child: Column(
                        children: [
                          clickImages?[index].image != null
                              ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 130,
                                  child: Image.file(
                                    clickImages![index].image!,
                                    fit: BoxFit.fill,
                                  ),
                                )
                              : Lottie.network('https://assets1.lottiefiles.com/packages/lf20_efenfp40.json', height: 100, width: 100),
                          const Spacer(),
                          Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              height: 40,
                              width: double.infinity,
                              decoration: BoxDecoration(color: Colors.blue.withOpacity(0.5)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  FittedBox(
                                    child: Text(clickImages?[index].type ?? ''),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          clickImages?[index].image = null;
                                          clickImages?[index].baseCode = '';
                                          PrintLog.printLog("Image Deleted Successfully");
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.delete_forever_outlined,
                                        color: Colors.white,
                                        size: 20,
                                      )),
                                ],
                              )),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Remark's",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
                ),
              ),
              buildSizeBox(10.0, 0.0),
              TextFormField(
                controller: remarkController,
                decoration: const InputDecoration(hintText: kEnterYourRemarkHere, hintStyle: TextStyle(fontSize: 14), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: Colors.grey, width: 1))),
              ),
              buildSizeBox(20.0, 0.0),
              MaterialButton(
                  onPressed: onPressedIconWithText,
                  color: Colors.black,
                  child: const Text(
                    kSubmit,
                    style: TextStyle(color: Colors.white),
                  )),
              buildSizeBox(30.0, 0.0),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onPressedIconWithText() async {
    bool isBlanks = clickImages!.any((element) => element.baseCode == "");
    bool isBlank = false;
    if (widget.vehicleId != '') {
      PrintLog.printLog(widget.vehicleId.toString());
      if (isBlank == false) {
        List<Map<String, dynamic>> dictParameter = [];
        for (var data in clickImages!) {
          Map<String, dynamic> tyreParameter = {
            "type": data.type ?? 0,
            "image": data.baseCode ?? "",
          };
          dictParameter.add(tyreParameter);
        }
        await CustomLoading().show(context, true);

        Map<String, dynamic> apiParameter = {"section": widget.screenName.toLowerCase(), "remarks": remarkController.text ?? '', "section_image": dictParameter, "vehicle_id": widget.vehicleId};
        // submitInspectionReport(vehicleId: vehicleId, clickedImages: clickedImages, Comments: Comments, type: type)
        PrintLog.printLog("dictParameter: ${apiParameter}");
        await _virController.virUpload(context: context, dictData: apiParameter);
      } else {
        await CustomLoading().show(context, false);

        Fluttertoast.showToast(msg: "Please Click All Images", gravity: ToastGravity.TOP);
      }
    } else {
      Fluttertoast.showToast(msg: "Please choose any vehicle first", gravity: ToastGravity.TOP);
    }
    CustomLoading().show(context, false);
    setState(() {});
  }
}
