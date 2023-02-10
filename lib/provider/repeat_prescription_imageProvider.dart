import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:pharmdel_business/data/web_constent.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class RepeatPrescriptionImageProvider with ChangeNotifier {
  PickedFile? _image;
  final ImagePicker _picker = ImagePicker();
  bool loadingProfile = false;
  List<PickedFile> images = [];
  List<String> imageList = [];
  PickedFile? selectedImage;

  Map<String, dynamic> responseData = {};

  void getImage(ImageSource source, BuildContext context) async {
    try {
      if (_picker != null) {
        _image = await _picker.getImage(source: source, imageQuality: 25);
        if (_image != null) {
          images.add(_image!);
          updateProfileApi(context);
        }
      }
    } catch (_) {}
    notifyListeners();
  }

  void showImage(PickedFile showImage) {
    selectedImage = showImage;
    notifyListeners();
  }

  void removeImage(int index) {
    images.removeAt(index);
    imageList.removeAt(index);
    notifyListeners();
  }

  Future<void> updateProfileApi(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString('token') ?? "";

    Map<String, String> head = {'Accept': 'application/json', 'Content-type': 'application/json', 'Authorization': 'Bearer $accessToken'};

    Uri uri = Uri.parse(WebConstant.BASE_URL_UPLOADIMAGE);
    logger.i(uri);
    var request = http.MultipartRequest("POST", uri);
    // request.fields.addAll({
    //   'Model' : json.encode(prams)
    // });

    if (_image != null) {
      // print("file availabe");
      String path = _image!.path;
      request.files.add(await http.MultipartFile.fromPath('order_image', path));
      //fromBytes("file", file.readAsBytesSync()));
    }
    request.headers.addAll(head);
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response != null && response.body != null) {
      responseData = json.decode(response.body);
      if (responseData != null && responseData.isNotEmpty) {
        if (responseData["error"] == false && responseData["data"]["order_image"] != null) {
          if (_image != null) {
            imageList.add(responseData["data"]["order_image"]);
          } else {
            images.removeAt(images.length - 1);
          }
        } else
          images.removeAt(images.length - 1);
      } else
        images.removeAt(images.length - 1);
    } else
      images.removeAt(images.length - 1);

    // // await MultipartFile.fromFile(imagePicker.path, filename: 'upload.jpg')
    // ApiProvider apiProvider = ApiProvider();
    // var dictParameter = FormData.fromMap({
    //   'order_image': await MultipartFile.fromFile(_image.path, filename: 'order1.jpg'),
    // });
    // var post = await apiProvider.uploadImageAPI(context, WebApiConstraints.UPLOAD_IMAGE, dictParameter);
    // if (post != null && !post.error) {
    //   imageList.add(post.data.orderImage);
    // }else{
    //   images.removeAt(images.length-1);
    // }
    notifyListeners();
  }
}
