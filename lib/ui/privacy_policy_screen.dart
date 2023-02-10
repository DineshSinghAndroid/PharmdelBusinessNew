// @dart=2.9

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicy extends StatelessWidget {
  String title;

  String url;

  PrivacyPolicy({key, @required this.title, @required this.url}) : super(key: key);

  void getWebView(BuildContext context, bool status) {
    Provider.of<LoadingProvider>(context, listen: false).webViewCreated(status);
  }

  @override
  Widget build(BuildContext context) {
    var isLoading = Provider.of<LoadingProvider>(context);
    // isLoading.webViewCreated(true);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              size: 25,
              color: Colors.black,
            ),
          ),
        ),
        body: Stack(
          children: [
            WebView(
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: url,
              onProgress: (value) {
                getWebView(context, true);
              },
              onPageFinished: (finish) {
                getWebView(context, false);
              },
            ),
            isLoading.isloading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Stack(),
          ],
        ),
      ),
    );
  }
}

class LoadingProvider with ChangeNotifier {
  bool isloading = true;

  void webViewCreated(bool bool) {
    isloading = bool;
    notifyListeners();
  }
}
