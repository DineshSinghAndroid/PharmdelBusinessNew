import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/Helper/Colors/custom_color.dart';
import 'package:pharmdel/Controller/Helper/Shared%20Preferences/SharedPreferences.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import '../../Controller/ProjectController/BulkDrop/bulk_drop_controller.dart';
import '../../Controller/WidgetController/Loader/LoadScreen/LoadScreen.dart';
import '../../Controller/WidgetController/StringDefine/StringDefine.dart';


class BulkDeliveryListScreen extends StatefulWidget {
  const BulkDeliveryListScreen({Key? key}) : super(key: key);

  @override
  State<BulkDeliveryListScreen> createState() => _BulkDeliveryListScreenState();
}

class _BulkDeliveryListScreenState extends State<BulkDeliveryListScreen> {

  BulkDropController bulkCTRL = Get.put(BulkDropController());



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  void init() {
    if (bulkCTRL.toController.text.toString().trim() == "") {
      bulkCTRL.toController.text = "Patient";
    }

    bulkCTRL.routeId = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.routeID) ?? "";
    bulkCTRL.scanBarcodeNormal(context: context);
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<BulkDropController>(
      init: bulkCTRL,
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async => false,
          child: LoadScreen(
            widget: Scaffold(
              backgroundColor: AppColors.whiteColor,
              appBar: AppBar(
                elevation: 0.5,
                backgroundColor: AppColors.materialAppThemeColor,
                leading: InkWell(
                  onTap: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: AppColors.blackColor,
                  ),
                ),
                title: BuildText.buildText(text: kBulkDrop,),

                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: AppColors.colorOrange,
                      child: BuildText.buildText(text: controller.orderList.length.toString() ?? "0",),
                    ),
                  )
                ],
              ),
              floatingActionButton: Container(
                margin: const EdgeInsets.only(bottom: 50),
                child: FloatingActionButton(
                    backgroundColor: Colors.orange,
                    onPressed: ()=> controller.onTapScanOrder(context: context),
                    child: Icon(Icons.add,color: AppColors.whiteColor)
                ),
              ),
              bottomNavigationBar: Visibility(
                visible: controller.orderList.isNotEmpty,
                child: Container(
                  margin: const EdgeInsets.only(left: 13,right: 13,bottom: 5),
                  height: 40,
                  width: 110,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        elevation: 2.0,
                        backgroundColor: AppColors.blueColor,
                      ),
                      onPressed: () => controller.onTapComplete(context: context,controller: controller),
                      child: BuildText.buildText(
                          text: kComplete,
                          color: AppColors.whiteColor,
                          size: 16,weight: FontWeight.w700
                      )
                  ),
                ),
              ),
              body: Container(
                height: Get.height,
                width: Get.width,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(strImgHomeBg),
                    alignment: Alignment.bottomCenter,
                    fit: BoxFit.fill
                  )
                ),
                child: controller.orderList.isNotEmpty
                    ? Container(
                        margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 60),
                        child: ListView.builder(
                          physics: const ClampingScrollPhysics(),
                            itemCount: controller.orderList.length ?? 0,
                            itemBuilder: (context, index) {
                              return Card(
                                margin: EdgeInsets.only(
                                  bottom: controller.orderList.length - 1 == index ? 70.0 : 8.0,
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 5,
                                      right: 5,
                                      child: InkWell(
                                        onTap: ()=> controller.onTapRemoveOrder(index: index),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: AppColors.redColor.withOpacity(0.4),
                                              borderRadius: BorderRadius.circular(50.0)
                                          ),
                                          child: Icon( Icons.close,color: AppColors.whiteColor,size: 17),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Flexible(
                                          fit: FlexFit.tight,
                                          flex: 1,
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              children: <Widget>[
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Flexible(
                                                      child:
                                                          BuildText.buildText(
                                                              text: "${controller.orderList[index].fullName}",
                                                            maxLines: 2,color: AppColors.blackColor.withOpacity(0.8),weight: FontWeight.w700
                                                          )
                                                    ),

                                                      Visibility(
                                                        visible: controller.orderList[index].pmrType != null && (controller.orderList[index].pmrType == "titan" || controller.orderList[index].pmrType == "nursing_box") && controller.orderList[index].prId != null && controller.orderList[index].prId.toString().isNotEmpty,
                                                        child: BuildText.buildText(
                                                            text: '(P/N : ${controller.orderList[index].prId ?? ""}) ',
                                                            color: AppColors.pnColor
                                                        ),
                                                      )
                                                  ],
                                                ),
                                                buildSizeBox(5.0, 5.0),

                                                Row(
                                                  children: <Widget>[
                                                    Image.asset(strImgHomeIcon, height: 18, width: 18, color: AppColors.yetToStartColor),
                                                    buildSizeBox(0.0, 5.0),

                                                    Flexible(
                                                      child:
                                                      BuildText.buildText(
                                                          text: controller.orderList[index].fullAddress ?? controller.orderList[index].fullAddress ?? "",
                                                          maxLines: 3,color: AppColors.blackColor.withOpacity(0.8),weight: FontWeight.w300,size: 15
                                                      )
                                                    ),
                                                      Visibility(
                                                        visible: controller.orderList.isNotEmpty && controller.orderList != null && controller.orderList[index].altAddress != null && controller.orderList[index].altAddress != "" && controller.orderList[index].altAddress == "t",
                                                          child: Image.asset(strImgAltAdd,height: 18,width: 18)
                                                      )
                                                  ],
                                                ),
                                                buildSizeBox(5.0, 0.0),

                                                controller.orderList[index].deliveryNotes != null && controller.orderList[index].deliveryNotes != ""
                                                    ? Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    BuildText.buildText(
                                                        text: "$kDeliveryNote:   ",color: AppColors.yetToStartColor,
                                                    ),
                                                    Flexible(
                                                        child: BuildText.buildText(text: controller.orderList[index].deliveryNotes ?? "")
                                                    ),
                                                  ],
                                                )
                                                    : const SizedBox.shrink(),
                                                buildSizeBox(5.0, 0.0),

                                                Row(
                                                  children: [
                                                    controller.orderList[index].isControlledDrugs != null && controller.orderList[index].isControlledDrugs != false
                                                        ? Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5.0),
                                                            color: AppColors.drugColor,
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 2.0, bottom: 2.0),
                                                            child: BuildText.buildText(text: "C.D.",size: 10,color: AppColors.whiteColor)
                                                          ),
                                                        )
                                                        : const SizedBox.shrink(),
                                                    if (controller.orderList[index].isControlledDrugs != null && controller.orderList[index].isControlledDrugs != false)
                                                      buildSizeBox(0.0, 10.0),

                                                    controller.orderList[index].isStorageFridge != null && controller.orderList[index].isStorageFridge != false
                                                        ? Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(5.0),
                                                        color: AppColors.fridgeColor,
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 2.0, bottom: 2.0),
                                                        child: BuildText.buildText(text: kFridge,size: 10,color: AppColors.whiteColor)
                                                      ),
                                                    )
                                                        : const SizedBox.shrink(),
                                                  ],
                                                ),
                                                if (controller.orderList != null && controller.orderList.isNotEmpty && controller.orderList[index].parcelBoxName != null && controller.orderList[index].parcelBoxName != "")
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 0.0, bottom: 5.0, top: 5.0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          decoration: BoxDecoration(border: Border.all(color: Colors.red), borderRadius: BorderRadius.circular(5.0)),
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left: 3.0, right: 3.0, top: 2.0, bottom: 2.0),
                                                            child: BuildText.buildText(text: controller.orderList[index].parcelBoxName ?? "",size: 10,color: AppColors.pickedUp)
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                      )
                    : Align(
                          alignment: Alignment.center,
                          child: BuildText.buildText(
                              text: kPleaseScanOrderNow,
                              color: AppColors.greyColor.withOpacity(0.6),
                              size: 20
                          )
                      ),
              ),
            ),
            isLoading: controller.isLoading,
          ),
        );
      },
    );
  }







/* void showOrderList(OrderModal modal, bool otherDelivery) {
    List<ReletedOrders> modelList = [];

    if (!otherDelivery) {
      modal.related_orders.forEach((element) {
        if (modal.customerId == element.userId) {
          modelList.add(element);
        }
      });
    } else {
      modelList = modal.related_orders;
    }
    if (modelList.length == 0) {
    } else {
      bool allSelected = false;
      showDialog(
          context: context,
          barrierDismissible: false, // user must tap button for close dialog!
          builder: (context) {
            return SafeArea(
              child: Container(
                color: Colors.transparent,
                margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                child: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                  return Scaffold(
                    body: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width - 0,
                          padding: EdgeInsets.all(10.00),
                          color: Colors.blue,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Orders List",
                                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Icon(
                                    Icons.clear_rounded,
                                    color: Colors.red,
                                  ))
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Checkbox(
                                value: allSelected,
                                onChanged: (value) {
                                  allSelected = value;
                                  for (int i = 0; i < modelList.length; i++) {
                                    modelList[i].isSelected = value;
                                  }
                                  setState(() {});
                                }),
                            Flexible(
                              child: Text(
                                "Select All",
                                style: TextStyle(fontSize: 12, color: Colors.blue),
                              ),
                            )
                          ],
                        ),
                        Container(
                          color: Colors.white,
                          height: MediaQuery.of(context).size.height - 250,
                          child: ListView.builder(
                            // physics: NeverScrollableScrollPhysics(),
                              itemCount: modelList.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  margin: EdgeInsets.only(
                                    bottom: modelList.length - 1 == index ? 70.0 : 8.0,
                                  ),
                                  child: Stack(
                                    children: [
                                      Row(
                                        children: <Widget>[
                                          Flexible(
                                            fit: FlexFit.tight,
                                            flex: 1,
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      /*Text("Name", style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 14
                                                      ),),
                                                      SizedBox(width: 5, height: 0,),*/
                                                      SizedBox(
                                                        height: 24,
                                                        width: 24,
                                                        child: Checkbox(
                                                            value: modelList[index].isSelected,
                                                            onChanged: (value) {
                                                              modelList[index].isSelected = value;
                                                              allSelected = true;
                                                              for (int i = 0; i < modelList.length; i++) {
                                                                if (modelList[i].isSelected == false) {
                                                                  allSelected = false;
                                                                }
                                                              }
                                                              setState(() {});
                                                            }),
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          "${modelList[index].fullName ?? ""}",
                                                          maxLines: 2,
                                                          style: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                      if (modelList[index].pmr_type != null && (modelList[index].pmr_type == "titan" || modelList[index].pmr_type == "nursing_box") && modelList[index].pr_id != null && modelList[index].pr_id.isNotEmpty)
                                                        Text(
                                                          '(P/N : ${modelList[index].pr_id ?? ""}) ',
                                                          style: TextStyle(color: CustomColors.pnColor),
                                                        ),
                                                      if (modelList[index].isCronCreated == "t") Image.asset("assets/automatic_icon.png", height: 14, width: 14),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Image.asset("assets/home_icon.png", height: 18, width: 18, color: CustomColors.yetToStartColor),
                                                      SizedBox(
                                                        width: 5,
                                                        height: 0,
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          "${modelList[index].fullAddress ?? modelList[index].fullAddress ?? ""}",
                                                          style: TextStyle(color: Colors.black87, fontSize: 15, fontWeight: FontWeight.w300),
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 1,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5.0,
                                                  ),
                                                  modelList[index].deliveryNotes != null && modelList[index].deliveryNotes != ""
                                                      ? Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Delivery Note:   ',
                                                        style: TextStyle(fontSize: 14, color: CustomColors.yetToStartColor),
                                                      ),
                                                      Flexible(child: Text(modelList[index].deliveryNotes ?? "")),
                                                    ],
                                                  )
                                                      : SizedBox(),
                                                  modelList[index].existing_delivery_notes != null && modelList[index].existing_delivery_notes != ""
                                                      ? Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Existing Note:   ',
                                                        style: TextStyle(fontSize: 14, color: CustomColors.yetToStartColor),
                                                      ),
                                                      Flexible(child: Text(modelList[index].existing_delivery_notes ?? "")),
                                                    ],
                                                  )
                                                      : SizedBox(),
                                                  SizedBox(
                                                    height: 5.0,
                                                  ),
                                                  Container(
                                                    child: Row(
                                                      children: [
                                                        modelList[index].isControlledDrugs != null && modelList[index].isControlledDrugs != false
                                                            ? Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5.0),
                                                            color: CustomColors.drugColor,
                                                            // border: Border.all(color: Colors.blue)
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 2.0, bottom: 2.0),
                                                            child: Text(
                                                              "C.D.",
                                                              style: TextStyle(fontSize: 10, color: Colors.white),
                                                            ),
                                                          ),
                                                        )
                                                            : Container(),
                                                        if (modelList[index].isControlledDrugs != null && modelList[index].isControlledDrugs != false)
                                                          SizedBox(
                                                            width: 10.0,
                                                          ),
                                                        modelList[index].isStorageFridge != null && modelList[index].isStorageFridge != false
                                                            ? Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5.0),
                                                            color: CustomColors.fridgeColor,
                                                            // border: Border.all(color: Colors.blue)
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 2.0, bottom: 2.0),
                                                            child: Text(
                                                              "Fridge",
                                                              style: TextStyle(fontSize: 10, color: Colors.white),
                                                            ),
                                                          ),
                                                        )
                                                            : Container(),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ),
                        SizedBox(
                          height: 40,
                          width: MediaQuery.of(context).size.width - 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                              elevation: 2.0,
                              backgroundColor: Colors.blue,
                            ),
                            onPressed: () {
                              int count = modelList.where((elements) => elements.isSelected == true).toList().length;
                              if (count > 0) {
                                Navigator.of(context).pop();
                                addMultiOrders(modelList);
                              } else {
                                Fluttertoast.showToast(msg: "Select minimum 1 order");
                              }
                            },
                            child: new Text(
                              "Complete",
                              style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w700),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }),
              ),
            );
          });
    }
  }



  void redirectNextScreen() {
    if (!isDeliveryNote) {
      Fluttertoast.showToast(msg: "Check C.D., Fridge and Delivery note");
      return;
    }
    if (modelList.isEmpty) {
      return;
    }
    List orderId = [];

    modelList.forEach((element) {
      orderId.add(element.orderId.toString());
    });
    int index = modelList.indexWhere((element) => element.isControlledDrugs == true);
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ClickImage(
              delivery: null,
              routeId: routeId,
              isCdDelivery: index != null && index >= 0 ? modelList[index].isControlledDrugs : false,
              selectedStatusCode: 5,
              remarks: "${remarkController.text}",
              deliveredTo: "${toController.text}",
              orderid: orderId,
            )));
  }

  void showConfirmationDialog(OrderModal modal) {
    BuildContext dialogContext;
    Widget cancelButton = SizedBox(
        height: 35.0,
        width: 110.0,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            elevation: 2.0,
            backgroundColor: Colors.white,
          ),
          child: Text(
            'Cancel',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 13.0),
          ),
          onPressed: () {
            Navigator.of(dialogContext).pop(true);
          },
        ));
    Widget continueButton = SizedBox(
        height: 35.0,
        width: 110.0,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            elevation: 2.0,
            backgroundColor: Colors.white,
          ),
          child: Text(
            'Add Now',
            textAlign: TextAlign.center,
            style: TextStyle(color: yetToStartColor, fontWeight: FontWeight.bold, fontSize: 13.0),
          ),
          onPressed: () {
            if (modal.related_orders != null && modal.related_orders.isNotEmpty) {
              Navigator.of(dialogContext).pop(true);
              modelList.add(modal.related_orders[0]);
              setState(() {});
            }
          },
        ));
    // set up the AlertDialog
    var alert = StatefulBuilder(
      builder: (context, setState) {
        dialogContext = context;
        return AlertDialog(
          title: Icon(
            Icons.warning_rounded,
            color: Colors.red,
            size: 40,
          ),
          content: Text("Address is different  !!!\nWould you still like to deliver?"),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                cancelButton,
                continueButton,
              ],
            ),
          ],
        );
      },
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void addMultiOrders(List<ReletedOrders> modelList1) {
    modelList1.forEach((modal) {
      if (modal.isSelected) if (modelList.length > 0) {
        int isAlreadyExits = modelList.indexWhere((element) => element.orderId == modal.orderId);
        if (isAlreadyExits < 0 && modal.isSelected) {
          modelList.add(modal);
        }
      } else
        modelList.add(modal);
    });
    setState(() {});
  }

  */

}
