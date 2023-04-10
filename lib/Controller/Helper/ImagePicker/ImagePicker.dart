
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../PrintLog/PrintLog.dart';

class ImagePickerController extends GetxController{
  XFile?  _image;
  XFile?  profileImage;
  XFile?  rxImage;
  XFile?  documentImage;
  XFile?  speedometerImage;
  XFile?  orderImage;
  bool isLoading = false;
  XFile? image1;

  final ImagePicker _picker = ImagePicker();
  List<XFile> images = [];

  Future<void> getImage({required String source, required BuildContext context, required String type}) async {
    isLoading = true;
    try {
      if(_picker != null) {
        if(source == "Camera"){
          _image = null;
          _image = await _picker.pickImage(source: ImageSource.camera, imageQuality: 25);
        }else if(source == "Gallery"){
          _image = null;
          _image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 25);
        }
        if(_image != null) {
          if(type == "profileImage"){
            profileImage = _image;
            isLoading = false;
          }
          if(type == "rxImage"){
            rxImage = _image;
            isLoading = false;
          }
          if(type == "documentImage") {
            documentImage = _image;
            isLoading = false;
          }
          if(type == "speedometerImage") {
            speedometerImage = _image;
            isLoading = false;
          }
          if(type == "orderImage") {
            orderImage = _image;
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
  void updateRxImage(XFile image){
    rxImage = image;
    PrintLog.printLog("rxImage $rxImage");
    update();
  }
  void updatePhoto(XFile image){
    image1 = image;
    PrintLog.printLog("profileImage $profileImage");
    update();
  }

  void updateDocumentImage(XFile image){
    documentImage = image;
    update();
  }
  void updateSpeedometerImage(XFile image){
    speedometerImage = image;
    update();
  }
  void updateOrderImage(XFile image){
    orderImage = image;
    update();
  }

  // void getImageFromImageController(source, BuildContext context) {
  //   imagePicker?.getImage(source, context, "documentImage");
  // }
}