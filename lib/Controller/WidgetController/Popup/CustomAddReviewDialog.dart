
// import 'package:apna_slot/Controller/Helper/ColoController/CustomColors.dart';
// import 'package:apna_slot/Controller/Helper/TextController/FontFamily/FontFamily.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';

// import '../AdditionalWidget/AdditionalWidget.dart';
// import '../AdditionalWidget/CustomeRattingBar.dart';

// class CustomAddReviewDialog extends StatelessWidget {

//   final TextEditingController? reviewController;
//   void Function()? onTap;
//   CustomAddReviewDialog({this.reviewController, this.onTap});

//   dialogContent(BuildContext context) {

//     return Container(
//       width: MediaQuery.of(context).size.width,
//       height: MediaQuery.of(context).size.height*0.48,
//       decoration: new BoxDecoration(
//         color: Colors.white,
//         shape: BoxShape.rectangle,
//         borderRadius: BorderRadius.circular(5),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black26,
//             blurRadius: 10.0,
//             offset: const Offset(0.0, 10.0),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min, // To make the card compact
//         children: <Widget>[
//           Container(
//             height: 8.h,
//             decoration: BoxDecoration(
//               color: CustomColors.bluearrowcolor,
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(5),
//                 topRight: Radius.circular(5),
//               ),
//             ),
//             child: Center(
//                 child: buildTextCommon(text: 'Review',color: Colors.white,)
//             ),
//           ),
//           Container(
//             padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5.w),
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(top: 10),
//                   child: Row(
//                     children: [
//                       buildTextCommon(text: 'Star : ',size: 12,),
//                       CustomRattingBar(stars: 3,),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 20,),
//                 Container(                  
//                   width: 100.w,
//                   height: 15.h,                
//                   padding: EdgeInsets.all(5),                  
//                   decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color: CustomColors.greyColorLight,),
//                   child: TextField(
//                     controller: reviewController,
//                     maxLines: null,
//                     keyboardType: TextInputType.multiline,
//                     decoration: InputDecoration(
//                         hintText: 'Comment...',
//                         hintStyle: TextStyle(fontFamily: FontFamily.josefinRegular,fontSize: 12,color: Color.fromRGBO(139, 139, 139, 1)),
//                         isDense: true,
//                         contentPadding: EdgeInsets.zero,
//                         border: InputBorder.none
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 6.h,),
//                 Container(
//                   width: 80.w,
//                   height: 7.h,
//                   child: ElevatedButton(
//                     onPressed: onTap,
//                     child: Text(
//                       'Submit',style: TextStyle(fontFamily: FontFamily.josefinRegular,color: Colors.white,fontSize: 18),
//                       textAlign: TextAlign.center,
//                     ),
//                     style: ButtonStyle(
//                         backgroundColor: MaterialStateProperty.all<Color>(CustomColors.bluearrowcolor),
//                         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                             RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(90),
//                             )
//                         )
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {

//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(5),
//       ),
//       elevation: 0.0,
//       backgroundColor: Colors.transparent,
//       child: dialogContent(context),
//     );
//   }
// }