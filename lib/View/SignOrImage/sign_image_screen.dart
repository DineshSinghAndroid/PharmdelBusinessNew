import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:pharmdel/Controller/WidgetController/AppBar/app_bar.dart';
import '../../Controller/ProjectController/SignOrImage/sign_or_image_controller.dart';
import '../../Controller/WidgetController/Loader/LoadScreen/LoadScreen.dart';
import '../../Controller/WidgetController/StringDefine/StringDefine.dart';
import '../../Model/DriverDashboard/driver_dashboard_response.dart';
import '../../Model/OrderDetails/detail_response.dart';
import 'singnature_pad.dart';

class SignOrImageScreen extends StatefulWidget{
  OrderDetailResponse delivery;
  final String remarks;
  final String deliveredTo;
  int selectedStatusCode;
  List<String> orderIDs;
  List<DeliveryPojoModal> outForDelivery;
  String routeId;
  String rescheduleDate;
  String failedRemark;
  String paymentStatus;
  int exemptionId;
  String mobileNo;
  String addDelCharge;
  int subsId;
  String paymentType;
  String rxInvoice;
  String rxCharge;
  String amount;
  bool isCdDelivery;
  String notPaidReason;

  SignOrImageScreen({Key? key,
    required this.delivery,
    required this.selectedStatusCode,
    required this.remarks,
    required this.deliveredTo,
    required this.orderIDs,
    required this.outForDelivery,
    required this.routeId,
    required this.rescheduleDate,
    required this.failedRemark,
    required this.paymentStatus,
    required this.exemptionId,
    required this.mobileNo,
    required this.addDelCharge,
    required this.subsId,
    required this.paymentType,
    required this.rxInvoice,
    required this.rxCharge,
    required this.amount,
    required this.isCdDelivery,
    required this.notPaidReason,
  }) : super(key: key);

  @override
  State<SignOrImageScreen> createState() => _SignOrImageScreenState();
}

class _SignOrImageScreenState extends State<SignOrImageScreen> {

  SignOrImageController ctrl = Get.put(SignOrImageController());
  final _sign = GlobalKey<SignatureState>();

@override
  void initState() {
  PrintLog.printLog("Payment Type is: ${widget.paymentType}");
  PrintLog.printLog("Is Cd Delivery: ${widget.isCdDelivery}");
  ctrl.init(context: context,routeId: widget.routeId);
  ctrl.getLocationByClick();

    super.initState();
  }

  @override
  void dispose() {
    ctrl.imagePicker?.orderImage = null;
    ctrl.imageBase64Data = null;
    ctrl.signatureData = null;
    Get.delete<SignOrImageController>();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignOrImageController>(
      init: ctrl,
      builder: (controller) {
        return LoadScreen(
          widget:  SafeArea(
            child: Scaffold(
              appBar: AppBarCustom.appBarStyle2(
                  title: kCompleteOrder,
                centerTitle: false,
                elevation: 1,
                  size: 18,
                  backgroundColor: AppColors.blueColor,
                titleColor: AppColors.whiteColor,
              ),
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    /// Save btn
                    ButtonCustom(
                        onPress: ()=> controller.onTapSave(
                            context: context,
                            onTapActionType: kSave,
                            isCdDelivery: widget.isCdDelivery,
                            signKey: _sign,
                          routeId: widget.routeId,
                          addDelCharge: widget.addDelCharge,
                          amount: widget.amount,
                          deliveredTo: widget.deliveredTo,
                          delivery: widget.delivery,
                          exemptionId: widget.exemptionId,
                          failedRemark: widget.failedRemark,
                          mobileNo: widget.mobileNo,
                          notPaidReason: widget.notPaidReason,
                          orderIDs: widget.orderIDs,
                          outForDelivery: widget.outForDelivery,
                          paymentStatus: widget.paymentStatus,
                          paymentType: widget.paymentType,
                          remarks: widget.remarks,
                          rescheduleDate: widget.rescheduleDate,
                          rxCharge: widget.rxCharge,
                          rxInvoice: widget.rxInvoice,
                          selectedStatusCode: widget.selectedStatusCode,
                          subsId: widget.subsId
                        ),
                      radius: 5,
                        text: kSave,
                        buttonWidth: 100,
                        buttonHeight: 50,
                      backgroundColor: AppColors.blueColor,
                    ),

                    /// Skip btn
                    Visibility(
                      visible: !widget.isCdDelivery || widget.isCdDelivery && widget.selectedStatusCode != 5,
                      child: ButtonCustom(
                        onPress: ()=> controller.onTapSave(
                            context: context,
                            onTapActionType: kSkip,
                            isCdDelivery: widget.isCdDelivery,
                            signKey: _sign,
                            routeId: widget.routeId,
                            addDelCharge: widget.addDelCharge,
                            amount: widget.amount,
                            deliveredTo: widget.deliveredTo,
                            delivery: widget.delivery,
                            exemptionId: widget.exemptionId,
                            failedRemark: widget.failedRemark,
                            mobileNo: widget.mobileNo,
                            notPaidReason: widget.notPaidReason,
                            orderIDs: widget.orderIDs,
                            outForDelivery: widget.outForDelivery,
                            paymentStatus: widget.paymentStatus,
                            paymentType: widget.paymentType,
                            remarks: widget.remarks,
                            rescheduleDate: widget.rescheduleDate,
                            rxCharge: widget.rxCharge,
                            rxInvoice: widget.rxInvoice,
                            selectedStatusCode: widget.selectedStatusCode,
                            subsId: widget.subsId
                        ),
                        text: kSkip,
                        buttonWidth: 100,
                        buttonHeight: 50,
                        radius: 5,
                        backgroundColor: AppColors.greenColor,
                      ),
                    ),

                    /// Cd sign is Mandatory
                    Visibility(
                      visible: widget.isCdDelivery && widget.selectedStatusCode == 5,
                        child: Flexible(
                            child: BuildText.buildText(text: kCdSignIsMandatory,textAlign: TextAlign.center)
                        )
                    ),

                    /// Clear btn
                    Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(width: 2,color: AppColors.greyColor.withOpacity(0.5))
                      ),
                      child: ButtonCustom(
                        onPress: ()=> controller.onTapClear(currentState: _sign.currentState),
                        text: kClear,radius: 5,
                        textColor: AppColors.blackColor,
                        buttonWidth: 100,
                        buttonHeight: 48,
                        backgroundColor: AppColors.whiteColor,
                      ),
                    ),

                  ],
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                child: Column(
                  children: [
                    buildSizeBox(10.0, 0.0),

                    /// For Image
                    Visibility(
                      visible: true,
                        child: Card(
                          elevation: 3.0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                          child: Container(
                            height: widget.isCdDelivery || widget.selectedStatusCode == 5 ? 250 : 500,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(5.0)),
                            child: Stack(
                              children: <Widget>[

                                /// Image
                                controller.imagePicker?.orderImage != null
                                    ? SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Image.file(
                                        File(controller.imagePicker?.orderImage?.path ?? ""),
                                        fit: BoxFit.fill,
                                        // alignment: Alignment.topCenter,
                                      ),
                                    )
                                    : const SizedBox.shrink(),

                                /// On Tap Camera
                                Padding(
                                  padding: const EdgeInsets.only(right: 5.0),
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: ButtonTheme(
                                      height: 45,
                                      child: InkWell(
                                        onTap: ()=> controller.getImage(context: context),
                                        child: const Icon(Icons.camera_alt,color: Colors.blue,size: 40),
                                      ),
                                    ),
                                  ),
                                ),

                                /// Heading
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(5.0),
                                      topRight: Radius.circular(5.0),
                                    ),
                                    color: AppColors.whiteColor,
                                  ),
                                  width: Get.width,
                                  child: Padding(
                                      padding: const EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
                                      child: BuildText.buildText(
                                        text: kImageOptional,
                                        size: 17,
                                      )
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ),
                    buildSizeBox(10.0, 0.0),

                    /// For Customer Signature
                    Visibility(
                      visible: widget.isCdDelivery || widget.selectedStatusCode == 5 ? true : false,
                      child: Expanded(
                        child: Card(
                          elevation: 3.0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Colors.black12,
                            ),
                            child: Stack(
                              children: [

                                Signature(
                                  color: AppColors.redColor,
                                  key: _sign,
                                  onSign: () {
                                    final sign = _sign.currentState;
                                    // debugPrint('${sign.points.length} points in the signature');
                                  },
                                  // backgroundPainter: _WatermarkPaint("2.0", "2.0"),
                                  strokeWidth: 5.0,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(5.0),
                                      topRight: Radius.circular(5.0),
                                    ),
                                    color: AppColors.whiteColor,
                                  ),
                                  child: Padding(
                                      padding: const EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
                                      child: BuildText.buildText(
                                          text: kCustomerSignature,
                                          size: 17
                                      )
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),


                  ],
                ),
              ),
            ),
          ),
          isLoading: controller.isLoading,
        );
      },
    );
  }
}