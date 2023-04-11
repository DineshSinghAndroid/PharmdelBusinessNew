
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';
import 'package:pharmdel/Controller/WidgetController/Loader/LoadScreen/LoadScreen.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';
import '../../Controller/Helper/Colors/custom_color.dart';
import '../../Controller/ProjectController/VechicleInspectionReportController/vir_controller.dart';
import '../../Controller/WidgetController/AppBar/app_bar.dart';
import '../../Controller/WidgetController/TextField/CustomTextField.dart';


class ClickInspectionImagesScreen extends StatelessWidget {
  int index;
  ClickInspectionImagesScreen({Key? key, required this.index}) : super(key: key);

  VirController virCtrl = Get.find();


  @override
  Widget build(BuildContext context) {
    return GetBuilder<VirController>(
      init: virCtrl,
      builder: (controller) {
        return LoadScreen(
          widget: SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Scaffold(
                backgroundColor: Colors.white.withOpacity(1.0),
                appBar: AppBarCustom.appBarStyle2(
                    title: kClickImage,
                    titleColor: AppColors.whiteColor,
                    size: 18,
                    backgroundColor: AppColors.blueColor,
                    centerTitle: true
                ),
                bottomNavigationBar: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MaterialButton(
                        onPressed: ()=>controller.onTapSubmitImages(context: context,mainIndex: index,),
                        color: Colors.black,
                        child: const Text(
                          kSubmit,
                          style: TextStyle(color: Colors.white),
                        )),
                  ],
                ),
                body: SingleChildScrollView(
                  padding: const EdgeInsets.only(left: 20,right: 20,top: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      /// Title
                      BuildText.buildText(
                          text: "Click ${controller.servicePageList[index].title} Images ",
                        size: 32
                      ),
                      buildSizeBox(50.0, 0.0),

                      /// Grid View Images
                      GridView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.servicePageList[index].imagesList.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 6 / 7.5
                        ),
                        itemBuilder: (context, i) {
                          return InkWell(
                            onTap: ()=> controller.addImage(context: context,mainIndex: index,listIndex: i),
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
                                mainAxisSize: MainAxisSize.min,
                                children: [

                                  /// Image
                                  Expanded(
                                    child: Container(
                                      child: controller.servicePageList[index].imagesList[i].image != null
                                          ? Image.file(
                                            controller.servicePageList[index].imagesList[i].image!,
                                            fit: BoxFit.fitWidth,width: Get.width,
                                          )
                                          : Lottie.network('https://assets1.lottiefiles.com/packages/lf20_efenfp40.json', height: 100, width: 100),
                                    ),
                                  ),

                                  /// Delete btn or lbl
                                  Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                      height: 40,
                                      width: double.infinity,
                                      decoration: BoxDecoration(color: Colors.blue.withOpacity(0.5)),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          FittedBox(
                                            child: BuildText.buildText(text: controller.servicePageList[index].imagesList[i].type),
                                          ),
                                          IconButton(
                                            onPressed: ()=> controller.removeImage(mainIndex: index, listIndex: i),
                                              icon: const Icon(Icons.delete_forever_outlined,color: Colors.white,size: 20)
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      /// Remark's
                      Align(
                        alignment: Alignment.topLeft,
                        child: BuildText.buildText(text: kRemarks,size: 16,weight: FontWeight.w500)
                      ),
                      buildSizeBox(10.0, 0.0),

                      /// Remark's Ctrl
                      TextFieldCustom(
                        controller: controller.remarkController,
                        keyboardType: TextInputType.emailAddress,
                        maxLength: 50,
                        isCheckOut: false,
                        radiusField: 5,
                        hintText: kRemarks,
                        onChanged:(value){
                          if(value == " "){
                            controller.remarkController.clear();
                          }
                        },
                      ),
                      buildSizeBox(20.0, 0.0),

                    ],
                  ),
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
