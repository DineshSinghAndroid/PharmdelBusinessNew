import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:pharmdel_business/ui/ProfilePage/VechileInspection_Report/VechileInspection_Report_Screen.dart';
import 'package:pharmdel_business/ui/driver_user_type/dashboard_driver.dart';
import 'package:pharmdel_business/util/log_print.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../CONTROLLERS/ProjectController/VirController/vir_controller.dart';
import '../../../data/web_constent.dart';
import '../../../main.dart';
import '../../../util/AnimatedButton.dart';
import '../../../util/connection_validater.dart';
import '../../../util/custom_camera_screen.dart';
import '../../../util/custom_loading.dart';
import '../../login_screen.dart';
import 'images_data.dart';
import 'package:http/http.dart' as http;

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
  VirController? virController;

  @override
  void initState() {
    setState(() {
      stateTextWithIcon = ButtonState.idle;
    });
    super.initState();
    init();
  }

  @override
  void dispose() {
    remarkController.dispose();
    ButtonState;
    super.dispose();
  }

  void init() async {
    virController = Provider.of<VirController>(context, listen: false);
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
    String vehicleIdFromApi = prefs.getString(WebConstant.VEHICLE_ID).toString();
     // Fluttertoast.showToast(msg: vehicleId);
    setState(() {
       widget.vehicleId = vehicleIdFromApi;
    });
    print("Widget vehicle is set to " +widget.vehicleId);

  }

  @override
  Widget build(BuildContext context) {
    virController = Provider.of<VirController>(context);

    return Scaffold(
      backgroundColor: Colors.white.withOpacity(1.0),
      appBar: AppBar(


        title: Text(WebConstant.Click_Images),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 30),
              Text(
                "Click ${widget.screenName} Images ",
                style: TextStyle(fontSize: 32, color: Colors.black),
              ),
              SizedBox(
                height: 50,
              ),
              GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: clickImages?.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 6 / 7.5),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CameraScreen()))
                          .then((value) async {
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
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      // height: 150,
                      width: 100,
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                        ),
                      ], borderRadius: BorderRadius.all(Radius.circular(5))),
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
                              : Lottie.network('https://assets1.lottiefiles.com/packages/lf20_efenfp40.json',
                                  height: 100, width: 100),
                          Spacer(),
                          Container(
                              padding: EdgeInsets.symmetric(
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
                                          print("Image Deleted Successfully");
                                        });
                                      },
                                      icon: Icon(
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
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Remark's",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: remarkController,
                decoration: InputDecoration(
                    hintText: "Enter your remark's here",
                    hintStyle: TextStyle(fontSize: 14),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.grey, width: 1))),
              ),
              SizedBox(
                height: 20,
              ),
              AnimatedBtn('Submit', onPressedIconWithText),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onPressedIconWithText() async {
    bool isBlank = clickImages!.any((element) => element.baseCode == "");
    if (widget.vehicleId != '') {

      print(widget.vehicleId.toString());
      if (isBlank == false) {
        List<Map<String, dynamic>> dictParameter = [];
        for (var data in clickImages!) {
          Map<String, dynamic> tyreParameter = {
            "type": data.type ?? 0,
            "image": data.baseCode ?? "",
          };
          dictParameter.add(tyreParameter);
        }
        await CustomLoading().showLoadingDialog(context, true);

        Map<String, dynamic> apiParameter = {
          "section": widget.screenName.toLowerCase(),
          "remarks": remarkController.text ?? '',
          "section_image": dictParameter,
          "vehicle_id": widget.vehicleId
        };
        // submitInspectionReport(vehicleId: vehicleId, clickedImages: clickedImages, Comments: Comments, type: type)
        PrintLog.printLog("dictParameter: ${apiParameter}");
        await virController?.virUpload(context: context, dictData: apiParameter);
        await CustomLoading().showLoadingDialog(context, false);

        setState(() {
          stateTextWithIcon = ButtonState.success;
        });
        final prefs = await SharedPreferences.getInstance();
      } else {
        await CustomLoading().showLoadingDialog(context, false);

        Fluttertoast.showToast(msg: "Please Click All Images", gravity: ToastGravity.TOP);
        setState(() {
          stateTextWithIcon = ButtonState.fail;
        });
      }
    } else {
      Fluttertoast.showToast(msg: "Please choose any vehicle first", gravity: ToastGravity.TOP);
    }
    setState(() {

    });

  }
}
