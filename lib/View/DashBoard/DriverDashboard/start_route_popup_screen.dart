import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import '../../../Controller/ProjectController/DriverDashboard/driver_dashboard_ctrl.dart';
import '../../../Controller/WidgetController/Loader/LoadScreen/LoadScreen.dart';
import '../../../Controller/WidgetController/StringDefine/StringDefine.dart';
import '../../../Model/DriverRoutes/get_route_list_response.dart';
import '../../UpdateAddressScreen.dart/updateAddressScreen.dart';

class StartOrEndRouteID {
  String? startRouteID;
  String? endRouteID;

  StartOrEndRouteID({this.startRouteID, this.endRouteID});
}



class StartRoutePopUp extends StatefulWidget {
  DriverDashboardCTRL ctrl;
  StartRoutePopUp({Key? key,required this.ctrl,}) : super(key: key);

  @override
  State<StartRoutePopUp> createState() => _StartRoutePopUpState();
}

class _StartRoutePopUpState extends State<StartRoutePopUp> {



  // int startLocationId = driverType.toLowerCase() == kDedicatedDriver.toLowerCase() ? 1 : 2;
  // int startGroupId = driverType.toLowerCase() == kDedicatedDriver.toLowerCase() ? 1 : 2;

  int startRouteId = driverType.toLowerCase() == kDedicatedDriver.toLowerCase() ? 1 : 2;
  int endRouteId = driverType.toLowerCase() == kDedicatedDriver.toLowerCase() ? 1 : 2;

  // int endId = 1;
  // int endType = 1;

  bool isAddressUpdated = false;
  bool showEndRouteOptions = false;
  bool isSelectAtLeastOneEndRouteMessage = false;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 100)).then((value) {
      init();
    });
    super.initState();
  }

  Future<void> init()async{
    String checkAddress = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.isAddressUpdated).toString();
    isAddressUpdated = checkAddress != "" && checkAddress != "null" && checkAddress != "false" ? true:false;

    if (widget.ctrl.selectedStartRoutePharmacy?.pharmacyId == "0" && widget.ctrl.selectedStartRoutePharmacy?.pharmacyId == "null" && widget.ctrl.selectedStartRoutePharmacy?.pharmacyId == null) {
        if(widget.ctrl.pharmacyList != null && widget.ctrl.pharmacyList!.isNotEmpty){
          widget.ctrl.selectedStartRoutePharmacy = widget.ctrl.pharmacyList?[0];
        }
      // widget.ctrl.driverRoutesApi(context: context);
      // return;
    }

    if (widget.ctrl.selectedStartRoutePharmacy?.pharmacyId == "0" || widget.ctrl.selectedStartRoutePharmacy?.pharmacyId == "null" || widget.ctrl.selectedStartRoutePharmacy?.pharmacyId == null) {
      showEndRouteOptions = true;
    } else {
      showEndRouteOptions = false;
    }
    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<DriverDashboardCTRL>(
        init: widget.ctrl,
        builder: (controller) {
          return LoadScreen(
            widget: Scaffold(
              backgroundColor: AppColors.blackColor.withOpacity(0.3),
              body: DelayedDisplay(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        Dialog(
                          insetPadding: const EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          child: Stack(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle, color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(color: AppColors.blackColor, offset: const Offset(0, 10), blurRadius: 10),
                                    ]
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[

                                    /// Are You Sure Want To Start Route?
                                    Container(
                                        padding: const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
                                        width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          color: Colors.grey[200],
                                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                        ),
                                        child: Center(
                                            child: BuildText.buildText(text: kAreYouSureWantToStart,size: 16)
                                        )
                                    ),
                                    buildSizeBox(10.0, 0.0),

                                    /// Start Route From:
                                    Container(
                                      padding: const EdgeInsets.only(left: 20,right: 20),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          buildSizeBox(5.0, 0.0),

                                          BuildText.buildText(text: "$kStartRouteFrom:",size: 16,weight: FontWeight.w600),

                                          /// Start Route From:
                                          Column(
                                            children: [
                                              if (driverType.toLowerCase() == kDedicatedDriver)
                                                DefaultWidget.selectionWidget(
                                                  onTap: (){
                                                    setState(() {
                                                      startRouteId = 1;
                                                    });
                                                  },
                                                  title: kPharmacy,
                                                  isSelected: startRouteId == 1,
                                                ),
                                              DefaultWidget.selectionWidget(
                                                onTap: (){
                                                  setState(() {
                                                    startRouteId = 2;
                                                  });
                                                },
                                                title: kCurrentLocation,
                                                isSelected: startRouteId == 2,
                                              ),
                                            ],
                                          ),


                                          /// End Route At: / Next Pharmacy
                                          Padding(
                                              padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 15.0),
                                              child: BuildText.buildText(
                                                  text: driverType.toLowerCase() == kDedicatedDriver.toLowerCase() ? kEndRouteAt : kNextPharmacy,
                                                  size: 16,weight: FontWeight.w600
                                              )
                                          ),

                                          /// For Dedicated Driver Pharmacy or Home
                                          if (driverType.toLowerCase() == kDedicatedDriver.toLowerCase())
                                            Column(
                                              children: [
                                                  DefaultWidget.selectionWidget(
                                                    onTap: (){
                                                      setState(() {
                                                        endRouteId = 1;
                                                      });
                                                    },
                                                    title: kPharmacy,
                                                    isSelected: endRouteId == 1,
                                                  ),
                                                DefaultWidget.selectionWidget(
                                                  onTap: (){
                                                    setState(() {
                                                      endRouteId = 2;
                                                    });
                                                  },
                                                  title: kHomeLocation,
                                                  isSelected: endRouteId == 2,
                                                ),
                                              ],
                                            ),

                                          /// For Dedicated Driver - No Address Found
                                          if (!isAddressUpdated && driverType.toLowerCase() == kDedicatedDriver.toLowerCase())
                                            Padding(
                                                padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0),
                                                child: BuildText.buildText(
                                                    text: kNoAddressProfile,
                                                    size: 10,color: AppColors.redColor
                                                )
                                            ),

                                          /// For Shred Driver - Pharmacy DropDown
                                          if (driverType.toLowerCase() == kSharedDriver.toLowerCase())
                                            Padding(
                                              padding: const EdgeInsets.only(top: 5,bottom: 5),
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(color:AppColors.whiteColor,
                                                        border: Border.all(color: Colors.grey.withOpacity(0.7)),
                                                        borderRadius: BorderRadius.circular(50.0)),
                                                    child: Padding(
                                                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                                        child: DropdownButtonHideUnderline(
                                                          child: DropdownButton<PharmacyList>(
                                                            isExpanded: true,
                                                            value: controller.selectedStartRoutePharmacy,
                                                            icon: const Icon(Icons.arrow_drop_down),
                                                            iconSize: 24,
                                                            elevation: 16,
                                                            hint: BuildText.buildText(text: kSelectPhar,color: AppColors.greyColor),
                                                            style: TextStyle(color: AppColors.blackColor),
                                                            underline: Container(
                                                              height: 2,
                                                              color: AppColors.blackColor,
                                                            ),
                                                            onChanged: (PharmacyList? newValue) {
                                                              setState(() {
                                                                controller.selectedStartRoutePharmacy = newValue;
                                                                if(controller.selectedPharmacy == null){
                                                                  controller.selectedPharmacy = newValue;
                                                                }
                                                                if (newValue?.pharmacyId == "0") {
                                                                  showEndRouteOptions = true;
                                                                } else {
                                                                  showEndRouteOptions = false;
                                                                }
                                                              });
                                                            },
                                                            items: controller.pharmacyList?.map<DropdownMenuItem<PharmacyList>>((PharmacyList value) {
                                                              return DropdownMenuItem<PharmacyList>(
                                                                  value: value,
                                                                  child: BuildText.buildText(
                                                                      text: value.pharmacyName ?? "",color: AppColors.blackColor
                                                                  )
                                                              );
                                                            }).toList(),
                                                          ),
                                                        )),
                                                  ),
                                                  Visibility(
                                                    visible: controller.selectedStartRoutePharmacy != null,
                                                    child: Positioned(
                                                      right: 5,
                                                      top: 2,
                                                      bottom: 2,
                                                      child: InkWell(
                                                        onTap: (){
                                                          setState(() {
                                                            controller.selectedStartRoutePharmacy = null;
                                                            showEndRouteOptions = true;
                                                          });
                                                        },
                                                        child: Container(
                                                          height: 40,
                                                          width: 40,
                                                          decoration: BoxDecoration(
                                                            color: AppColors.whiteColor,
                                                            border: Border.all(width: 1,color: AppColors.greyColor),
                                                            shape: BoxShape.circle
                                                          ),
                                                          child: Icon(Icons.clear,color: AppColors.greyColor,),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),


                                          /// For Shred Driver - End Route At:
                                          if (driverType.toLowerCase() == kSharedDriver.toLowerCase() && showEndRouteOptions)
                                            Padding(
                                                padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 10.0),
                                                child: BuildText.buildText(
                                                    text: kEndRouteAt,
                                                    size: 16,weight: FontWeight.w600
                                                )
                                            ),

                                          /// For Shred Driver - End Route Pharmacy DropDown:
                                          if (driverType.toLowerCase() == kSharedDriver.toLowerCase() && showEndRouteOptions)
                                            Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child: Container(
                                                decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.withOpacity(0.7)), borderRadius: BorderRadius.circular(50.0)),
                                                child: Padding(
                                                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                                    child: DropdownButtonHideUnderline(
                                                      child: DropdownButton<PharmacyList>(
                                                        isExpanded: true,
                                                        value: controller.selectedEndRoutePharmacy,
                                                        icon: const Icon(Icons.arrow_drop_down),
                                                        iconSize: 24,
                                                        elevation: 16,
                                                        hint: BuildText.buildText(text: kSelectPhar,color: AppColors.greyColor),
                                                        style: TextStyle(color: AppColors.blackColor),
                                                        underline: Container(
                                                          height: 2,
                                                          color: Colors.black,
                                                        ),
                                                        onChanged: (PharmacyList? newValue) {
                                                          setState(() {
                                                            controller.selectedEndRoutePharmacy = newValue;
                                                            if(controller.selectedPharmacy == null && newValue?.pharmacyId != "0"){
                                                              controller.selectedPharmacy = newValue;
                                                            }
                                                          });
                                                        },
                                                        items: controller.endRoutePharmacyList.map<DropdownMenuItem<PharmacyList>>((PharmacyList value) {
                                                          return DropdownMenuItem<PharmacyList>(
                                                              value: value,
                                                              child: BuildText.buildText(
                                                                text: value.pharmacyName ?? "",
                                                              )
                                                          );
                                                        }).toList(),
                                                      ),
                                                    )),
                                              ),
                                            )
                                        ],
                                      ),
                                    ),

                                     /// Select One End Route Option:
                                     Visibility(
                                          visible: isSelectAtLeastOneEndRouteMessage,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 10,right: 10),
                                            child: BuildText.buildText(text: kSelectOneEndRouteOption,color: AppColors.redColor)
                                          ),
                                        ),


                                    Padding(
                                      padding: const EdgeInsets.only(top: 25,left:20,right: 20,bottom: 15),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                              height: 35.0,
                                              width: 110.0,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.grey,
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                                ),
                                                child: BuildText.buildText(
                                                    text: kCancel,textAlign: TextAlign.center,color: AppColors.whiteColor,weight: FontWeight.bold, size: 13.0
                                                ),
                                                onPressed: () {
                                                  Get.back();
                                                },
                                              )),

                                          SizedBox(
                                              height: 35.0,
                                              width: 110.0,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.blue,
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                                ),
                                                child: BuildText.buildText(
                                                    text: !isAddressUpdated && endRouteId == 2 ?
                                                      kUpdateAddress
                                                      : (int.parse(controller.selectedStartRoutePharmacy?.pharmacyId.toString() ?? "0") > 0) ?
                                                      kContinue
                                                      : int.parse(controller.selectedEndRoutePharmacy?.pharmacyId.toString() ?? "0") > 0 ?
                                                      kContinue :kContinue,
                                                  textAlign: TextAlign.center,color: AppColors.whiteColor,weight: FontWeight.bold,
                                                ),

                                                onPressed: () async {
                                                  try{
                                                  PrintLog.printLog("Clicked on Continue::::::$isAddressUpdated");

                                                  if (driverType.toLowerCase() == kDedicatedDriver.toLowerCase()) {
                                                    PrintLog.printLog("Clicked on Continue::::::111");

                                                    if(!isAddressUpdated && endRouteId == 2 ){
                                                      Get.back();
                                                      Get.toNamed(updateAddressScreenRoute,arguments: UpdateAddressScreen(
                                                        address1: "",address2: "",postCode: "",townName: "",
                                                        userType: AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.userType),
                                                        driverName: AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.userName),
                                                      )
                                                      );
                                                    }else{
                                                      PrintLog.printLog("Clicked on Continue::ss::::");
                                                      StartOrEndRouteID data = StartOrEndRouteID();
                                                      data.startRouteID = startRouteId.toString();
                                                      data.endRouteID = endRouteId.toString();
                                                      Navigator.of(context).pop(data);
                                                    }
                                                  }else{
                                                    if(int.parse(controller.selectedStartRoutePharmacy?.pharmacyId ?? "0") > 0){

                                                      endRouteId = 3;
                                                      StartOrEndRouteID data = StartOrEndRouteID();
                                                      data.startRouteID = startRouteId.toString();
                                                      data.endRouteID = endRouteId.toString();
                                                      Navigator.of(context).pop(data);

                                                    }else if(controller.selectedEndRoutePharmacy == null){
                                                      ToastCustom.showToast(msg: kPleaseSelectEntRoute);
                                                    }else{

                                                      if (isAddressUpdated || int.parse(controller.selectedEndRoutePharmacy?.pharmacyId ?? "0") > 0) {
                                                        if (int.parse(controller.selectedEndRoutePharmacy?.pharmacyId ?? "0") > 0) {
                                                          endRouteId = 4;
                                                        } else {
                                                          endRouteId = 2;
                                                        }

                                                        StartOrEndRouteID data = StartOrEndRouteID();
                                                        data.startRouteID = startRouteId.toString();
                                                        data.endRouteID = endRouteId.toString();
                                                        Navigator.of(context).pop(data);
                                                      } else {
                                                        Get.back();
                                                        Get.toNamed(updateAddressScreenRoute,arguments: UpdateAddressScreen(
                                                          address1: "",address2: "",postCode: "",townName: "",
                                                          userType: AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.userType),
                                                          driverName: AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.userName),
                                                        )
                                                        );
                                                      }
                                                    }
                                                  }

                                                  }catch(e){
                                                    PrintLog.printLog("On Tap Error....$e");

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
                        )


                      ],
                    ),
                  ),
                ),
              ),
            ),
            isLoading: controller.isLoading,
          );
        }
    );

  }
}
