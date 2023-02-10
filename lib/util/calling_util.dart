import 'package:url_launcher/url_launcher.dart';

void makePhoneCall(String call) async {
  var url = 'tel:$call';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
