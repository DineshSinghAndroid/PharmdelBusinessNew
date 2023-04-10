import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:pharmdel/Controller/WidgetController/Loader/LoadScreen/LoadScreen.dart';
import '../../../Model/DriverRoutes/get_route_list_response.dart';
import '../../../Model/PharmacyModels/P_GetDriverListModel/P_GetDriverListModel.dart';
import '../../Helper/Calender/calender.dart';
import '../../WidgetController/StringDefine/StringDefine.dart';
import 'driver_dashboard_ctrl.dart';

class ReschedulePopUp extends StatefulWidget{
  List<String> selectedOrderIDs;
  ReschedulePopUp({Key? key,required this.selectedOrderIDs}) : super(key: key);


  @override
  State<ReschedulePopUp> createState() => _ReschedulePopUpState();
}

class _ReschedulePopUpState extends State<ReschedulePopUp> {

  DriverDashboardCTRL dashCTRL = Get.find();
  RouteList? selectedRoute;
  final DateFormat formatter = DateFormat("dd-MM-yyyy");
  String? selectedDate;
  String? selectedDateTimeStamp;

  RouteList? selectedRoutDropDown;
  DriverModel? selectedDriver;
  List<DriverModel>? driverList;


  String? totalDeliveriesCount;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 100),(){
      init();
    });

    super.initState();
  }

  Future<void> init()async{
    selectedRoute = dashCTRL.selectedRoute;
    selectedDate = formatter.format(DateTime.now());
    selectedDateTimeStamp = DateTime.now().millisecondsSinceEpoch.toString();
    selectedRoutDropDown = dashCTRL.selectedRoute;

    totalDeliveriesCount = widget.selectedOrderIDs.length.toString();
    driverList = dashCTRL.driverList;

    String driverID = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.userId) ?? "";
    if(dashCTRL.selectedDriver == null && driverID != "null" && driverID != ""){

      await dashCTRL.getDriverList(context: context, routeId: dashCTRL.selectedRoute?.routeId.toString() ?? "0").then((value) {
        int indexFind = dashCTRL.driverList.indexWhere((element) => element.driverId.toString() == driverID.toString());
        if(indexFind >= 0){
          selectedDriver = dashCTRL.driverList[indexFind];
        }
        driverList = dashCTRL.driverList;
        setState(() { });
      });
    }else{
      selectedDriver = dashCTRL.selectedDriver;
    }
    setState(() {

    });
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<DriverDashboardCTRL>(
      init: dashCTRL,
        builder: (controller){
          return LoadScreen(
            widget: Dialog(
              insetPadding: const EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
              backgroundColor: AppColors.transparentColor,
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(color: AppColors.blackColor, offset: const Offset(0, 10), blurRadius: 10),
                        ]
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                        /// Title
                        Container(
                            padding: const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
                            width: Get.width,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.grey[200],
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)
                              ),
                            ),
                            child: Center(
                                child: BuildText.buildText(text: kRescheduleDelivery,size: 16)
                            )
                        ),

                        buildSizeBox(10.0, 0.0),

                        Container(
                          padding: const EdgeInsets.only(left: 20,right: 20, ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildSizeBox(5.0, 0.0),

                              /// Title
                              Padding(
                                padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 10.0),
                                child: BuildText.buildText(
                                    text: "$kWouldYouLikeToReschedule $totalDeliveriesCount deliveries for $selectedDate. $kAreYouOkayToProceed",
                                    weight: FontWeight.w400,textAlign: TextAlign.center
                                )
                              ),

                              buildSizeBox(5.0, 0.0),

                              /// Select reschedule date
                              Padding(
                                padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 10.0),
                                child: BuildText.buildText(
                                    text: kSelectRescheduleDate,
                                    weight: FontWeight.w600,size: 16
                                )
                              ),

                              /// Select date calender
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: InkWell(
                                  onTap: () async {

                                    await CalenderCustom.getCalenderDate().then((value){
                                      selectedDate = formatter.format(value);
                                      selectedDateTimeStamp = value.millisecondsSinceEpoch.toString();

                                      setState(() {
                                        PrintLog.printLog("Selected Data: $selectedDate\nSelected Time Stamp: $selectedDateTimeStamp");
                                      });
                                    });


                                  },
                                  child: Container(
                                    width: Get.width,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.grey.withOpacity(0.7)),
                                        borderRadius: BorderRadius.circular(50.0)
                                    ),
                                    child: Padding(
                                        padding: const EdgeInsets.only(left: 15.0, right: 25.0, top: 10, bottom: 10),
                                        child: BuildText.buildText(
                                            text: selectedDate ?? "",
                                            size: 16
                                        )
                                    ),
                                  ),
                                ),
                              ),

                              buildSizeBox(5.0, 0.0),

                              /// Select Route
                              Padding(
                                padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 10.0),
                                child: BuildText.buildText(
                                    text: kSelectRoute,
                                    size: 16,weight: FontWeight.w600
                                )
                              ),

                              /// Select route drop down
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.grey.withOpacity(0.7)),
                                      borderRadius: BorderRadius.circular(50.0)
                                  ),
                                  child: Padding(
                                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<RouteList>(
                                          isExpanded: true,
                                          value: selectedRoutDropDown,
                                          icon: const Icon(Icons.arrow_drop_down),
                                          iconSize: 24,
                                          elevation: 16,
                                          style: const TextStyle(color: Colors.black),
                                          underline: Container(
                                            height: 2,
                                            color: Colors.black,
                                          ),
                                          onChanged: (RouteList? newValue) async {

                                              PrintLog.printLog("Route Selected : ${newValue?.routeName}");
                                              selectedRoutDropDown = newValue;
                                              selectedDriver = null;

                                              await controller.getDriverList(context: context, routeId: newValue?.routeId.toString() ?? "0").then((value) {
                                                driverList = controller.driverList;
                                                setState(() { });
                                              });

                                          },
                                          items: controller.routeList?.map<DropdownMenuItem<RouteList>>((RouteList value) {
                                            return DropdownMenuItem<RouteList>(
                                              value: value,
                                              child: BuildText.buildText(text: value.routeName ?? "",)
                                            );
                                          }).toList(),
                                        ),
                                      )),
                                ),
                              ),

                              /// Select Driver
                              Padding(
                                padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 10.0),
                                child: BuildText.buildText(text: kSelectDriver,size: 16,weight: FontWeight.w600)
                              ),

                              /// Select Driver Drop Down
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.grey.withOpacity(0.7)),
                                      borderRadius: BorderRadius.circular(50.0)
                                  ),
                                  child: Padding(
                                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                      child: DropdownButtonHideUnderline(

                                        child: DropdownButton<DriverModel>(
                                          isExpanded: true,
                                          value: selectedDriver,
                                          icon: const Icon(Icons.arrow_drop_down),
                                          iconSize: 24,
                                          elevation: 16,
                                          style: const TextStyle(color: Colors.black),
                                          underline: Container(
                                            height: 2,
                                            color: Colors.black,
                                          ),
                                          onChanged: (DriverModel? newValue) {
                                            setState(() {
                                              selectedDriver = newValue;
                                            });
                                          },
                                          items: controller.driverList.map<DropdownMenuItem<DriverModel>>((DriverModel value) {
                                            return DropdownMenuItem<DriverModel>(
                                              value: value,
                                              child: BuildText.buildText(text: value.firstName ?? "")
                                            );
                                          }).toList(),
                                        ),
                                      )),
                                ),
                              )
                            ],
                          ),
                        ),

                        buildSizeBox(15.0, 0.0),

                        /// Cancel Button or Reschedule Btn
                        Padding(
                          padding: const EdgeInsets.only(left: 20,right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              /// Cancel Button
                              SizedBox(
                                  height: 35.0,
                                  width: 110.0,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                    ),
                                    child: BuildText.buildText(
                                        text: kCancel,textAlign: TextAlign.center,color: AppColors.whiteColor,weight: FontWeight.bold
                                    ),
                                    onPressed: () {
                                      Get.back();
                                    },
                                  )
                              ),

                              /// Reschedule Btn
                              SizedBox(
                                  height: 35.0,
                                  width: 110.0,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                    ),
                                    child: BuildText.buildText(
                                        text: kRescheduleNow,textAlign: TextAlign.center,color: AppColors.whiteColor,weight: FontWeight.bold
                                    ),
                                    onPressed: () async {

                                      if (selectedDriver == null) {
                                        ToastCustom.showToast(msg: "Select Driver");
                                      } else if (selectedRoute == null) {
                                        ToastCustom.showToast(msg: "Select Route");
                                      }else if (selectedDriver != null && selectedRoute != null) {

                                        await controller.getRescheduleOrderApi(
                                            context: context,
                                            orderId: widget.selectedOrderIDs.join(","),
                                            rescheduleDate: selectedDate ?? "",
                                            driverId: selectedDriver?.driverId.toString() ?? "0",
                                            routeId: selectedRoute?.routeId.toString() ?? "0"
                                        ).then((value) {
                                          if(controller.isSuccess == true){
                                            Navigator.of(context).pop(true);
                                          }
                                        });
                                      }
                                    },
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
            isLoading: controller.isLoading,
          );
        }
    );
  }
}