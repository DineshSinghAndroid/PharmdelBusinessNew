
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import '../../Helper/PrintLog/PrintLog.dart';


const String kUriPrefix = "https://apnaslot.page.link";
const String kPackageNameAndroid = "com.apna_slot";
const String kBundleIdentifierIos = "com.oopnik";
const String kReferID = "https://apnaslot.page.link/library_id=";
// const String kGoogleStoreId = "809024952201";
const String kAppStoreId = "";

FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;

class FirebaseDynamicLinkCustom{

  static Future<String?> getInitialDynamicLinksWhenBackgroundState()async{
    String? libraryID;
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      PrintLog.printLog("GetInitialDynamicLinks Library ID...: ${dynamicLinkData.link.queryParameters['library_id']}");
      libraryID = dynamicLinkData.link.queryParameters['library_id'].toString() ?? "";
    }).onError((error) {
      PrintLog.printLog("getInitialDynamicLinksWhenBackgroundState..Error: $error");
    });
    return libraryID;
  }

  static Future<String?> createReferLink({required bool short,required String libraryID})async{
    FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      link: Uri.parse(kReferID + libraryID),
      uriPrefix: kUriPrefix,
      androidParameters: const AndroidParameters(
        packageName: kPackageNameAndroid,
      ),
      iosParameters: const IOSParameters(bundleId: kBundleIdentifierIos),
    );
    Uri url;
    if(short){
      final ShortDynamicLink shortLink = await dynamicLinks.buildShortLink(parameters,shortLinkType: ShortDynamicLinkType.unguessable,);
      url = shortLink.shortUrl;
      return shortLink.shortUrl.toString();
    }else{
      url = await dynamicLinks.buildLink(parameters);
      return url.toString();
    }
  }

}