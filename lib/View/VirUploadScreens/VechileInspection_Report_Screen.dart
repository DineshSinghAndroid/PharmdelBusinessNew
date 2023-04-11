import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controller/Helper/TextController/FontStyle/FontStyle.dart';
import '../../Controller/ProjectController/VechicleInspectionReportController/vir_home_screen_controller.dart';
import 'click_images.dart';

class VechileInspectionReportScreen extends StatefulWidget {
  String vehicleId;

  VechileInspectionReportScreen({super.key,required this.vehicleId,});

  @override
  _MyCustomWidgetState createState() => _MyCustomWidgetState();
}

TextEditingController remarkController = TextEditingController();

class _MyCustomWidgetState extends State<VechileInspectionReportScreen> {
  final VirHomeScreenController _virCtrl = Get.put(VirHomeScreenController());

  @override
  void initState() {
    super.initState();
    _virCtrl.vechicleId = widget.vehicleId;
    print("widget vehicle id is :::>> ${widget.vehicleId}");
  }

  @override
  Widget build(BuildContext c) {
    double w = MediaQuery.of(context).size.width;

    return GetBuilder(
      init: _virCtrl,
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(

            title: const Text("Vehicle Inspection Report"),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SafeArea(
                child: Column(

                  children: [

                    const SizedBox(
                      height: 50,
                    ),
                    Text(
                      "Pick a service",
                      style: TS.CTS(32.0, Colors.white, FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 1.8,
                      child: ListView.builder(
                        padding: EdgeInsets.all(w / 30),
                        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                        itemCount: _virCtrl.texts.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return ClickInspectionImagesScreen(
                                    screenName: _virCtrl.texts[index],
                                    vehicleId: widget.vehicleId,
                                  );
                                },
                              );
                              print("Vehicle id going to click image screen is ${widget.vehicleId}");
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              margin: EdgeInsets.only(bottom: w / 20),
                              height: w / 6,
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.4),
                                borderRadius: const BorderRadius.all(Radius.circular(20)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 40,
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    _virCtrl.icons[index],
                                    size: 32,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    _virCtrl.texts[index],
                                    style: TS.CTS(22.0, Colors.white, FontWeight.w500),
                                  ),
                                  Icon(
                                    _virCtrl.arrowIcons[index],
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    MaterialButton(
                      onPressed: ()=>_virCtrl.fetchUpdatedData(vehicleId: 0),
                      color: Colors.white,
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
