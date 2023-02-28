import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/Helper/Colors/custom_color.dart';
import '../../Helper/TextController/FontFamily/FontFamily.dart';

class CustomTextField extends StatelessWidget{

  final OnTextChanged? onChanged;
  String? labelText = "";
  TextEditingController? controller;
  FocusNode? focus;
  bool? enable;
  bool readOnly;
  TextInputType? keyboardType;
  TextInputAction? inputAction;
  double? leftPadding;
  String? hintText ;
  String? errorText ;
  int? maxLines = 1;
  int? maxLength = 100;
  List<TextInputFormatter>? inputFormatters;
  Widget? prefixIcon;
  Widget? suffixIcon;
  Widget? suffixWidget;
  bool? obscureText;
  bool? isError;
  String? Function(String?)? validator;
  Iterable<String>? autofillHints;

  CustomTextField({
    Key? key,
    this.autofillHints,
    this.validator,
    this.enable,
    this.maxLines,
    required this.readOnly,
    this.onChanged,
    this.labelText,
    this.keyboardType,
    this.inputAction,
    this.hintText,
    this.maxLength,
    this.errorText,
    this.focus,
    this.isError,
    this.controller,
    this.inputFormatters,
    this.prefixIcon,
    this.obscureText,
    this.suffixWidget,
    this.suffixIcon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TextFormField(
      focusNode: focus,
      autofillHints: autofillHints,
      validator: validator,
      textInputAction: inputAction,
      keyboardType: keyboardType,
      autofocus: false,
      enabled: enable,
      readOnly: readOnly,
      maxLength: maxLength,
      maxLines: maxLines,
      inputFormatters: inputFormatters,
      obscureText: obscureText != null ? obscureText! : false,
      style: TextStyle(fontFamily: FontFamily.NexaRegular,fontSize: 14,),
      controller: controller,
      decoration: InputDecoration(      
          prefixIconConstraints: const BoxConstraints(minWidth: 50, maxHeight: 50),
          contentPadding: const EdgeInsets.only(top: 6.0,left: 15),
          hintText: hintText,
          errorText: errorText,
          suffixIcon: suffixIcon,
          suffix: suffixWidget,
          labelText:labelText,
          enabledBorder: OutlineInputBorder(            
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: AppColors.greyColor,)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: AppColors.greyColor,)),           
          prefixIcon: prefixIcon,
          filled: true,          
          fillColor: AppColors.greyColor.withOpacity(0.03),
          suffixIconConstraints: const BoxConstraints(minWidth: 50, maxHeight: 55),
          hintStyle: TextStyle(fontFamily: FontFamily.NexaRegular,color: Colors.grey),
          labelStyle: TextStyle(fontFamily: FontFamily.NexaRegular,color: Colors.grey),
      ),
      onFieldSubmitted: (v) {
        FocusScope.of(context).requestFocus(focus);
      },
      onChanged: (value){
        if(onChanged != null) {
          onChanged!(value);
        }
      },
    );
  }

}

typedef OnTextChanged = void Function(String value);


class SecurePinTextField{
  static SizedBox pinBox({required double screenWidth,required TextEditingController controllers,required FocusNode focus,required Function(String) onChanged}) {
  return SizedBox(
      width: screenWidth / 8,
      child: TextField(
        onChanged:onChanged,
        enabled: false,
        focusNode: focus,
        autofocus: true,
        obscureText: true,
        keyboardType: TextInputType.number,
        controller: controllers,
        showCursor: false,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
        decoration: const InputDecoration(contentPadding: EdgeInsets.all(5.0), counterText: "", border: null),
      ));
}
}



