 import 'package:toast/toast.dart';

DateTime? currentBackPressTime;

Future<bool> onWillPop() {
  DateTime now = DateTime.now();
  if (currentBackPressTime == null ||
      now.difference(currentBackPressTime!) > Duration(seconds: 1)) {
    currentBackPressTime = now;
    Toast.show( "Are you sure want to exit app?");
    return Future.value(false);
  }
  return Future.value(true);
}