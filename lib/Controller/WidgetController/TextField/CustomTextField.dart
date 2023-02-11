import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../Helper/TextController/FontFamily/FontFamily.dart';

class CustomTextField extends StatelessWidget{

  final OnTextChanged? onChanged;
  String? labelText = "";
  TextEditingController? controller;
  FocusNode? focus;
  bool? enable;
  bool readOnly;
  TextInputType? inputType;
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
    this.inputType,
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
    return Container(
      // margin: EdgeInsets.all(5),
        height: isError == true ? 60:54,
        width: Get.width,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 5),
          child: TextFormField(

            focusNode: focus,
            autofillHints: autofillHints,
            validator: validator,
            textInputAction: inputAction,
            keyboardType: inputType,
            autofocus: false,
            enabled: enable,
            readOnly: readOnly,
            maxLength: maxLength,
            maxLines: maxLines,
            inputFormatters: inputFormatters,
            obscureText: obscureText != null ? obscureText! : false,
            style: TextStyle(fontFamily: FontFamily.josefinRegular,fontSize: 16),
            controller: controller,
            decoration: InputDecoration(
               
                prefixIconConstraints: const BoxConstraints(minWidth: 50, maxHeight: 50),
                contentPadding: const EdgeInsets.only(top: 6.0,left: 15),
                counter: const Offstage(),
                hintText: hintText,
                errorText: errorText,
                suffixIcon: suffixIcon,
                suffix: suffixWidget,
                labelText:labelText,
                border: InputBorder.none,
                prefixIcon: prefixIcon,
                suffixIconConstraints: const BoxConstraints(minWidth: 50, maxHeight: 55),
                hintStyle: TextStyle(fontFamily: FontFamily.josefinRegular,color: Colors.grey)
            ),
            onFieldSubmitted: (v) {
              FocusScope.of(context).requestFocus(focus);
            },
            onChanged: (value){
              if(onChanged != null) {
                onChanged!(value);
              }
            },
          ),
        )
    );
  }

}

typedef OnTextChanged = void Function(String value);


