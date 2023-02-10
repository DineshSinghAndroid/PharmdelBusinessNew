
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../Helper/PrintLog/PrintLog.dart';


class ImagePickerController extends GetxController{

  XFile?  _image;
  XFile?  profileImage;
  XFile?  documentImage;
  bool isLoading = false;
  XFile? image1;

  final ImagePicker _picker = ImagePicker();
  List<XFile> images = [];

  void getImage(source,BuildContext context, String type) async {
    isLoading = true;
    try {
      if(_picker != null) {
        if(source == "Camera" && image1 != null){
          // _image = image1;
        }else if(source == "Gallery"){
          _image = null;
          _image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 25);
        }

        if(_image != null) {
          if(type == "profileImage"){
            profileImage = _image;
            isLoading = false;
          }
          if(type == "documentImage") {
            documentImage = _image;
            isLoading = false;
          }
        }else{
          isLoading = false;
        }
      }else{
        isLoading = false;
      }
    }catch(_){
      PrintLog.printLog("Exception: $_");
      isLoading = false;
    }
    update();
  }

  void updateProfileImage(XFile image){
    profileImage = image;
    PrintLog.printLog("profileImage $profileImage");
    update();
  }
  void updatePhoto(XFile image){
    image1 = image;
    PrintLog.printLog("profileImage $profileImage");
    update();
  }

  void updateDoucumentImage(XFile image){
    documentImage = image;
    update();
  }

}