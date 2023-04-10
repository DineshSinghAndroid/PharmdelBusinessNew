import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Helper/PrintLog/PrintLog.dart';
import '../../Toast/ToastCustom.dart';

class DefaultFuntions{

  static Future<void> redirectToBrowser(String url) async {
    var link = url;
    if (await canLaunchUrl(Uri.parse(link))) {
      await launchUrl(Uri.parse(link));
    } else {
      throw 'Could not launch $link';
    }
  }  

  static Future barcodeScanning() async {
    var result = await BarcodeScanner.scan(); //options: ScanOptions()
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
  
}