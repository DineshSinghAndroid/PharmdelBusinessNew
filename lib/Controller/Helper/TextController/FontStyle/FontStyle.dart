import 'dart:ui';
import 'package:flutter/material.dart';

 import '../../Colors/custom_color.dart';
import '../FontFamily/FontFamily.dart';

class TextStyleCustom{
  TextStyleCustom._privateConstructor();
  static final TextStyleCustom instance = TextStyleCustom._privateConstructor();

  static TextStyle normalStyle({double? fontSize,Color? color,String? fontFamily,double? height}){
    return TextStyle(
      fontSize: fontSize ?? 14.0,
      color: color ?? AppColors.blackColor,
      fontFamily: fontFamily ?? FontFamily.NexaRegular,
        height: height ?? 0,
    );
  }

  static TextStyle textFieldStyle({double? fontSize,Color? color,String? fontFamily,double? height}){
    return TextStyle(
      fontSize: fontSize ?? 14.0,
      color: color ?? AppColors.blackColor,
      fontFamily: fontFamily ?? FontFamily.NexaRegular,
      height: height ?? 0,
    );
  }

  static TextStyle underLineStyle(){
    return const TextStyle(
      fontSize: 22.0,
      shadows: [
        Shadow(
          color: Colors.red,
          offset: Offset(0, -5),
        )
      ],
      color: Colors.transparent,
      fontWeight: FontWeight.w900,
      decoration: TextDecoration.underline,
      decorationColor: Colors.red,
      decorationThickness: 1,
    );
  }

}


final TextStyle Bold20Style = TextStyle(
  fontSize: 20.0,
  color: AppColors.primaryTextColor,
  fontFamily: 'OpensansBold',
);
final TextStyle Bold18Style = TextStyle(
  fontSize: 18.0,
  color: AppColors.primaryTextColor,
  fontFamily: 'OpensansBold',
);
final TextStyle Bold16Style = TextStyle(
  fontSize: 16.0,
  color: AppColors.primaryTextColor,
  fontFamily: 'OpensansBold',
);
final TextStyle Bold14Style = TextStyle(
  fontSize: 14.0,
  color: AppColors.primaryTextColor,
  fontFamily: 'OpensansBold',
);
final TextStyle Bold12Style = TextStyle(
  fontSize: 12.0,
  color: AppColors.primaryTextColor,
  fontFamily: 'OpensansBold',
);

final TextStyle Bold10Style = TextStyle(
  fontSize: 10.0,
  color: AppColors.primaryTextColor,
  fontFamily: 'OpensansBold',
);
final TextStyle SemiBold20Style = TextStyle(
  fontSize: 20.0,
  color: AppColors.primaryTextColor,
  fontFamily: 'OpensansSemiBold',
);
final TextStyle SemiBold22Style = TextStyle(
  fontSize: 22.0,
  color: AppColors.primaryTextColor,
  fontFamily: 'OpensansSemiBold',
);
final TextStyle SemiBold18Style = TextStyle(
  fontSize: 18.0,
  color: AppColors.primaryTextColor,
  fontFamily: 'OpensansSemiBold',
);
final TextStyle SemiBold16Style = TextStyle(
  fontSize: 16.0,
  color: AppColors.primaryTextColor,
  fontFamily: 'OpensansSemiBold',
);
final TextStyle SemiBold14Style = TextStyle(
  fontSize: 14.0,
  color: AppColors.primaryTextColor,
  fontFamily: 'OpensansSemiBold',
);
final TextStyle SemiBold12Style = TextStyle(
  fontSize: 12.0,
  color: AppColors.primaryTextColor,
  fontFamily: 'OpensansSemiBold',
);
final TextStyle Regular16Style = TextStyle(
  fontSize: 16.0,
  color: AppColors.primaryTextColor,
  fontFamily: 'OpensansRegular',
);
final TextStyle Regular18Style = TextStyle(
  fontSize: 18.0,
  color: AppColors.primaryTextColor,
  fontFamily: 'OpensansRegular',
);
final TextStyle Regular20Style = TextStyle(
  fontSize: 20.0,
  color: AppColors.primaryTextColor,
  fontFamily: 'OpensansRegular',
);
final TextStyle Regular22Style = TextStyle(
  fontSize: 22.0,
  color: AppColors.primaryTextColor,
  fontFamily: 'OpensansRegular',
);
final TextStyle Regular14Style = TextStyle(
  fontSize: 14.0,
  color: AppColors.primaryTextColor,
  fontFamily: 'OpensansRegular',
);
final TextStyle Regular12Style = TextStyle(
  fontSize: 12.0,
  color: AppColors.primaryTextColor,
  fontFamily: 'OpensansRegular',
);
final TextStyle Regular11Style = TextStyle(
  fontSize: 11.0,
  color: AppColors.primaryTextColor,
  fontFamily: 'OpensansRegular',
);
final TextStyle Regular10Style = TextStyle(
  fontSize: 10.0,
  color: AppColors.primaryTextColor,
  fontFamily: 'OpensansRegular',
);

final TextStyle Light16Style = TextStyle(
  fontSize: 16.0,
  color: AppColors.primaryTextColor,
  fontFamily: 'OpensansLight',
);
final TextStyle Light14Style = TextStyle(
  fontSize: 14.0,
  color: AppColors.primaryTextColor,
  fontFamily: 'OpensansLight',
);
final TextStyle Light12Style = TextStyle(
  fontSize: 12.0,
  color: AppColors.primaryTextColor,
  fontFamily: 'OpensansLight',
);
final TextStyle Light10Style = TextStyle(
  fontSize: 10.0,
  color:  AppColors.primaryTextColor,
  fontFamily: 'OpensansLight',
);

final TextStyle TextStyleblueGrey14 = TextStyle(
  color:  AppColors.primaryTextColor,
  fontFamily: 'OpensansLight',
);

final TextStyle TextStylewhite14 = TextStyle(
  color:  AppColors.primaryTextColor,
  fontFamily: 'OpensansLight',
);
final TextStyle TextStyle20White = TextStyle(
  color:  AppColors.primaryTextColor,
  fontFamily: 'OpensansLight',
);

final TextStyle TextStyle6White = TextStyle(
  color:  AppColors.primaryTextColor,
  fontFamily: 'OpensansLight',
);

// final TextStyle TextStyle8Black = TextStyle(
//   color: secondaryTextColor,
//   fontFamily: 'OpensansLight',
// );

final TextStyle TextStyleGreen14 = TextStyle(
  color: Colors.green,
  fontFamily: 'OpensansLight',
);

final TextStyle TextStylewhite20 = TextStyle(
  color: Colors.white,
  fontSize: 20,
  fontFamily: 'OpensansLight',
);

  class TS {

    static TextStyle CTS(fs,color,fw) {return TextStyle(

  fontSize: fs,
  color: color,
  fontWeight: fw,
);}}








// class FontStyleCustom {

//   static TextStyle bold16Style = TextStyle(
//     fontSize: 16.0,
//     color: AppColors.blackColor,
//     fontFamily: FontFamily.nexabold,
//   );
//   static TextStyle light18Style = TextStyle(
//     fontSize: 18.0,
//     color: AppColors.blackColor,
//     fontFamily: FontFamily.nexalight,
//   );
//   static TextStyle buttonTextStyle = TextStyle(
//     fontSize: 18.0,
//     color: AppColors.blackColor,
//     fontFamily: FontFamily.NexaBlack,
//   );
//   static TextStyle italic16Style = TextStyle(
//     fontSize: 16.0,
//     color: AppColors.blackColor,
//     fontFamily: FontFamily.NexaBlackItalic,
//   );
//   static TextStyle nexaBold14Style = TextStyle(
//     fontSize: 14.0,
//     color: AppColors.blackColor,
//     fontFamily: FontFamily.NexaBold,
//   );
//   static TextStyle boldItalic12Style = TextStyle(
//     fontSize: 12.0,
//     color: AppColors.blackColor,
//     fontFamily: FontFamily.NexaBoldItalic,
//   );
//    static TextStyle book20Style = TextStyle(
//     fontSize: 20.0,
//     color: AppColors.blackColor,
//     fontFamily: FontFamily.NexaBook,
//   );
//    static TextStyle bookItalic20Style = TextStyle(
//     fontSize: 20.0,
//     color: AppColors.blackColor,
//     fontFamily: FontFamily.NexaBookItalic,
//   );
//    static TextStyle heavy20Style = TextStyle(
//     fontSize: 20.0,
//     color: AppColors.blackColor,
//     fontFamily: FontFamily.NexaHeavy,
//   );
//    static TextStyle heavyItalic20Style = TextStyle(
//     fontSize: 20.0,
//     color: AppColors.blackColor,
//     fontFamily: FontFamily.NexaHeavyItalic,
//   );
//    static TextStyle nexaLight20Style = TextStyle(
//     fontSize: 20.0,
//     color: AppColors.blackColor,
//     fontFamily: FontFamily.NexaLight,
//   );
//    static TextStyle lightItalic20Style = TextStyle(
//     fontSize: 20.0,
//     color: AppColors.blackColor,
//     fontFamily: FontFamily.NexaLightItalic,
//   );
//    static TextStyle regular20Style = TextStyle(
//     fontSize: 20.0,
//     color: AppColors.blackColor,
//     fontFamily: FontFamily.NexaRegular,
//   );
//    static TextStyle regularItalic20Style = TextStyle(
//     fontSize: 20.0,
//     color: AppColors.blackColor,
//     fontFamily: FontFamily.NexaRegularItalic,
//   );
//     static TextStyle thin20Style = TextStyle(
//     fontSize: 20.0,
//     color: AppColors.blackColor,
//     fontFamily: FontFamily.NexaThin,
//   );
//     static TextStyle thinItalic20Style = TextStyle(
//     fontSize: 20.0,
//     color: AppColors.blackColor,
//     fontFamily: FontFamily.NexaThinItalic,
//   );
//     static TextStyle xBold20Style = TextStyle(
//     fontSize: 20.0,
//     color: AppColors.blackColor,
//     fontFamily: FontFamily.NexaXBold,
//   );
//     static TextStyle xBolditalic20Style = TextStyle(
//     fontSize: 20.0,
//     color: AppColors.blackColor,
//     fontFamily: FontFamily.NexaXBoldItalic,
//   );
// }