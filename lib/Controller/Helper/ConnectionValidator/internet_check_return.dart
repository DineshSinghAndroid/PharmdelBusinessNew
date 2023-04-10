import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import '../../WidgetController/StringDefine/StringDefine.dart';


class InternetCheck{
  static check() async {
    bool checkInternet = await ConnectionValidator().check();
    if (!checkInternet) {
      ToastCustom.showToast(msg: kInternetNotAvailable);
      return;
    }
  }
  static Future<bool> checkStatus() async {
    bool checkInternet = await ConnectionValidator().check();
    if (!checkInternet) {

      return false;
    }else{
      return true;
    }
  }
}