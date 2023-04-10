import 'dart:io';
import 'dart:math';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import '../../../Model/OrderDetails/detail_response.dart';
import '../../../Model/VehicleList/vehicleListResponse.dart';
import '../../../View/DashBoard/DriverDashboard/start_route_popup_screen.dart';
import '../../../View/OrderDetails/multi_delivery_list.dart';
import '../../ProjectController/DriverDashboard/driver_dashboard_ctrl.dart';
import '../../ProjectController/DriverDashboard/reschedule_pop_up.dart';
import '../Button/button.dart';
import '../Loader/LoadScreen/LoadScreen.dart';
import '../StringDefine/StringDefine.dart';
import 'CustomDialogBox.dart';
import 'common_use_popup.dart';

class PopupCustom{
  PopupCustom._privateConstructor();
  static final PopupCustom instance = PopupCustom._privateConstructor();

  static simpleTruckDialogBox({bool? isShowClearBtn, Widget? topWidget,required Function(dynamic) onValue,required BuildContext context,String ? title, subTitle, btnBackTitle, btnActionTitle,Color? titleColor,subTitleColor,btnBackColor,btnActionColor,Function()? onTapBackBtn,onTapActionBtn}){
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context1) {
          return CommonUsePopUp(
            isShowClearBtn: isShowClearBtn,
            title: title,
            topWidget: topWidget,
            subTitle: subTitle,
            titleColor: titleColor,
            btnActionColor: btnActionColor,
            btnActionTitle: btnActionTitle,
            btnBackColor: btnBackColor,
            btnBackTitle: btnBackTitle,
            onTapActionBtn: onTapActionBtn,
            onTapBackBtn: onTapBackBtn,
            subTitleColor: subTitleColor,
          );
        }).then(onValue);
  }

  static showReschedulePopUp({ required Function(dynamic) onValue,required BuildContext context,required List<String> selectedOrderIDs}){
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context1) {
          return ReschedulePopUp(selectedOrderIDs: selectedOrderIDs);
        }).then(onValue);
  }


  static simpleDialogBox({ required Function(dynamic) onValue,required BuildContext context,required String msg}){
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context1) {
          return CustomDialogBox(
            title: kAlert,
            btnDone: kOk,
            descriptions: msg,
          );
        }).then(onValue);
  }

  static endRoutePopUp({ required Function(dynamic) onValue,required BuildContext context,required Function(bool) onClicked}){
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context1) {
          return CustomDialogBox(
            img: Image.asset(strIMG_DelTruck),
            title: kAlert,
            btnDone: kEndRoute,
            btnNo: kNo,
            onClicked: onClicked,
            descriptions: kEndRouteWarning,
          );
        }).then(onValue);
  }

  static showChooseVehiclePopUp({ required Function(dynamic) onValue,required BuildContext context,required LoginController ctrl}){
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context1) {
          return ChooseVehiclePopUp(ctrl: ctrl);
        }).then(onValue);
  }

  static showMultipleDeliveryListPopUp({ required Function(dynamic) onValue,required BuildContext context,required OrderDetailResponse orderModal}){
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context1) {
          return MultipleDeliveryPopUp(orderModal: orderModal,);
        }).then(onValue);
  }

  static showAlertOrderPopUp({ Image? img,required Function(dynamic) onValue,required BuildContext context,String? title,String? btnDone,String? btnNo,required String descriptions,required Function(bool) onClicked}){
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context1) {
          return CustomDialogBox(
            img: img ?? Image.asset(strImgDelTruck),
            title: title ?? kMultipleDelivery,
            btnDone: btnDone ?? kYes,
            btnNo: btnNo ?? kNo,
            descriptions: descriptions,
            onClicked:onClicked,
          );
        }).then(onValue);
  }

  static showConfirmationDialog({ required Function(dynamic) onValue,required void Function() onPressed,required BuildContext context,}){
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context1) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Icon(Icons.warning_rounded,color: Colors.red,size: 40),
                content: BuildText.buildText(text: kAddressDifferentWouldYouStillLikeToDeliver),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          height: 35.0,
                          width: 110.0,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                              elevation: 2.0,
                              backgroundColor: Colors.white,
                            ),
                            child: BuildText.buildText(text: kCancel,textAlign: TextAlign.center,color: AppColors.greyColor,weight: FontWeight.bold,size: 13),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          )),
                      SizedBox(
                          height: 35.0,
                          width: 110.0,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                              elevation: 2.0,
                              backgroundColor: Colors.white,
                            ),
                            onPressed: onPressed,
                            child: BuildText.buildText(text: kAddNow,textAlign: TextAlign.center,color: AppColors.yetToStartColor,weight: FontWeight.bold,size: 13),
                          )),
                    ],
                  ),
                ],
              );
            },
          );
        }).then(onValue);
  }

  static confirmationPopupForStartRoute({ required Function(dynamic) onValue,required BuildContext context,required DriverDashboardCTRL ctrl}){
    return showDialog(
      context: context,
      builder: (_) {
        return StartRoutePopUp(ctrl: ctrl);
      },).then(onValue);
  }

  static Future<void> showLoadingDialogOnRouteStarting(){
    return showDialog(
      context: Get.overlayContext!,

      barrierDismissible: false,
      builder: (_) {
        return WillPopScope(
            onWillPop: () async => false,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
              insetPadding: const EdgeInsets.all(20),
              backgroundColor: Colors.transparent,
              child: Container(
                height: 260,
                padding: const EdgeInsets.only(left: 10, top: 25, right: 10, bottom: 20),
                margin: const EdgeInsets.only(top: 25),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                  BoxShadow(color: Colors.black, offset: Offset(0, 2), blurRadius: 10),
                ]),
                child: Column(
                  children: [

                    const Image(
                      image: AssetImage(strGifForRouteStart),
                      width: 150,
                    ),
                    buildSizeBox(25.0, 0.0),
                    BuildText.buildText(
                        text: kOptimizingRoute,size: 20,color: AppColors.greenColor,weight: FontWeight.w600
                    ),

                  ],
                ),
              ),
            ),
        );
      },);
  }

  static forgotPasswordPopUP({ required Function(dynamic) onValue,required BuildContext context,required LoginController ctrl}){
    return showDialog(
      context: context,
      builder: (_) {
        return ForgotPassword(ctrl: ctrl);
      },).then(onValue);
  }

  static emailSentPopUP({ required Function(dynamic) onValue,required BuildContext context,required String msg}){
    return showDialog(
      context: context,
      builder: (_) {
        return EmailSent(msg: msg);
      },).then(onValue);
  }

  static showAlertRouteStartedPopUp({required BuildContext context}){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context1) {
          return CustomDialogBox(
            img: Image.asset(strImgDelTruck),
            title: kAlert,
            btnDone: kOk,
            descriptions: kDriverAlreadyOutForDelivery,
          );
        });
  }

  static noInternetPopUp({required BuildContext context,required String msg}){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CustomDialogBox(
            img: Image.asset(strIMG_Sad),
            title: kAlert,
            btnDone: kOkay,
            btnNo: "",
            descriptions: msg,
          );
        });
  }

<<<<<<< HEAD
  static showNoInternetPopUpWhenOffline({required BuildContext context,required Function(dynamic) onValue,}){
    simpleTruckDialogBox(
        context: context,
        onValue: onValue,
      topWidget: Image.asset(strImgSad),
      btnActionTitle: kOkay,
      btnBackTitle: "",
      title: kAlert,
      subTitle: kInternetNotAvailable,
      onTapBackBtn: ()=> Get.back(),
    );
  }

  static showOnlyManualDeliveryPopUp({required BuildContext context,required Function(dynamic) onValue,}){
    simpleTruckDialogBox(
        context: context,
        onValue: onValue,
      topWidget: Image.asset(strImgSad),
      btnActionTitle: kOkay,
      btnBackTitle: "",
      title: kAlert,
      subTitle: kPleaseCompleteManually,
      onTapBackBtn: ()=> Get.back(),
    );
  }

  static orderSuccess({required BuildContext context}){
=======
 static orderSuccess({required BuildContext context}){
>>>>>>> 8b081882a3eced9002e51a19f4537178dbc5c90a
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const SuccessOrderDialog();
        });
  }

  static exitPopUp({required BuildContext context}){
    return AlertDialog(
<<<<<<< HEAD
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: BuildText.buildText(text: "Warning"),
      content: BuildText.buildText(text:"Are you sure you want to cancel all prescriptions!"),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: BuildText.buildText(text:kNo),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: BuildText.buildText(text:kYes),
        ),
      ],
    );
  }

  static userNotExistDialog({required BuildContext context,required String title,required String msg,required VoidCallback onTapNo,required VoidCallback onTapCreate}){
=======
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: BuildText.buildText(text: "Warning"),
            content: BuildText.buildText(text:"Are you sure you want to cancel all prescriptions!"),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: BuildText.buildText(text:kNo),
              ),
             TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: BuildText.buildText(text:kYes),
              ),
            ],
          );
  }

   static userNotExistDialog({required BuildContext context,required String title,required String msg,required VoidCallback onTapNo,required VoidCallback onTapCreate}){
>>>>>>> 8b081882a3eced9002e51a19f4537178dbc5c90a
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return UserNotExistDialog(
<<<<<<< HEAD
              title: title,
              msg: msg,
              onTapNo: onTapNo,
              onTapCreate: onTapCreate);
=======
            title: title, 
            msg: msg, 
            onTapNo: onTapNo, 
            onTapCreate: onTapCreate);
>>>>>>> 8b081882a3eced9002e51a19f4537178dbc5c90a
        });
  }

}



<<<<<<< HEAD

=======
>>>>>>> 8b081882a3eced9002e51a19f4537178dbc5c90a
class ForgotPassword extends StatelessWidget {
  LoginController ctrl;
  ForgotPassword({Key? key,required this.ctrl,}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
        init: ctrl,
        builder: (controller) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: LoadScreen(
              widget: Scaffold(
                backgroundColor: AppColors.blackColor.withOpacity(0.3),
                body: DelayedDisplay(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 30),
                        decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(10.0)
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            /// title
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 20,bottom: 40),
                                  child: BuildText.buildText(
                                      text: kForgotPassword,
                                      size: 22,
                                      textAlign: TextAlign.center
                                  ),
                                ),


                                /// Enter Email
                                TextFieldCustom(
                                  controller: controller.forgotEmailCT,
                                  keyboardType: TextInputType.emailAddress,
                                  maxLength: 50,
                                  radiusField: 5,
                                  isCheckOut: false,
                                  hintText: kEmail,
                                  errorText: controller.isForgotEmail
                                      ? kEnterEmail
                                      : null,
                                  onChanged:(value){
                                    if(value == " "){
                                      controller.forgotEmailCT.clear();
                                    }
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 40),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      BtnCustom.btnSmall(
                                        title: kCancel,
                                        onPressed: ()=> Get.back(),
                                      ),
                                      BtnCustom.btnSmall(
                                        title: kSubmit,
                                        titleColor: AppColors.yetToStartColor,
                                        onPressed: ()=> controller.onTapForgotPasswordSubmit(context: context),
                                      ),
                                    ],
                                  ),
                                )

                              ],
                            ),


                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              isLoading: controller.isLoading,
            ),
          );
        }
    );

  }
}


class EmailSent extends StatelessWidget {
  String msg;
  EmailSent({Key? key,required this.msg,}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor.withOpacity(0.3),
      body: DelayedDisplay(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 30),
              decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(10.0)
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  /// title
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildSizeBox(20.0, 0.0),
                      Image.asset(strImgRightClick,height:50,color: AppColors.greenColor),
                      Padding(
                        padding: const EdgeInsets.only(top: 20,bottom: 40),
                        child: BuildText.buildText(
                            text: msg,
                            size: 18,
                            textAlign: TextAlign.center
                        ),
                      ),


                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: BtnCustom.btnSmall(
                          title: kOkay,
                          titleColor: AppColors.yetToStartColor,
                          onPressed: ()=> Get.back(),
                        ),
                      )

                    ],
                  ),


                ],
              ),
            ),
          ),
        ),
      ),
    );

  }
}

<<<<<<< HEAD

class ChooseVehiclePopUp extends StatefulWidget {
  LoginController ctrl;
  ChooseVehiclePopUp({Key? key,required this.ctrl,}) : super(key: key);

  @override
  State<ChooseVehiclePopUp> createState() => _ChooseVehiclePopUpState();
}

class _ChooseVehiclePopUpState extends State<ChooseVehiclePopUp> {

  /// Use for Choose vehicle
  TextEditingController selectVehicleCT = TextEditingController();
  TextEditingController enterMilesVehicleCT = TextEditingController();
  bool isSelectVehicle = false;
  bool isEnterMiles = false;

  bool isTap = false;

  @override
  void initState() {
    clearTextField();
    super.initState();
  }

  @override
  void dispose() {
    disposeTextField();
    super.dispose();
  }

  void clearTextField(){
    selectVehicleCT.clear();
    enterMilesVehicleCT.clear();
  }
  void disposeTextField(){
    selectVehicleCT.dispose();
    enterMilesVehicleCT.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(

        init: widget.ctrl,
        builder: (controller) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: LoadScreen(
              widget: Scaffold(
                backgroundColor: AppColors.blackColor.withOpacity(0.3),
                body: DelayedDisplay(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 30),
                        decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(10.0)
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            /// Select vehicle
                            BuildText.buildText(
                                text: kChooseVehicle,
                                size: 22,
                            ),
                            buildSizeBox(10.0, 0.0),
                            Container(
                              height: 55,
                              width: Get.width,
                              margin: const EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColors.textFieldBorderColor,
                                    width: 1
                                  ),
                                  borderRadius: BorderRadius.circular(30.0)
                              ),
                              child: DropdownButtonHideUnderline(
                                child: ButtonTheme(
                                  alignedDropdown: true,
                                  padding: EdgeInsets.zero,
                                  child: DropdownButton<VehicleListData>(
                                    isExpanded: true,
                                    value: widget.ctrl.selectedVehicleData,
                                    icon: const Icon(Icons.arrow_drop_down),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: const TextStyle(color: Colors.black),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.black,
                                    ),hint: BuildText.buildText(text: kPleaseSelectVehicle),
                                    onChanged: (VehicleListData? newValue) {
                                      setState(() {
                                        widget.ctrl.selectedVehicleData = newValue;
                                      });
                                    },
                                    items: widget.ctrl.vehicleListData?.map<DropdownMenuItem<VehicleListData>>((VehicleListData value) {
                                      return DropdownMenuItem<VehicleListData>(
                                        value: value,
                                        child: Container(
                                          height: 45.0,
                                          color: Colors.primaries[Random().nextInt(Colors.primaries.length)].shade100,
                                          width: MediaQuery.of(context).size.width,
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.all(0.0),
                                            child: BuildText.buildText(
                                                text: "${value.name ?? ""}${value.modal != null ? " - ${value.modal.toString() ?? ""}"  : ""}${value.regNo != null ? " - ${value.regNo.toString() ?? ""}"  : ""}${value.color != null ? " - ${value.color.toString() ?? ""}"  : ""}".toUpperCase(),
                                            )
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),

                            buildSizeBox(30.0, 0.0),

                            /// Enter miles
                            BuildText.buildText(
                              text: kEnterMilesAndUploadPicture,
                              size: 18,
                            ),
                            buildSizeBox(10.0, 0.0),
                            TextFieldCustom(
                              controller: enterMilesVehicleCT,
                              keyboardType: TextInputType.number,
                              readOnly: false,
                              maxLength: 50,
                              isCheckOut: true,
                              hintText: kPleaseEnterStartMiles,
                              errorText: isEnterMiles ? kPleaseEnterStartMiles : null,
                              onChanged:(value){
                                if(value == " "){
                                  setState(() {
                                    enterMilesVehicleCT.clear();
                                  });
                                }
                              },
                            ),

                            buildSizeBox(20.0, 0.0),

                            /// Speedometer picture
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        CheckPermission.checkCameraPermission(context).then((value){
                                          if(value == true){
                                            controller.getSpeedometerImage(context: context).then((value) {
                                            });
                                          }
                                        });
                                      },
                                      child: SizedBox(
                                        height: 75.0,
                                        width: 75,
                                        child: Image.asset(strImgSpeedometer),
                                      ),
                                    ),

                                      Visibility(
                                        visible: controller.imagePicker?.speedometerImage != null,
                                        child: Container(
                                          width: 70.0,
                                          height: 70.0,
                                          margin: const EdgeInsets.only(left: 20.0),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8.0),
                                            child: Image.file(
                                              File(controller.imagePicker?.speedometerImage?.path ?? ""),
                                              fit: BoxFit.cover,
                                              alignment: Alignment.topCenter,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                buildSizeBox(10.0, 0.0),
                                BuildText.buildText(text: kClickImage)
                              ],
                            ),



                            /// btn
                            Padding(
                              padding: const EdgeInsets.only(top: 40),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  BtnCustom.btnSmall(
                                    title: kNo,fontSize: 20,titleColor: AppColors.blackColor,
                                    onPressed: ()=> Get.back(),
                                  ),

                                  BtnCustom.btnSmall(
                                    title: kOkay,fontSize: 20,titleColor: AppColors.blackColor,
                                    onPressed: () async {
                                      if(controller.selectedVehicleData == null || enterMilesVehicleCT.text.isEmpty) {
                                        ToastCustom.showToast(msg: kPleaseChooseVehicleEnterStartMiles);
                                      }else if(controller.imagePicker?.speedometerImage == null) {
                                        ToastCustom.showToast(msg: kTakeSpeedometerPicture);
                                      }else{
                                        print("tewsw.....$isTap");

                                        if(isTap == false) {
                                          isTap = true;
                                        //   await controller.onTapOkaySelectVehiclePopUP(
                                        //     context: context,
                                        //   startMiles: enterMilesVehicleCT.text.toString().trim(),
                                        // ).then((value) {
                                        //     isTap = false;
                                        // });
                                        }
                                      }
                                    },
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
              ),
              isLoading: controller.isLoading,
            ),
          );
        }
    );

  }
}

=======
>>>>>>> 8b081882a3eced9002e51a19f4537178dbc5c90a
class UserNotExistDialog extends StatelessWidget {
  String? title;
  String? msg;
  VoidCallback? onTapNo;
  VoidCallback? onTapCreate;
  UserNotExistDialog({Key? key,required this.title,required this.msg,required this.onTapNo,required this.onTapCreate}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
<<<<<<< HEAD
      onWillPop: () async => false,
      child: AlertDialog(
        title: BuildText.buildText(text: title ?? ""),
        content: SingleChildScrollView(
          child: ListBody(
            children:[
              BuildText.buildText(text: msg ?? ""),
            ],
          ),
        ),
        actions: [
          InkWell(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: BuildText.buildText(
                  text: 'No',
                  color: AppColors.blueColor,
                ),
              ),
              onTap: onTapNo
          ),
          InkWell(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: BuildText.buildText(
                text: 'CREATE',
                color: AppColors.blueColor,
              ),
            ),
            onTap: onTapCreate,
          ),
        ],
      ),
    );
=======
          onWillPop: () async => false,
          child: AlertDialog(
            title: BuildText.buildText(text: title ?? ""),
            content: SingleChildScrollView(
              child: ListBody(
                children:[
                  BuildText.buildText(text: msg ?? ""),
                ],
              ),
            ),
            actions: [
              InkWell(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: BuildText.buildText(
                    text: 'No',
                    color: AppColors.blueColor,
                  ),
                ),
                onTap: onTapNo
              ),
              InkWell(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: BuildText.buildText(
                    text: 'CREATE',
                    color: AppColors.blueColor,                    
                  ),
                ),
                onTap: onTapCreate,
              ),
            ],
          ),
        );
>>>>>>> 8b081882a3eced9002e51a19f4537178dbc5c90a

  }
}
