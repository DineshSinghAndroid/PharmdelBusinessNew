
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TxtValidation{


  static normalTextField(TextEditingController controller){
    if(controller.text.toString().trim().isEmpty) {
      return true;
    }
    return false;
  }

  static validateTextField(TextEditingController controller){
    if(controller.text.toString().trim().isNotEmpty && controller.text.toString().trim().length < 10) {
      return true;
    }
    return false;
  }
  static validateMobileTextField(TextEditingController controller){
    if(controller.text.toString().trim().isNotEmpty && controller.text.toString().trim().length < 10) {
      return true;
    }
    return false;
  }

  static validateAadhaarTextField(TextEditingController controller){
    if(controller.text.toString().trim().isNotEmpty && controller.text.toString().trim().length < 12) {
      return true;
    }
    return false;
  }

  static validatePinTextField(TextEditingController controller){
    if(controller.text.toString().trim().isNotEmpty && controller.text.toString().trim().length < 4) {
      return true;
    }
    return false;
  }

  static validateEmailTextField(TextEditingController controller){
    if(controller.text.toString().trim().isEmpty && controller.text.toString().trim() != null) {
      return true;
    }
    RegExp regex = new RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (!regex.hasMatch(controller.text.toString().trim())) {
      return true;
    }
    return false;
  }

}