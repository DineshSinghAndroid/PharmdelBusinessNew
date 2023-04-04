import 'package:barcode_scan2/model/scan_options.dart';
import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Helper/Colors/custom_color.dart';
import '../../../Helper/PrintLog/PrintLog.dart';
import '../../../Helper/TextController/BuildText/BuildText.dart';
import '../../Toast/ToastCustom.dart';

class DefaultFuntions {
  static Future<void> redirectToBrowser(String url) async {
    var link = url;
    if (await canLaunchUrl(Uri.parse(link))) {
      await launchUrl(Uri.parse(link));
    } else {
      throw 'Could not launch $link';
    }
  }

  static Future barcodeScanning() async {
    var result = await BarcodeScanner.scan(
      options: ScanOptions(),
    );
    //  options: ScanOptions()
    PrintLog.printLog("Type:${result.type}");
    PrintLog.printLog("RawContent:${result.rawContent}");
    if (result.rawContent.toString().length > 10) {
      PrintLog.printLog("Product code is :${result.rawContent}");
    } else {
      ToastCustom.showToast(msg: 'Not found');
    }
  }

  static void launchPhone(String phoneNumber) async {
    var url = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static datePickerCustom(
      {required BuildContext context,
      required VoidCallback onTap,
      required String showDate}) async {
    return InkWell(
      onTap: onTap,
      // () async {
      //   final DateTime? picked = await showDatePicker(
      //       builder: (context, child) {
      //         return Theme(
      //           data: Theme.of(context).copyWith(
      //         colorScheme: ColorScheme.light(
      //         primary: AppColors.colorOrange,
      //         onPrimary: AppColors.whiteColor,
      //         onSurface: AppColors.blackColor,
      //       )),
      //       child: child!,
      //         );
      //       },
      //       context: context,
      //       initialDate: DateTime.now(),
      //       firstDate: DateTime(DateTime.now().year,
      //           DateTime.now().month, DateTime.now().day),
      //       lastDate: DateTime(2101));
      //   if (picked != null) {
      //     setState(() {
      //       selectedDate = formatter.format(picked);
      //       showDatedDate = formatterShow.format(picked);
      //     });
      //   }
      // },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        padding:
            const EdgeInsets.only(left: 10.0, top: 10, bottom: 10, right: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: AppColors.whiteColor,
        ),
        child: Row(
          children: [
            BuildText.buildText(text: showDate),
            const Spacer(),
            const Icon(Icons.calendar_today_sharp)
          ],
        ),
      ),
    );
  }
}
