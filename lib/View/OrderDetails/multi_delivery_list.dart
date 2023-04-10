import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import '../../../Model/OrderDetails/detail_response.dart';
import '../../Controller/WidgetController/StringDefine/StringDefine.dart';



class MultipleDeliveryPopUp extends StatefulWidget {
  OrderDetailResponse orderModal;
  MultipleDeliveryPopUp({Key? key,required this.orderModal}) : super(key: key);

  @override
  State<MultipleDeliveryPopUp> createState() => _MultipleDeliveryPopUpState();
}

class _MultipleDeliveryPopUpState extends State<MultipleDeliveryPopUp> {

  bool isAllSelected = false;
  List<RelatedOrders> selectedRelatedOrders = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 20),
          decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(10.0)
          ),
          child: Scaffold(
            appBar: AppBar(
              leading: BuildText.buildText(
                  text: kOrdersList, size: 16,weight: FontWeight.w600
              ),
              leadingWidth: getWidthRatio(value: 50),
              backgroundColor: AppColors.whiteColor,
              elevation: 0,
              actions: [
                InkWell(
                  onTap: (){
                    Navigator.of(context).pop(false);
                  }, child: Container(
                  height: 50,
                  width: 70,
                  color: Colors.transparent,
                  alignment: Alignment.topRight,
                  child:  Icon(Icons.clear,color: AppColors.blackColor,),
                ),
                )
              ],
            ),
            bottomNavigationBar: ButtonCustom(
              onPress: () {

                // selectedRelatedOrders.clear();
                if(widget.orderModal.relatedOrders != null && widget.orderModal.relatedOrders!.isNotEmpty) {
                  bool isSelected = widget.orderModal.relatedOrders!.any((element) => element.isSelected == true);
                  if(isSelected){
                    Navigator.of(context).pop(true);
                    // widget.orderModal.relatedOrders?.forEach((element) {
                    //   if(element.isSelected) {
                    //     selectedRelatedOrders.add(element);
                    //   }
                    // });
                  }else{
                    ToastCustom.showToast(msg: kSelectOrderToastString,);
                  }
                }


              },
              text: kComplete,
              buttonWidth: Get.width,
              buttonHeight: 50,
              backgroundColor: AppColors.blueColor,
            ),
            body: Column(
              children: [
                Row(
                  children: [
                    Checkbox(
                        value: isAllSelected,
                        activeColor: AppColors.yetToStartColor,
                        onChanged: (value) {
                          onTapSelectAllMultipleDeliveries();
                        }
                    ),
                    InkWell(
                      onTap: (){
                        onTapSelectAllMultipleDeliveries();
                      },
                      child: BuildText.buildText(
                          text: isAllSelected ? kUnSelectAll:kSelectAll,
                          color: AppColors.blueColor
                      ),
                    )
                  ],
                ),

                Expanded(
                  child: ListView.separated(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 70),
                      itemCount: widget.orderModal.relatedOrders?.length ?? 0,
                      separatorBuilder: (BuildContext context, int index) {
                        return const Padding(
                          padding: EdgeInsets.only(bottom: 5),
                        ) ;
                      },
                      itemBuilder: (context,i){
                        return Card(

                          child: Stack(
                            children: [
                              Row(
                                children: <Widget>[
                                  Flexible(
                                    fit: FlexFit.tight,
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        children: <Widget>[

                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[

                                              /// CheckBox
                                              SizedBox(
                                                height: 24,
                                                width: 24,
                                                child: Checkbox(
                                                    value:  widget.orderModal.relatedOrders?[i].isSelected,
                                                    activeColor: AppColors.yetToStartColor,
                                                    onChanged: (value) {
                                                      onTapSingleSelection(index: i,relatedOrders: widget.orderModal.relatedOrders ?? []);
                                                    }
                                                ),
                                              ),

                                              /// Full Name
                                              Flexible(
                                                  child: InkWell(
                                                    onTap: (){
                                                      onTapSingleSelection(index: i,relatedOrders: widget.orderModal.relatedOrders ?? []);
                                                    },
                                                    child: BuildText.buildText(
                                                        text: widget.orderModal.relatedOrders?[i].fullName ?? "",
                                                        maxLines: 2,weight: FontWeight.w700
                                                    ),
                                                  )
                                              ),
                                              /// Pr ID
                                              if (widget.orderModal.relatedOrders?[i].nursingHomeId == null || widget.orderModal.relatedOrders?[i].nursingHomeId == "0" || widget.orderModal.relatedOrders?[i].nursingHomeId == "")
                                                if (widget.orderModal.relatedOrders?[i].pmrType != null &&
                                                    (widget.orderModal.relatedOrders?[i].pmrType?.toLowerCase() == "titan" || widget.orderModal.relatedOrders?[i].pmrType?.toLowerCase() == "nursing_box") &&
                                                    widget.orderModal.relatedOrders?[i].prId != null && widget.orderModal.relatedOrders![i].prId.toString().isNotEmpty)
                                                  BuildText.buildText(
                                                      text: '(P/N : ${widget.orderModal.relatedOrders?[i].prId ?? ""}) ',
                                                      color: AppColors.pnColor
                                                  ),

                                              /// Is CronCreated
                                              Visibility(
                                                  visible: widget.orderModal.relatedOrders?[i].isCronCreated?.toLowerCase() == "t",
                                                  child: Image.asset(strImgAutomaticIcon, height: 14, width: 14)
                                              ),
                                            ],
                                          ),
                                          buildSizeBox(5.0, 5.0),

                                          /// Full Address
                                          Row(
                                            children: <Widget>[
                                              Image.asset(strImgHomeIcon, height: 18, width: 18, color: AppColors.yetToStartColor),
                                              buildSizeBox(0.0, 5.0),
                                              Flexible(
                                                child: BuildText.buildText(
                                                    text: widget.orderModal.relatedOrders?[i].fullAddress ?? widget.orderModal.relatedOrders?[i].fullAddress ?? "",
                                                    size: 15,weight: FontWeight.w300,overflow: TextOverflow.ellipsis, maxLines: 1
                                                ),
                                              ),
                                              buildSizeBox(0.0, 5.0),

                                            ],
                                          ),
                                          buildSizeBox(5.0, 0.0),

                                          /// Is Exi...Delivery Notes
                                          Visibility(
                                            visible: widget.orderModal.relatedOrders?[i].existingDeliveryNotes != null && widget.orderModal.relatedOrders?[i].existingDeliveryNotes != "" && widget.orderModal.relatedOrders?[i].existingDeliveryNotes != "null",
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    BuildText.buildText(
                                                        text: "$kExistingDeliveryNote:  ",
                                                        size: 15,color: AppColors.yetToStartColor, maxLines: 1
                                                    ),
                                                    Flexible(
                                                      child: BuildText.buildText(
                                                        text: widget.orderModal.relatedOrders?[i].existingDeliveryNotes ?? "",
                                                        size: 15,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                buildSizeBox(5.0, 0.0),
                                              ],
                                            ),
                                          ),

                                          /// Is Delivery Notes
                                          Visibility(
                                            visible: widget.orderModal.relatedOrders?[i].deliveryNotes != null && widget.orderModal.relatedOrders?[i].deliveryNotes != "" && widget.orderModal.relatedOrders?[i].deliveryNotes != "null",
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    BuildText.buildText(
                                                        text: "$kDeliveryNote:  ",
                                                        size: 15,color: AppColors.yetToStartColor, maxLines: 1
                                                    ),
                                                    Flexible(
                                                      child: BuildText.buildText(
                                                        text: widget.orderModal.relatedOrders?[i].deliveryNotes ?? "",
                                                        size: 15,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                buildSizeBox(5.0, 0.0),
                                              ],
                                            ),
                                          ),


                                          /// CD, Fridge or Parcel Name
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              /// Is CD
                                              Visibility(
                                                visible: widget.orderModal.relatedOrders?[i].isControlledDrugs != null && widget.orderModal.relatedOrders?[i].isControlledDrugs != false,
                                                child: Container(
                                                  margin: const EdgeInsets.only(right: 10.0),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5.0),
                                                    color: AppColors.drugColor,
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 2.0, bottom: 2.0),
                                                    child: BuildText.buildText(
                                                        text: "C.D.",
                                                        size: 10,color: AppColors.whiteColor
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              /// Is Fridge
                                              Visibility(
                                                visible: widget.orderModal.relatedOrders?[i].isStorageFridge != null && widget.orderModal.relatedOrders?[i].isStorageFridge != false,
                                                child: Container(
                                                  margin: const EdgeInsets.only(right: 10.0),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5.0),
                                                    color: AppColors.fridgeColor,
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 2.0, bottom: 2.0),
                                                    child: BuildText.buildText(
                                                        text: kFridge,
                                                        size: 10,color: AppColors.whiteColor
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              ///  Pharmacy name
                                              Visibility(
                                                visible: widget.orderModal.relatedOrders?[i].pharmacyName != null && widget.orderModal.relatedOrders?[i].pharmacyName != "" && widget.orderModal.relatedOrders?[i].pharmacyName != "null" && driverType.toLowerCase() == kSharedDriver.toLowerCase(),
                                                child: Flexible(
                                                  flex: 5,
                                                  child: Container(
                                                    margin: const EdgeInsets.only(right: 10.0),
                                                    decoration: BoxDecoration(border: Border.all(color: AppColors.redColor), borderRadius: BorderRadius.circular(5.0)),
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 3.0, right: 3.0, top: 2.0, bottom: 2.0),
                                                      child: BuildText.buildText(
                                                          text:widget.orderModal.relatedOrders?[i].pharmacyName ?? "",
                                                          size: 10,color: AppColors.pickedUp
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),


                                              /// Parcel box name
                                              Visibility(
                                                visible: widget.orderModal.relatedOrders?[i].parcelBoxName != null && widget.orderModal.relatedOrders?[i].parcelBoxName != "" && widget.orderModal.relatedOrders?[i].parcelBoxName != "null",
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [

                                                    Container(
                                                      decoration: BoxDecoration(border: Border.all(color: Colors.red), borderRadius: BorderRadius.circular(5.0)),
                                                      margin: const EdgeInsets.only(top: 5),
                                                      padding: const EdgeInsets.only(left: 3.0, right: 3.0, top: 2.0, bottom: 2.0),
                                                      child: BuildText.buildText(
                                                          text:widget.orderModal.relatedOrders?[i].parcelBoxName ?? "",
                                                          size: 10,color: AppColors.pickedUp
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                            ],
                                          ),

                                          buildSizeBox(8.0, 0.0),

                                          /// Delivery Charge
                                          Visibility(
                                            visible: widget.orderModal.relatedOrders?[i].delCharge != null && widget.orderModal.relatedOrders?[i].delCharge != "" && widget.orderModal.relatedOrders?[i].delCharge != "null" && widget.orderModal.relatedOrders?[i].delCharge.toString() != "0",
                                            child: Row(
                                              children: [
                                                Flexible(
                                                  flex: 1,
                                                  child: SizedBox(
                                                    height: 50,
                                                    width: Get.width,
                                                    child: Stack(
                                                      // fit: StackFit.expand,
                                                      children: [

                                                        Container(
                                                          height: Get.height,
                                                          width: Get.width,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(width: 1,color: AppColors.readyColor,),
                                                              borderRadius: BorderRadius.circular(50)
                                                          ),
                                                          margin: const EdgeInsets.only(top: 5),
                                                          padding: const EdgeInsets.only(left: 22,right: 15),
                                                          alignment: Alignment.centerLeft,
                                                          child: BuildText.buildText(
                                                              text: widget.orderModal.relatedOrders?[i].delCharge.toString() ?? "0.00",
                                                              color: AppColors.readyColor,weight: FontWeight.w500
                                                          ),
                                                        ),
                                                        Positioned(
                                                          top: 0,
                                                          left: 0,
                                                          child: Container(
                                                            height: 15,
                                                            width: 80,
                                                            padding: const EdgeInsets.only(left: 5),
                                                            margin: const EdgeInsets.only(left: 20),
                                                            color: AppColors.whiteColor,
                                                            child: BuildText.buildText(
                                                                text: kDeliveryCharge,
                                                                color: AppColors.readyColor,
                                                                weight: FontWeight.w500,
                                                                size: 10
                                                            ),
                                                          ),
                                                        ),

                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: widget.orderModal.relatedOrders?[i].rxCharge != null && widget.orderModal.relatedOrders?[i].rxCharge != "" && widget.orderModal.relatedOrders?[i].rxCharge != "null" && (widget.orderModal.relatedOrders?[i].rxCharge != null && widget.orderModal.relatedOrders?[i].rxCharge != "null" && widget.orderModal.relatedOrders?[i].rxCharge != "" ? (double.parse(widget.orderModal.relatedOrders?[i].rxCharge.toString() ?? "0.0") * (widget.orderModal.relatedOrders?[i].rxInvoice != null && widget.orderModal.relatedOrders?[i].rxInvoice != "null" && widget.orderModal.relatedOrders?[i].rxInvoice != "" ? double.parse(widget.orderModal.relatedOrders?[i].rxInvoice.toString() ?? "0.0") : 0.0)).toStringAsFixed(2) :"" ).toString() != "0.00",
                                                  child: Flexible(
                                                    flex: 1,
                                                    child: SizedBox(
                                                      height: 50,
                                                      width: Get.width,
                                                      child: Stack(
                                                        // fit: StackFit.expand,
                                                        children: [

                                                          Container(
                                                            height: Get.height,
                                                            width: Get.width,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(width: 1,color: AppColors.greenColor,),
                                                                borderRadius: BorderRadius.circular(50)
                                                            ),
                                                            margin: const EdgeInsets.only(top: 5,left: 5),
                                                            padding: const EdgeInsets.only(left: 20,right: 15),
                                                            alignment: Alignment.centerLeft,
                                                            child: BuildText.buildText(
                                                                text: widget.orderModal.relatedOrders?[i].rxCharge != null && widget.orderModal.relatedOrders?[i].rxCharge != "null" && widget.orderModal.relatedOrders?[i].rxCharge != "" ? (double.parse(widget.orderModal.relatedOrders?[i].rxCharge.toString() ?? "0.0") * (widget.orderModal.relatedOrders?[i].rxInvoice != null && widget.orderModal.relatedOrders?[i].rxInvoice != "null" && widget.orderModal.relatedOrders?[i].rxInvoice != "" ? double.parse(widget.orderModal.relatedOrders?[i].rxInvoice.toString() ?? "0.0") : 0.0)).toStringAsFixed(2) :"",
                                                                // double.parse(widget.orderModal.relatedOrders?[i].delCharge.toString() ?? "").toStringAsFixed(2),
                                                                color: AppColors.greenColor,weight: FontWeight.w500
                                                            ),
                                                          ),
                                                          Positioned(
                                                            top: 0,
                                                            left: 0,
                                                            child: Container(
                                                              height: 15,
                                                              width: 60,
                                                              padding: const EdgeInsets.only(left: 5),
                                                              margin: const EdgeInsets.only(left: 20),
                                                              color: AppColors.whiteColor,
                                                              child: BuildText.buildText(
                                                                  text: kRxCharge,
                                                                  color: AppColors.greenColor,
                                                                  weight: FontWeight.w500,
                                                                  size: 10
                                                              ),
                                                            ),
                                                          ),

                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
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
                      }
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

  }

  /// Use For Multiple deliveries
  Future<void> onTapSelectAllMultipleDeliveries()async{

    if(widget.orderModal.relatedOrders != null && widget.orderModal.relatedOrders!.isNotEmpty){
      if(isAllSelected){
        widget.orderModal.relatedOrders?.forEach((element) {
          element.isSelected = false;
        });
        isAllSelected = false;
      }else{
        widget.orderModal.relatedOrders?.forEach((element) {
          element.isSelected = true;
        });
        isAllSelected = true;
      }
    }
    setState(() {});
  }

  /// On Tap Single Selection
  Future<void> onTapSingleSelection({required int index, required List<RelatedOrders> relatedOrders})async{
    relatedOrders[index].isSelected = !relatedOrders[index].isSelected;

    bool isAllUnSelected = relatedOrders.any((element) => element.isSelected == false);
    if(isAllUnSelected){
      isAllSelected = false;
    }else{
      isAllSelected = true;
    }
    setState(() {
    });
  }


}