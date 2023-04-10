import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';
import '../../Helper/Colors/custom_color.dart';
import '../StringDefine/StringDefine.dart';

class CommonUsePopUp extends StatelessWidget {
  final String ? title, subTitle, btnBackTitle, btnActionTitle;
  final Color? titleColor,subTitleColor,btnBackColor,btnActionColor;
  final Function()? onTapBackBtn,onTapActionBtn;
  final Widget? topWidget;
  final bool? isShowClearBtn;
  const CommonUsePopUp({  Key? key,this.isShowClearBtn,this.title, this.subTitle, this.btnBackTitle, this.btnActionTitle, this.titleColor, this.subTitleColor, this.btnBackColor, this.btnActionColor, this.onTapBackBtn, this.onTapActionBtn, this.topWidget}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      insetPadding: const EdgeInsets.all(20),
      backgroundColor: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 10, top: 45, right: 10, bottom: 20),
            margin: const EdgeInsets.only(top: 45),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
              BoxShadow(color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
            ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[

                /// Title
                Visibility(
                  visible: title != null,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: BuildText.buildText(
                          text: title ?? "",size: 22,weight: FontWeight.w600
                      ),
                    )
                ),

                /// Sub Title
                Visibility(
                    visible: subTitle != null,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 22),
                      child: BuildText.buildText(
                          text: subTitle ?? "",size: 14,textAlign: TextAlign.center
                      ),
                    )
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: TextButton(
                          style: TextButton.styleFrom(fixedSize: const Size.fromHeight(30),),
                          onPressed: onTapBackBtn ?? () => Navigator.of(context).pop("no"),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0.0, right: 10),
                            child: BuildText.buildText(
                                text: btnBackTitle ?? "No",
                              color: btnBackColor ?? AppColors.blackColor,
                              size: 18,textAlign: TextAlign.start,
                            )
                          )),
                    ),

                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                          style: TextButton.styleFrom(fixedSize: const Size.fromHeight(30),),
                          onPressed: onTapActionBtn ?? () => Navigator.of(context).pop("yes"),
                          child: Padding(
                              padding: const EdgeInsets.only(left: 0.0, right: 10),
                              child: BuildText.buildText(
                                text: btnActionTitle ?? "Yes",
                                color: btnActionColor ?? AppColors.blackColor,
                                size: 18,textAlign: TextAlign.start,
                              )
                          )),
                    ),
                  ],
                )
              ],
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 45,
              child: SizedBox(
                  width: 60,
                  height: 60,
                  child: topWidget ?? Image.asset(strImgDelTruck),
              ),
            ),
          ),
          Visibility(
            visible: isShowClearBtn == true,
            child: Positioned(
              right: 0,
                top: 35,
                child: InkWell(
                  onTap: ()=> Get.back(),
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 10),
                    height: 70,width: 70,color: Colors.transparent,
                    child: const Icon(Icons.clear,size: 30,),
                  ),
                )
            ),
          )


        ],
      )
    );
  }
}

