import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Controller/Helper/Redirect/redirect.dart';
import '../../Controller/ProjectController/OrderDetails/order_detail_controller.dart';
import '../../Controller/WidgetController/Loader/LoadScreen/LoadScreen.dart';
import '../../Controller/WidgetController/StringDefine/StringDefine.dart';
import '../../Model/OrderDetails/detail_response.dart';
import '../../Model/ParcelBox/parcel_box_response.dart';

class OrderDetailScreen extends StatefulWidget{
  OrderDetailResponse orderDetail;
  OrderDetailScreen({Key? key,required this.orderDetail}) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenScreenState();
}

class _OrderDetailScreenScreenState extends State<OrderDetailScreen> {

  OrderDetailController orderCtrl = Get.put(OrderDetailController());

  @override
  void initState() {
    orderCtrl.init(context: context,orderDetailResponse: widget.orderDetail);
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<OrderDetailController>();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderDetailController>(
      init: orderCtrl,
      builder: (controller) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: LoadScreen(
            widget: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                  backgroundColor: AppColors.materialAppThemeColor,
                  title: FittedBox(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: widget.orderDetail.nursingHomeId == null || widget.orderDetail.nursingHomeId == "0" || widget.orderDetail.nursingHomeId == "" ?
                        BuildText.buildText(
                            text: 
                            "$kOrderID : ${controller.orderIDs.isNotEmpty ? controller.orderIDs[0].toString() : ""}",
                          size: 16
                        ):
                        BuildText.buildText(
                            text:
                            "$kNursingHomeID : ${widget.orderDetail.nursingHomeId.toString() ?? ""}",
                            size: 16
                        )
                      )),
                  titleSpacing: 0,
                  leading: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop("back");
                    },
                    child: Icon(Icons.arrow_back,color: AppColors.blackColor),
                  )
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      /// Patient list
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child:
                        controller.newRelatedOrders.isNotEmpty && controller.newRelatedOrders.length == 1 ?
                            /// For Single User's
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              /// Patient Details Heading
                              Row(
                                children: [

                                  Icon(Icons.person_outline,color: AppColors.yetToStartColor),
                                  buildSizeBox(0.0, 8.0),

                                  /// Patient Details
                                  BuildText.buildText(text: kPatientDetails,size: 16,color: AppColors.yetToStartColor),

                                  const Spacer(),

                                  if (widget.orderDetail.parcelName != null && widget.orderDetail.parcelName.toString().isNotEmpty && widget.orderDetail.deliveryStatusDesc.toString().toLowerCase() == kOutForDelivery.toLowerCase())
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10.0, bottom: 5.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(border: Border.all(color: Colors.red), borderRadius: BorderRadius.circular(5.0)),
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 3.0, right: 3.0, top: 2.0, bottom: 2.0),
                                              child: BuildText.buildText(
                                                  text: widget.orderDetail.parcelName.toString().length > 8 ? widget.orderDetail.parcelName.toString().substring(0, 8) : widget.orderDetail.parcelName ?? "",
                                                size: 10,color: AppColors.pickedUp
                                              )
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                              buildSizeBox(5.0, 0.0),

                              /// Full Name
                              Padding(
                                padding: const EdgeInsets.only(left: 28.0),
                                child: FittedBox(
                                  child: BuildText.buildText(
                                      text: widget.orderDetail.customer?.fullName ?? "",
                                      weight: FontWeight.bold
                                  )
                                ),
                              ),
                              buildSizeBox(5.0, 0.0),

                              /// Full Address
                              Padding(
                                padding: const EdgeInsets.only(left: 31.0),
                                child: Row(
                                  children: [

                                    Expanded(
                                      flex: 8,
                                      child: BuildText.buildText( text: widget.orderDetail.customer?.fullAddress ?? "",)
                                    ),
                                    buildSizeBox(5.0, 0.0),

                                    Visibility(
                                        visible: widget.orderDetail.customer?.altAddress.toString().toLowerCase() == "t",
                                          child: Image.asset(strImgAltAdd,height: 18,width: 18)
                                      ),
                                    buildSizeBox(0.0, 5.0),

                                    /// Location Map Launch
                                    Expanded(
                                      flex: 1,
                                      child: InkWell(
                                        onTap: () async {

                                          if (widget.orderDetail.customer?.latitude != null) {
                                            MapsLauncher.launchQuery(widget.orderDetail.customer?.fullAddress ?? widget.orderDetail.customer?.fullAddress ?? "");
                                          } else if (widget.orderDetail.customer?.address != null) {
                                            MapsLauncher.launchQuery(widget.orderDetail.customer?.fullAddress ?? widget.orderDetail.customer?.fullAddress ?? "");
                                          } else {
                                            ToastCustom.showToast(msg: "Address not found");
                                          }

                                        },
                                        child: Image.asset(strImgMap,height: 30,width: 30),
                                      ),
                                    ),

                                  ],
                                ),
                              ),

                              /// Mobile Number
                              Visibility(
                                visible: widget.orderDetail.customer?.mobile != null && widget.orderDetail.customer!.mobile!.isNotEmpty && widget.orderDetail.customer?.mobile != "" && widget.orderDetail.customer?.mobile != "null",
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      buildSizeBox(5.0, 0.0),
                                      Row(
                                        children: [

                                          Padding(
                                            padding: const EdgeInsets.only(left: 30.0),
                                            child: BuildText.buildText(
                                                text: widget.orderDetail.customer?.mobile ?? "",
                                              textAlign: TextAlign.left
                                            )
                                          ),
                                          buildSizeBox(0.0, 15.0),

                                          /// Edit Phone
                                          Visibility(
                                            visible: controller.selectedDeliveryStatus.toLowerCase() == kCompleted.toLowerCase(),
                                              child: InkWell(
                                                onTap: ()=> controller.onTapEditMobile(context: context),
                                                child: const Icon(Icons.edit),
                                              ),
                                          ),
                                          const Spacer(),

                                          /// Redirect
                                          InkWell(
                                              onTap: () {
                                                RedirectCustom.makePhoneCall(phoneNumber: widget.orderDetail.customer?.mobile ?? "");
                                              },
                                              child: CircleAvatar(
                                                  backgroundColor: AppColors.greenColor,
                                                  radius: 15.0,
                                                  child: Icon(Icons.call,color: AppColors.whiteColor,size: 22)
                                              )
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                              ),

                              /// Mobile Number Text Field
                              Visibility(
                                visible: controller.isUpdateMobile && controller.selectedDeliveryStatus.toLowerCase() == kCompleted.toLowerCase() ,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      buildSizeBox(5.0, 0.0),
                                      Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: TextFieldSimple(
                                          controller: controller.mobileController,
                                          textInputAction: TextInputAction.next,
                                          keyboardType: TextInputType.number,
                                          maxLength: 12,
                                          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                          autofocus: false,
                                          labelText: kUpdateMobileNumber,

                                        ),
                                      ),
                                    ],
                                  )
                              ),

                              /// Delivery Note
                              Visibility(
                                  visible: controller.newRelatedOrders.isNotEmpty && controller.newRelatedOrders[0].deliveryNotes.toString() != "" && controller.newRelatedOrders[0].deliveryNotes != "null" && controller.newRelatedOrders[0].deliveryNotes != null,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                            padding: const EdgeInsets.only(left: 30.0),
                                            child: BuildText.buildText(
                                                text: kDeliveryNote,size: 16,color: AppColors.yetToStartColor
                                            )
                                        ),
                                      Padding(
                                          padding: const EdgeInsets.only(left: 30.0),
                                          child: BuildText.buildText(
                                              text: controller.newRelatedOrders[0].deliveryNotes ?? "",
                                              size: 14,
                                              color: AppColors.blueDeliveryNoteColor
                                          )
                                      ),
                                      buildSizeBox(5.0, 0.0),

                                    ],
                                  )
                              ),

                              /// Existing Delivery Note
                              Visibility(
                                  visible: controller.newRelatedOrders.isNotEmpty && controller.newRelatedOrders[0].existingDeliveryNotes.toString() != "" && controller.newRelatedOrders[0].existingDeliveryNotes.toString() != "null" && controller.newRelatedOrders[0].existingDeliveryNotes != null,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                              padding: const EdgeInsets.only(left: 30.0,right: 5),
                                              child: BuildText.buildText(
                                                  text: kExistingNoteWithDoted,size: 16,color: AppColors.yetToStartColor
                                              )
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 2),
                                              child: BuildText.buildText(
                                                  text: controller.newRelatedOrders[0].existingDeliveryNotes.toString().trim() ?? "",
                                                  size: 14,
                                                  maxLines: 5,
                                                  color: AppColors.blueDeliveryNoteColor
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      buildSizeBox(5.0, 0.0),

                                    ],
                                  )
                              ),

                            ],
                          ),
                        )
                        /// For Multiple User's
                        : Container(
                              padding: const EdgeInsets.all(4),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [

                                  /// Patient Details Heading
                                  InkWell(
                                    onTap: ()=> controller.onTapMultiPatientHeadingTap(context: context),
                                    child: Row(
                                      children: [

                                        Icon(Icons.person_outline,color: AppColors.yetToStartColor),
                                        buildSizeBox(0.0, 8.0),

                                        /// Patient Details
                                        BuildText.buildText(text: kPatientDetails,size: 16,color: AppColors.yetToStartColor),

                                        const Spacer(),

                                        Icon(controller.isExpanded ? Icons.keyboard_arrow_up_sharp : Icons.keyboard_arrow_down_sharp,color: AppColors.yetToStartColor,size: 25,),
                                      ],
                                    ),
                                  ),

                                  Visibility(
                                    visible: controller.isExpanded,
                                      child: ListView.separated(
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemCount: controller.newRelatedOrders.length ?? 0,
                                          separatorBuilder: (BuildContext context, int index) {
                                            return const Padding(
                                              padding: EdgeInsets.only(bottom: 5),
                                            ) ;
                                          },
                                          itemBuilder: (context,i){
                                            return Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(5),
                                                  ),
                                                clipBehavior: Clip.antiAlias,
                                                child: Container(
                                                  color: AppColors.whiteColor,
                                                  padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [

                                                      /// Full Name
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 0.0),
                                                        child: Row(
                                                          children: [
                                                            Flexible(
                                                                child: BuildText.buildText(
                                                                    text: controller.newRelatedOrders[i].fullName ?? "",
                                                                    weight: FontWeight.bold
                                                                )
                                                            ),

                                                            if(controller.newRelatedOrders[i].nursingHomeId == null || controller.newRelatedOrders[i].nursingHomeId == "null" || controller.newRelatedOrders[i].nursingHomeId == "0" || controller.newRelatedOrders[i].nursingHomeId == "")
                                                              Visibility(
                                                                visible: controller.newRelatedOrders[i].pmrType != null && controller.newRelatedOrders[i].pmrType != "" && (controller.newRelatedOrders[i].pmrType?.toLowerCase() == "titan".toLowerCase() || controller.newRelatedOrders[i].pmrType?.toLowerCase() == "nursing_box".toLowerCase()) && controller.newRelatedOrders[i].prId != null && controller.newRelatedOrders[i].prId.toString().isNotEmpty,
                                                                  child: BuildText.buildText(
                                                                      text: '(P/N : ${controller.newRelatedOrders[i].prId ?? ""}) ',color: AppColors.pnColor
                                                                  )
                                                              ),
                                                            Visibility(
                                                                visible: controller.newRelatedOrders[i].isCronCreated?.toLowerCase() == "t",
                                                                child: Image.asset(strImgAutomaticIcon,height: 14,width: 14,)
                                                            )

                                                          ],
                                                        ),
                                                      ),
                                                      buildSizeBox(5.0, 0.0),

                                                      /// Full Address
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 0.0),
                                                        child: Row(
                                                          children: [
                                                            Image.asset(strImgHomeIcon,height: 20,width: 20,color: AppColors.yetToStartColor,),
                                                            buildSizeBox(0.0, 5.0),
                                                            Expanded(
                                                                flex: 8,
                                                                child: BuildText.buildText( text: controller.newRelatedOrders[i].fullAddress ?? "",)
                                                            ),
                                                            buildSizeBox(5.0, 0.0),

                                                            Visibility(
                                                                visible: controller.newRelatedOrders[i].altAddress.toString().toLowerCase() == "t",
                                                                child: Image.asset(strImgAltAdd,height: 18,width: 18)
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      /// Delivery Note
                                                      Visibility(
                                                          visible: controller.newRelatedOrders[i].deliveryNotes != null && controller.newRelatedOrders[i].deliveryNotes.toString() != "" && controller.newRelatedOrders[i].deliveryNotes.toString() != "null",
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [

                                                              Padding(
                                                                  padding: const EdgeInsets.only(top: 5.0),
                                                                  child: BuildText.buildText(
                                                                      text: kDeliveryNote,size: 16,color: AppColors.yetToStartColor
                                                                  )
                                                              ),

                                                              Padding(
                                                                  padding: const EdgeInsets.only(left: 0.0),
                                                                  child: BuildText.buildText(
                                                                      text: controller.newRelatedOrders[i].deliveryNotes ?? "",
                                                                      size: 14,
                                                                      color: AppColors.blueDeliveryNoteColor
                                                                  )
                                                              ),
                                                              buildSizeBox(5.0, 0.0),

                                                            ],
                                                          )
                                                      ),

                                                      /// Existing Delivery Note
                                                      Visibility(
                                                          visible: controller.newRelatedOrders[i].existingDeliveryNotes != null && controller.newRelatedOrders[i].existingDeliveryNotes.toString() != "" && controller.newRelatedOrders[i].existingDeliveryNotes.toString() != "null",
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Padding(
                                                                  padding: const EdgeInsets.only(top: 5.0),
                                                                  child: BuildText.buildText(
                                                                      text: kExistingNoteWithDoted,size: 16,color: AppColors.yetToStartColor
                                                                  )
                                                              ),
                                                              BuildText.buildText(
                                                                  text: controller.newRelatedOrders[i].existingDeliveryNotes.toString().trim() ?? "",
                                                                  size: 14,
                                                                  color: AppColors.blueDeliveryNoteColor
                                                              ),
                                                              buildSizeBox(5.0, 0.0),

                                                            ],
                                                          )
                                                      ),

                                                      /// Cd Or Fridge
                                                      Row(
                                                        children: [
                                                          Visibility(
                                                              visible: controller.newRelatedOrders[i].isControlledDrugs == true,
                                                              child: DefaultWidget.cdWidget()
                                                          ),
                                                          buildSizeBox(0.0, 10.0),
                                                          Visibility(
                                                              visible: controller.newRelatedOrders[i].isStorageFridge == true,
                                                              child: DefaultWidget.fridgeWidget()
                                                          ),
                                                        ],
                                                      )

                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                      )
                                  )

                                ],
                              ),
                            )

                      ),

                      /// Select order list
                      Container(
                        height: 30,
                        margin: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.selectOrderStatus.length ?? 0,
                          itemBuilder: (context, index) {
                            return DefaultWidget.orderStatusChangeRadioBtnWidget(
                              isSelected: controller.selectedRadioBtn == index,
                                title: controller.selectOrderStatus[index] ?? "",
                                onTap: ()=> controller.onChangeRadioBtnStatus(value:index ),
                                activeColor: controller.selectedDeliveryStatus.toLowerCase() == kCompleted.toLowerCase() || controller.selectedDeliveryStatus.toLowerCase() == kUnpick.toLowerCase()
                                    ? Colors.green
                                    : controller.selectedDeliveryStatus.toLowerCase() == kFailed.toLowerCase() || controller.selectedDeliveryStatus.toLowerCase() == kCancel.toLowerCase()
                                    ? Colors.red
                                    : Colors.green,
                                containerColor: controller.selectOrderStatus[index].toLowerCase() == kCompleted.toLowerCase() || controller.selectOrderStatus[index].toLowerCase() == kUnpick.toLowerCase()
                                    ? Colors.green
                                    : controller.selectOrderStatus[index].toLowerCase() == kFailed.toLowerCase() || controller.selectOrderStatus[index].toLowerCase() == kCancel.toLowerCase()
                                    ? Colors.red
                                    : Colors.green,
                            );
                          },
                        ),
                      ),

                        /// Reschedule radio btn
                        Visibility(
                          visible: controller.selectedDeliveryStatus.toLowerCase() == "Failed1".toLowerCase(),
                          child: Row(
                            children: [
                              Checkbox(
                                visualDensity: const VisualDensity(vertical: -4.0),
                                activeColor: AppColors.yetToStartColor,
                                value: controller.isCheked,
                                onChanged: (bool? value) {
                                  setState(() {
                                    controller.isCheked = value ?? false;
                                  });
                                },
                              ),
                              BuildText.buildText(
                                  text: kRescheduleDelivery,
                              ),
                            ],
                          ),
                        ),

                        /// On Tap Calender
                        Visibility(
                          visible: controller.isCheked,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4.0, right: 4.0, top: 5.0),
                            child: InkWell(
                              onTap: ()=> controller.openTapCalender(context: context),
                              child: Container(
                                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                width: MediaQuery.of(context).size.width,
                                height: 50.0,
                                decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(50.0)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(controller.selectedDate ?? ""),
                                    const Icon(Icons.calendar_today_rounded,size: 20.0)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                      widget.orderDetail.nursingHomeId == null || widget.orderDetail.nursingHomeId == "0" || widget.orderDetail.nursingHomeId == "" ?
                      Visibility(
                            visible: controller.selectedDeliveryStatus == "PickedUp" && controller.driverDasCTRL.parcelBoxList != null && controller.driverDasCTRL.parcelBoxList!.isNotEmpty,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(50.0)),
                                child: Padding(
                                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        isExpanded: true,
                                        hint: BuildText.buildText(text: kParcelLocation,color: AppColors.greyColor),
                                        value: controller.selectedParcelDropdownValue,
                                        items: controller.driverDasCTRL.parcelBoxList?.map<DropdownMenuItem<ParcelBoxData>>((ParcelBoxData parcelBoxList) {
                                          return DropdownMenuItem<ParcelBoxData>(
                                            value: parcelBoxList,
                                            child: Text("${parcelBoxList.name}", overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black87)),
                                          );
                                        }).toList(),
                                        onChanged: (ParcelBoxData? newValue) {
                                          setState(() {
                                            controller.selectedParcelDropdownValue = newValue;
                                          });
                                        },
                                      ),
                                    )),
                              ),
                            ),
                          ) : const SizedBox.shrink(),

                      Form(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            buildSizeBox(5.0, 0.0),

                            /// Delivery to
                              Visibility(
                                visible: controller.selectedStatusCode == 5 && controller.selectedDeliveryStatus.toLowerCase() != "Failed".toLowerCase(),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4,right: 4,top: 4,bottom: 10),
                                  child:  TextFieldSimple(
                                    controller: controller.toController,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.text,
                                    maxLength: 100,
                                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                    autofocus: false,
                                    labelText: kDeliveryTo,
                                  ),
                                ),
                              ),

                              /// Delivery remark
                              Visibility(
                                visible: controller.selectedStatusCode == 5 && controller.selectedDeliveryStatus.toLowerCase() != "Failed".toLowerCase(),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4,right: 4,top: 4,bottom: 10),
                                  child:  TextFieldSimple(
                                    controller: controller.remarkController,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.text,
                                    maxLength: 200,
                                    autofocus: false,
                                    labelText: kDeliveryRemark,
                                  ),
                                ),
                              ),



                            if (widget.orderDetail.nursingHomeId == null || widget.orderDetail.nursingHomeId == "0" || widget.orderDetail.nursingHomeId == "")
                              if (controller.selectedStatusCode == 5)
                                if (widget.orderDetail.customer?.mobile == null || widget.orderDetail.customer!.mobile!.isEmpty )

                                    Visibility(
                                      visible: controller.selectedDeliveryStatus.toLowerCase() != kFailed.toLowerCase(),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                                            child: BuildText.buildText(text: kUpdateCustomerMobileNumber)
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 4,right: 4,top: 4,bottom: 10),
                                            child: TextFieldSimple(
                                              controller: controller.mobileController,
                                              textInputAction: TextInputAction.next,
                                              keyboardType: TextInputType.number,
                                              maxLength: 12,
                                              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                              autofocus: false,
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(50.0),
                                                borderSide: BorderSide(color: AppColors.redColor),
                                              ),
                                              labelText: kMobileNumber,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            /// Delivery Charge or Rx Charge
                            Row(
                              children: [
                                /// Delivery Charge
                                  Visibility(
                                    visible: controller.selectedStatusCode == 5 && controller.deliveryChargeController.text.isNotEmpty && controller.deliveryChargeController.text != '0' && controller.deliveryChargeController.text != '0.0' && controller.selectedDeliveryStatus.toLowerCase() != "Failed".toLowerCase(),
                                    child: Flexible(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 10.0),
                                        child: TextFieldSimple(
                                          controller: controller.deliveryChargeController,
                                          textInputAction: TextInputAction.next,
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(color: AppColors.blueColor),
                                          autofocus: false,
                                          readOnly: true,
                                          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})'))],
                                          onChanged: (val) {
                                            controller.calculateAmount(orderDetailResponse: widget.orderDetail);
                                          },
                                          labelText: kDeliveryCharge,
                                         outlineBorderColor: AppColors.blueColor,
                                        ),
                                      ),
                                    ),
                                  ),

                                /// RX Charge
                                Visibility(
                                  visible: controller.selectedStatusCode == 5 && controller.preChargeController.text.isNotEmpty && controller.preChargeController.text != '0' && controller.preChargeController.text != '0.0' && controller.selectedDeliveryStatus.toLowerCase() != "Failed".toLowerCase(),
                                  child: Flexible(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 4.0),
                                      child: TextFieldSimple(
                                        controller: controller.preChargeController,
                                        textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.number,
                                        style: TextStyle(color: AppColors.greenColor),
                                        autofocus: false,
                                        readOnly: true,
                                        inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                        onChanged: (val) {
                                          controller.calculateAmount(orderDetailResponse: widget.orderDetail);
                                        },
                                        prefix: Text("${controller.charge == 0.0 || controller.charge.toStringAsFixed(0) == "0" ? widget.orderDetail.rxCharge : controller.charge} x "),
                                        labelText: kRxCharge,
                                        outlineBorderColor: AppColors.greenColor,
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ],
                        ),
                      ),


                        /// Failed remark list
                        Visibility(
                          visible: controller.selectedDeliveryStatus.toLowerCase() == "Failed".toLowerCase(),
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.failedRemarkList.length,
                            itemBuilder: (context, index) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Radio(
                                    value: index,
                                    groupValue: controller.selectedFailedRemarkID,
                                    visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                    onChanged: (int? val) {
                                      setState(() {
                                        controller.selectedFailedRemarkID = val ?? 0;
                                        PrintLog.printLog(controller.failedRemarkList[controller.selectedFailedRemarkID ?? 0]);
                                      });
                                    },
                                  ),
                                  BuildText.buildText(text: controller.failedRemarkList[index]),
                                ],
                              );
                            },
                          ),
                        ),


                      /// Failed Other remark TextField
                        Visibility(
                          visible: controller.failedRemarkList[controller.selectedFailedRemarkID].toLowerCase() == "Others".toLowerCase() && controller.selectedDeliveryStatus.toLowerCase() == "Failed".toLowerCase(),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: TextFieldSimple(
                              controller: controller.otherController,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.text,
                              autofocus: false,
                              labelText: kOther,
                            ),
                          ),
                        ),

                      /// Read Delivery or Customer Notes
                      Row(
                        children: <Widget>[
                          (widget.orderDetail.deliveryNote == "false" || widget.orderDetail.deliveryNote == "f" || widget.orderDetail.deliveryNote == '') && (widget.orderDetail.exitingNote == "false" || widget.orderDetail.exitingNote == "f" || widget.orderDetail.exitingNote == null ||widget.orderDetail.exitingNote =='' )
                              ? Container(height: 1,width: 1,color: Colors.red,)
                              : Padding(
                                padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5, bottom: 10),
                                child: DefaultWidget.fridgeWidgetWithCheckBox(
                                  isSelected: controller.isDeliveryNote,
                                  bgColor: AppColors.greyColor.withOpacity(0.5),
                                  onTap: (){
                                    setState(() {
                                      controller.isDeliveryNote = !controller.isDeliveryNote;
                                    });
                                  },
                                  title: kReadDeliveryNotes,
                                ),
                                // Container(
                                //   height: 30,
                                //   decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(50.0),
                                //     color: AppColors.greyColorLight,
                                //     // border: Border.all(color: Colors.blue)
                                //   ),
                                //   child: Row(
                                //     mainAxisSize: MainAxisSize.min,
                                //     children: [
                                //
                                //       Checkbox(
                                //         onChanged: (checked) {
                                //           setState(() {
                                //             controller.isDeliveryNote = checked ?? false;
                                //           });
                                //         },
                                //         value: controller.isDeliveryNote,
                                //         checkColor: Colors.white,
                                //         activeColor: Colors.blue,
                                //       ),
                                //       buildSizeBox(0.0, 2.0),
                                //
                                //       Flexible(
                                //         child: BuildText.buildText(
                                //             text: kReadDeliveryNotes,size: 12,color: AppColors.greyColor
                                //         )
                                //       ),
                                //     ],
                                //   ),
                                // ),
                              ),

                          widget.orderDetail.customer?.customerNote == null || widget.orderDetail.customer?.customerNote == "" || widget.orderDetail.customer?.customerNote == "false" || widget.orderDetail.customer?.customerNote == "f"
                              ? const SizedBox.shrink()
                              : Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 2.0,right: 15.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Checkbox(
                                        onChanged: (checked) {
                                          setState(() {
                                            controller.isCustomerNote = checked ?? false;
                                          });
                                        },
                                        value: controller.isCustomerNote,
                                        checkColor: Colors.white,
                                        activeColor: Colors.blue,
                                      ),
                                      buildSizeBox(0.0, 2.0),

                                      Flexible(
                                          child: BuildText.buildText(
                                              text: kReadCustomerNotes,size: 12,color: AppColors.greyColor
                                          )
                                      ),
                                    ],
                                  ),
                                ),
                              ),


                        ],
                      ),

                      /// Select cd, Fridge etc
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          widget.orderDetail.isStorageFridge == null || widget.orderDetail.isStorageFridge == false ?
                              const SizedBox.shrink()
                          : Flexible(
                             flex: 1,
                             fit: FlexFit.tight,
                             child: Padding(
                                 padding: const EdgeInsets.only(left: 5.0,right: 5.0,),
                                 child: DefaultWidget.fridgeWidgetWithCheckBox(
                                     isSelected: controller.isFridgeNote,
                                     onTap: (){
                                         setState(() {
                                           controller.isFridgeNote = !controller.isFridgeNote;
                                         });
                                     },
                                   title: "${widget.orderDetail.totalStorageFridge != null && widget.orderDetail.totalStorageFridge != "0" ? widget.orderDetail.totalStorageFridge : ""} Fridge",
                                 ),
                             ),
                           ),

                          widget.orderDetail.isControlledDrugs == null || widget.orderDetail.isControlledDrugs == false ?
                          const SizedBox.shrink()
                              :  Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 2.0,right: 5.0,),
                                  child: DefaultWidget.cdWidgetWithCheckBox(
                                    isSelected: controller.isControlledDrugs,
                                    onTap: (){
                                      setState(() {
                                        controller.isControlledDrugs = !controller.isControlledDrugs;
                                      });
                                    },
                                    title: "${widget.orderDetail.totalControlledDrugs != null && widget.orderDetail.totalControlledDrugs != "0" ? widget.orderDetail.totalControlledDrugs : ""} Controlled Drugs",
                                  ),
                                ),
                              ),

                          widget.orderDetail.customer?.controlNote == null || widget.orderDetail.customer?.controlNote == false ?
                          const SizedBox.shrink()
                              : Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 2.0,right: 5.0,),
                                    child: DefaultWidget.cdWidgetWithCheckBox(
                                      isSelected: controller.isControlNote,
                                      onTap: (){
                                        setState(() {
                                          controller.isControlNote = !controller.isControlNote;
                                        });
                                      },
                                      title: "CD",
                                    ),
                                  ),
                                ),
                        ],
                      ),
                      buildSizeBox(5.0, 0.0),



                      /// Show exempt bottom sheet or Bag size
                        Visibility(
                          visible: widget.orderDetail.nursingHomeId == null || widget.orderDetail.nursingHomeId == "0" || widget.orderDetail.nursingHomeId == "",
                          child: Row(
                            children: [

                                Visibility(
                                  visible: widget.orderDetail.exemption != null && widget.orderDetail.exemption!.isNotEmpty,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Container(
                                      height: 30,
                                      padding: const EdgeInsets.only(right: 5, left: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50.0),
                                        color: AppColors.greenColor,
                                      ),
                                      child: Row(
                                        children: [


                                            Visibility(
                                              visible: controller.selectedExemptions?.id != "2",
                                              child: BuildText.buildText(
                                                  text: "Exempt ${controller.selectedExemptions != null && controller.selectedExemptions?.serialId != null && controller.selectedExemptions!.serialId!.isNotEmpty ? ": ${controller.selectedExemptions?.serialId}" : ""}",
                                                color: AppColors.whiteColor
                                              ),
                                            ),

                                            Visibility(
                                              visible: controller.selectedExemptions?.id == "2",
                                              child: BuildText.buildText(
                                                  text: "Exempt ",
                                                  color: AppColors.whiteColor
                                              ),
                                            ),
                                           buildSizeBox(0.0, 5.0),

                                            /// Show exempt bottom sheet
                                            Visibility(
                                              visible: controller.selectedDeliveryStatus.toLowerCase() == kCompleted.toLowerCase() && widget.orderDetail.exemptions.isNotEmpty,
                                              child: InkWell(
                                                onTap: () {
                                                  BottomSheetCustom.showSelectExemptBottomSheet(
                                                      controller: controller,
                                                      context: context,
                                                      orderDetail: widget.orderDetail,
                                                    onValue: (value){
                                                        if(value != null) {
                                                          setState(() {
                                                          controller.selectedExemptions = value;
                                                        });
                                                        }
                                                    },
                                                  );
                                                },
                                                child: const Icon(Icons.edit,color: Colors.white),
                                              ),
                                            )

                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                /// Bag size
                                Visibility(
                                  visible: widget.orderDetail.bagSize != null && widget.orderDetail.bagSize!.isNotEmpty,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Container(
                                      height: 30,
                                      padding: const EdgeInsets.only(right: 10, left: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50.0),
                                        color: Colors.green,
                                      ),
                                      child: Row(
                                        children: [
                                          BuildText.buildText(
                                              text: "Bag Size : ${widget.orderDetail.bagSize}",
                                            color: AppColors.whiteColor
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                      if (widget.orderDetail.nursingHomeId == null || widget.orderDetail.nursingHomeId == "0" || widget.orderDetail.nursingHomeId == "")
                        if (controller.selectedDeliveryStatus == "Completed")
                          (controller.deliveryChargeController.text.isEmpty || controller.deliveryChargeController.text == '0' || controller.deliveryChargeController.text == '0.0') && (controller.preChargeController.text.isEmpty || controller.preChargeController.text == '0' || controller.preChargeController.text == '0.0') ?
                          const SizedBox.shrink()
                              : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0, top: 15.0),
                                      child: BuildText.buildText(text: kPaymentType,size: 17,weight: FontWeight.w500)
                                    ),
                                    SizedBox(
                                      height: 30.0,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        physics: const ClampingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: controller.paymentTypeList.length,
                                        itemBuilder: (context, index) {
                                          return Row(
                                            children: [
                                              Radio(
                                                  value: controller.selectedPaymentType,
                                                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                                  groupValue: index,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      controller.selectedPaymentType = index;
                                                    });
                                                  }
                                                  ),
                                              BuildText.buildText(text: controller.paymentTypeList[index]),
                                              buildSizeBox(0.0, 10.0)
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0, top: 15.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      BuildText.buildText(
                                          text: kAmount,size: 17,weight: FontWeight.w500
                                      ),
                                      buildSizeBox(5.0, 0.0),
                                      BuildText.buildText(
                                          text: "£ ${controller.totalAmount}",
                                          size: 15,
                                          weight: FontWeight.w500
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                        /// Comment Controller
                        Visibility(
                          visible: controller.paymentTypeList[controller.selectedPaymentType] == "Not paid",
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 4.0, top: 4.0),
                            child: TextFieldSimple(
                              controller: controller.commentController,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.text,
                              autofocus: false,
                              onChanged: (val) {},
                              labelText: kComment,
                            ),
                          ),
                        ),

                      if (widget.orderDetail.nursingHomeId == null || widget.orderDetail.nursingHomeId == "0" || widget.orderDetail.nursingHomeId == "")
                        /// Multi order id's
                          Visibility(
                            visible: controller.orderIDs.length > 1,
                            child: Container(
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                              decoration: BoxDecoration(color: AppColors.greyColorLight, border: Border.all(color: AppColors.greyColor), borderRadius: BorderRadius.circular(50.0)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  BuildText.buildText(text: 'Note : Multiple order completed of below id\'s ',size: 12,color: AppColors.redColor),
                                  buildSizeBox(5.0, 0.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      BuildText.buildText(text: 'Order ID :  ',size: 12),
                                      Expanded(
                                        child: Wrap(
                                          alignment: WrapAlignment.start,
                                          direction: Axis.horizontal,
                                          children: List.generate(
                                              controller.orderIDs.length, (i) {
                                            return Padding(
                                              padding: const EdgeInsets.only(top: 0.0,left: 5.0,right: 0.0),
                                              child: BuildText.buildText(text: "${controller.orderIDs[i] ?? ""}, " ,color: AppColors.blueColor,size: 12),
                                            );
                                          }),
                                        ),
                                      ),
                                    ],
                                  ),

                                ],
                              ),
                            ),
                          ),


                      Padding(
                          padding: const EdgeInsets.only(left: 0, right: 0, top: 40, bottom: 10),
                          child:  SizedBox(
                            width: Get.width,
                            height: 45,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                              onPressed: () => controller.onTapUpdateStatus(context: context,orderDetailResponse: widget.orderDetail),
                              child: BuildText.buildText(
                                  text: kUpdateStatus,color: AppColors.whiteColor
                              )
                            ),
                          )),
                    ],
                  ),
                ),
              )
            ),
            isLoading: controller.isLoading,
          ),
        );
      },
    );
  }

}