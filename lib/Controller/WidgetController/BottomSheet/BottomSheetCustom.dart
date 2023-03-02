

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../Helper/PrintLog/PrintLog.dart';

class BottomSheetCustom{

  static Future<void> share({required BuildContext context,required String link}) async {
    PrintLog.printLog('Share Tab');
    await Share.share(link,
      subject: "Apna Slot",
    );
  }
  /// Use for share App
  // static showSharePopup({required context,required String shareLink}) async {
  //   return showModalBottomSheet(
  //       isScrollControlled: true,
  //       clipBehavior: Clip.antiAlias,
  //       shape: const RoundedRectangleBorder(
  //           borderRadius: BorderRadius.only(
  //             topRight: Radius.circular(20.0),
  //             topLeft: Radius.circular(20.0),
  //           )
  //       ),
  //       context: context,
  //       backgroundColor: Colors.white,
  //       builder: (builder){
  //         return SafeArea(
  //             child: Wrap(
  //               children: [
  //                 Stack(
  //                   children: [
  //                     Padding(
  //                       padding: const EdgeInsets.only(left: 30,right: 30,bottom: 10),
  //                       child: SingleChildScrollView(
  //                         child: Column(
  //                             mainAxisAlignment: MainAxisAlignment.start,
  //                             crossAxisAlignment: CrossAxisAlignment.center,
  //                             children: [
  //                               Container(
  //                                 height: 115,
  //                                 width: 115,
  //                                 margin: const EdgeInsets.only(bottom: 20,top: 30),
  //                                 decoration: BoxDecoration(
  //                                     shape: BoxShape.circle,
  //                                     color: AppColors.bluearrowcolor.withOpacity(0.8),
  //                                     image:  DecorationImage(
  //                                         image: AssetImage(str_imgSharePopup),
  //                                         fit: BoxFit.cover
  //                                     )
  //                                 ),
  //                               ),
  //                               buildTextWithWeightOrSpacingHeight(
  //                                   "Invite friends & earn\namazing gadgets"
  //                                   , 18.0, TextAlign.center, FontFamily.montRegular, AppColors.signupcolor, FontWeight.w800, 0.3, 0.0),
  //                               buildSizedBox(15.0, 0.0),
  //                               InkWell(
  //                                 onTap: (){
  //                                   Clipboard.setData(ClipboardData(text: shareLink)).then((value) {
  //                                     ToastUtils.showToast("Link copied");
  //                                   });
  //                                 },
  //                                 child: DottedBorder(
  //                                   borderType: BorderType.RRect,
  //                                   radius: const Radius.circular(6),
  //                                   dashPattern: [2, 2],
  //                                   color: AppColors.greyColor,
  //                                   strokeWidth: 1,
  //                                   child: Container(
  //                                     height: 50,
  //                                     padding: const EdgeInsets.only(left: 20,right: 20),
  //                                     width: MediaQuery.of(context).size.width,
  //                                     decoration: BoxDecoration(
  //                                       borderRadius: BorderRadius.circular(6),
  //                                       color: AppColors.transparentColor,
  //                                       // border: Border.all(width: 1,color: AppColors.greyColor)
  //                                     ),
  //                                     child: Center(
  //                                         child: Row(
  //                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                                           crossAxisAlignment: CrossAxisAlignment.center,
  //                                           children: [
  //                                             Expanded(
  //                                               child: buildTextWithWeightOrSpacingHeightWithLine(
  //                                                   shareLink, 14.0, TextAlign.left, FontFamily.montRegular, AppColors.darkGreyColor1, FontWeight.w600, 0.0, 0.0
  //                                               ),
  //                                             ),
  //                                             SvgPicture.asset(str_svgCopy),
  //                                           ],
  //                                         )
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                               buildSizedBox(30.0, 0.0),
  //
  //                               Container(
  //                                 height: 50,
  //                                 width: MediaQuery.of(context).size.width,
  //                                 child: Row(
  //                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                                   crossAxisAlignment: CrossAxisAlignment.center,
  //                                   children: [
  //                                     Expanded(
  //                                       child: InkWell(
  //                                         onTap: (){
  //                                           Navigator.of(context).pop(false);
  //                                         },
  //                                         child: Container(
  //                                             height: 50.0,
  //                                             padding: const EdgeInsets.only(left: 20,right: 20),
  //                                             decoration: BoxDecoration(
  //                                                 borderRadius: BorderRadius.circular(50.0),
  //                                                 color: AppColors.colorWhatsApp
  //                                             ),
  //                                             // margin: EdgeInsets.all(25),
  //                                             child: Row(
  //                                               mainAxisAlignment: MainAxisAlignment.center,
  //                                               crossAxisAlignment: CrossAxisAlignment.center,
  //                                               children: [
  //                                                 SvgPicture.asset(str_svgWhatsApp),
  //                                                 buildSizedBox(0.0, 5.0),
  //                                                 buildTextWithWeightOrSpacingHeight(
  //                                                     "Invite via Whatsapp", 14.0, TextAlign.left, FontFamily.montBold, AppColors.whiteColor, FontWeight.w900, 0.0, 0.0
  //                                                 )
  //                                               ],
  //                                             )
  //
  //                                         ),
  //                                       ),
  //                                     ),
  //                                     buildSizedBox(0.0, 15.0),
  //                                     InkWell(
  //                                       onTap: (){
  //                                         Navigator.of(context).pop(true);
  //                                       },
  //                                       child: Container(
  //                                           height: 50.0,
  //                                           width: 50.0,
  //                                           decoration: BoxDecoration(
  //                                               shape: BoxShape.circle,
  //                                               gradient: LinearGradient(
  //                                                 begin: Alignment.centerLeft,
  //                                                 end: Alignment.centerRight,
  //                                                 colors: [
  //                                                   AppColors.skyColor,
  //                                                   AppColors.purpleColor
  //                                                 ],
  //                                               )
  //                                           ),
  //                                           // margin: EdgeInsets.all(25),
  //                                           child: Center(
  //                                             child:
  //                                             Padding(
  //                                               padding: const EdgeInsets.only(bottom: 5),
  //                                               child: buildTextWithWeightOrSpacingHeight(
  //                                                   "...", 18.0, TextAlign.left, FontFamily.montRegular, AppColors.whiteColor, FontWeight.w900, 1.0, 0.0
  //                                               ),
  //                                             ),
  //                                           )
  //
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               )
  //                             ]
  //                         ),
  //                       ),
  //                     ),
  //                     Align(
  //                       alignment: Alignment.topRight,
  //                       child: InkWell(
  //                           onTap: (){
  //                             Navigator.pop(context);
  //                           },
  //                           child: Padding(
  //                             padding: const EdgeInsets.only(top: 15.0,right: 15.0),
  //                             child: Icon(Icons.clear,color: AppColors.darkGreyColor1 ,size: 30.0,),
  //                           )
  //                       ),
  //                     ),
  //                   ],
  //                 )
  //               ],
  //             )
  //         );
  //       }
  //   ).then((value) {
  //     PrintLog.printLog("Value is: $value");
  //     if(value == true){
  //       ShareWidget.share(context: context,link: shareLink);
  //     }else if(value == false){
  //       LaunchUrlCustom.shareLinkOnWhatsapp(context: context, shareLink: shareLink);
  //     }
  //
  //   });
  // }
}