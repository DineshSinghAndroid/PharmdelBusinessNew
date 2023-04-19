import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/Helper/Colors/custom_color.dart';
import '../../Helper/TextController/BuildText/BuildText.dart';
import '../../Helper/TextController/FontFamily/FontFamily.dart';
import '../../Helper/TextController/FontStyle/FontStyle.dart';

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

class TextFieldCustom extends StatefulWidget {
  TextEditingController? controller = TextEditingController();
  FocusNode? focusNode = FocusNode();
  TextInputType? keyboardType;
  List<TextInputFormatter>? inputFormatters;
  ValueChanged? onChanged;
  int? maxLength;
  double? radiusField;
  bool? obscureText;
  String? hintText;
  String? textFieldHeading;
  Widget? suffixIcon;
  Widget? prefixIcon;
  bool? enabled;
  String? errorText;
  TextAlign? textAlign;
  bool? readOnly;
  bool? isCheckOut;
  bool? isAutoFocus;
  final String? Function(String?)? validator;
  TextFieldCustom(
      {Key? key,
        this.focusNode,
        this.textAlign,
        this.suffixIcon,
        this.textFieldHeading,
        this.radiusField,
        this.prefixIcon,
        this.obscureText,
        this.hintText,
        this.controller,
        this.keyboardType,
        this.onChanged,
        this.maxLength,
        this.errorText,
        this.inputFormatters,
        this.enabled,
        this.readOnly,
        this.isAutoFocus,
        this.isCheckOut,
        this.validator})
      : super(key: key);

  @override
  State<TextFieldCustom> createState() => _TextFieldCustomState();
}

class _TextFieldCustomState extends State<TextFieldCustom> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: widget.textFieldHeading != null && widget.textFieldHeading != "" ? 23.0:0.0,
          width: Get.width,
          child: BuildText.buildText(
              text: widget.textFieldHeading ?? "",
              style: TextStyleCustom.normalStyle(),
              textAlign: TextAlign.left
          ),
        ),

        SizedBox(
          height: 55,
          child: TextFormField(
            autofocus: widget.isAutoFocus ?? false,
            readOnly: widget.readOnly ?? false,
            cursorColor: AppColors.blackColor,
            focusNode: widget.focusNode,
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            inputFormatters: widget.inputFormatters,
            enabled: widget.enabled,
            // cursorHeight: 2.0,
            validator: widget.validator,
            obscureText: widget.obscureText != null ? widget.obscureText! : false,
            maxLength: widget.maxLength,
            textAlign: widget.textAlign != null ? widget.textAlign! : TextAlign.start,
            textInputAction: TextInputAction.next,
            onChanged: widget.onChanged,
            style: widget.readOnly == true ? TextStyleCustom.normalStyle(color: AppColors.greyColorDark):TextStyleCustom.normalStyle(),
            // style: TextStyle(color: widget.readOnly == true ? CustomColors.greyLightColor:CustomColors.blackColor),
            decoration: InputDecoration(
              hintStyle: TextStyle(
                color: AppColors.greyColorDark,
                fontSize: 14,
              ),
              counterText: "",
              hintText: widget.hintText,
              suffixIcon: widget.suffixIcon,
              suffixIconColor: AppColors.blackColor,
              prefixIcon: Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: widget.prefixIcon
              ),
              prefixIconConstraints: const BoxConstraints(),
              prefixStyle: const TextStyle(height: 16,),
              filled: true,
              fillColor: widget.isCheckOut == true ? Colors.transparent:AppColors.textFieldBorderColor.withOpacity(0.1),
              border: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: AppColors.textFieldActiveBorderColor,width: 1
                ),
                borderRadius: BorderRadius.circular(widget.radiusField ?? 30),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.radiusField ?? 30),
                borderSide: BorderSide(
                    color: widget.errorText != null && widget.errorText != "" ? AppColors.textFieldErrorBorderColor:AppColors.textFieldBorderColor,width: 1
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.radiusField ?? 30),
                borderSide: BorderSide(
                    color: AppColors.textFieldErrorBorderColor,width: 1
                ),
              ),
            ),
          ),
        ),

        Visibility(
            visible: widget.errorText != null && widget.errorText != "",
            child: Padding(
              padding: const EdgeInsets.only(left: 10,top: 10),
              child: BuildText.buildText(
                  text: widget.errorText ?? "",
                  style: TextStyleCustom.normalStyle(color: AppColors.textFieldErrorBorderColor),
                  textAlign: TextAlign.center
              ),
            )
        )
      ],
    );
  }
}

class TextFieldCustomForMPin extends StatefulWidget {
  TextEditingController? controller = TextEditingController();
  FocusNode? focusNode = FocusNode();
  TextInputType? keyboardType;
  List<TextInputFormatter>? inputFormatters;
  ValueChanged? onChanged;
  int? maxLength;
  bool? obscureText;
  String? hintText;
  Color? labelColor;
  String? textFieldHeading;
  String? obscuringCharacter;
  Widget? suffixIcon;
  Widget? prefixIcon;
  bool? enabled;
  double? radiusField;
  String? errorText;
  TextAlign? textAlign;
  bool? readOnly;
  bool? isCheckOut;
  bool? isAutoFocus;
  bool? isHideCounterText;
  final String? Function(String?)? validator;

  TextFieldCustomForMPin(
      {Key? key,
        this.radiusField,
        this.isHideCounterText,
        this.focusNode,
        this.textAlign,
        this.suffixIcon,
        this.textFieldHeading,
        this.prefixIcon,
        this.obscureText,
        this.hintText,
        this.labelColor,
        this.controller,
        this.obscuringCharacter,
        this.keyboardType,
        this.onChanged,
        this.maxLength,
        this.errorText,
        this.inputFormatters,
        this.enabled,
        this.readOnly,
        this.isAutoFocus,
        this.isCheckOut,
        this.validator})
      : super(key: key);
  @override
  State<TextFieldCustomForMPin> createState() => _TextFieldCustomForMPinState();
}

class _TextFieldCustomForMPinState extends State<TextFieldCustomForMPin> {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: widget.textFieldHeading != null && widget.textFieldHeading != "" ? 23.0:0.0,
          width: Get.width,
          child: BuildText.buildText(
              text: widget.textFieldHeading ?? "",
              style: TextStyleCustom.textFieldStyle(),
              textAlign: TextAlign.left
          ),
        ),

        TextFormField(
          autofocus: widget.isAutoFocus ?? false,
          readOnly: widget.readOnly ?? false,
          cursorColor: AppColors.greyColorLight,
          focusNode: widget.focusNode,
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          enabled: widget.enabled,
          validator: widget.validator,
          // obscuringCharacter: widget.obscuringCharacter ?? ".",
          obscureText: widget.obscureText != null ? widget.obscureText! : false,
          maxLength: widget.maxLength ?? null,
          textAlign: widget.textAlign != null ? widget.textAlign! : TextAlign.start,
          textInputAction: TextInputAction.next,
          onChanged: widget.onChanged,
          style: widget.readOnly == true ? TextStyleCustom.textFieldStyle(color: AppColors.greyColorLight):TextStyleCustom.textFieldStyle(),
          // style: TextStyle(color: widget.readOnly == true ? CustomColors.greyLightColor:CustomColors.blackColor),
          decoration: InputDecoration(
            hintStyle: TextStyle(color: AppColors.greyColor,fontSize: 14,),
            counterText: "",
            label: Text(widget.hintText ?? "",),
            labelStyle: TextStyle(fontSize: 15.0,color: widget.labelColor ?? AppColors.greyColor,fontFamily: FontFamily.NexaRegular,),
            // hintText: widget.hintText,
            suffixIcon: widget.suffixIcon,
            suffixIconColor: AppColors.blackColor,
            prefixIcon: Padding(
                padding: const EdgeInsets.only(right: 10, left: 10),
                child: widget.prefixIcon
            ),
            prefixIconConstraints: const BoxConstraints(),
            prefixStyle: const TextStyle(height: 16,),
            filled: true,
            fillColor: widget.isCheckOut == true ? Colors.transparent:AppColors.greyColorLight,
            border: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: AppColors.textFieldActiveBorderColor,width: 1
              ),
              borderRadius: BorderRadius.circular(widget.radiusField ?? 8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.radiusField ?? 8),
              borderSide: BorderSide(
                  color: AppColors.textFieldBorderColor,width: 1
              ),
            ),
          ),
        ),

        Visibility(
            visible: (widget.errorText != null && widget.errorText != "") || (widget.isHideCounterText == true ? false:true),
            child: Padding(
              padding: const EdgeInsets.only(left: 2,top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Visibility(
                    visible: widget.errorText != null,
                    child: BuildText.buildText(
                        text: widget.errorText ?? "",
                        style: TextStyleCustom.textFieldStyle(
                            color:  widget.errorText != null && widget.errorText != "" ? AppColors.redColor:Colors.transparent
                        ),
                        textAlign: TextAlign.center
                    ),
                  ),

                  Visibility(
                    visible: widget.isHideCounterText == true ? false:true,
                    child: BuildText.buildText(
                        text: "${widget.controller?.text.length.toString() ?? ""}/${widget.maxLength.toString() ?? ""}",
                        style: TextStyleCustom.textFieldStyle(color: AppColors.greyColorDark),
                        textAlign: TextAlign.center
                    ),
                  ),

                ],
              ),
            )
        )
      ],
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


class TextFieldSimple extends StatelessWidget{
  TextEditingController controller;
  int? maxLength;
  TextInputType? keyboardType;
  List<TextInputFormatter>? inputFormatters;
  TextInputAction? textInputAction;
  bool? autofocus;
  InputDecoration? decoration;
  String? labelText;
  String? hintText;
  Color? fillColor;
  Color? outlineBorderColor;
  EdgeInsetsGeometry? contentPadding;
  double? borderRadius;
  InputBorder? enabledBorder;
  TextStyle? style;
  bool? readOnly;
  Widget? prefix;
  Function(String)? onChanged;
  TextFieldSimple({Key? key,
    required this.controller,
    this.maxLength,
    this.keyboardType,
    this.inputFormatters,
    this.textInputAction,
    this.autofocus,
    this.decoration,
    this.labelText,
    this.hintText,
    this.fillColor,
    this.contentPadding,
    this.outlineBorderColor,
    this.borderRadius,
    this.enabledBorder,
    this.style,
    this.readOnly,
    this.onChanged,
    this.prefix,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        SizedBox(
          width: Get.width,
          child: TextField(
            controller: controller,
            textInputAction: textInputAction ?? TextInputAction.next,
            keyboardType: keyboardType ?? TextInputType.emailAddress,
            maxLength: maxLength ?? 12,
            inputFormatters: inputFormatters,
            autofocus: autofocus ?? false,
            readOnly: readOnly ?? false,
            onChanged: onChanged ?? (value){

            },
            style: style ?? const TextStyle(decoration: TextDecoration.none),
            decoration: decoration ?? InputDecoration(
              labelText: labelText ?? "",
              fillColor: fillColor ??  Colors.white,
              hintText: hintText ?? "",
              filled: true,
              counterText: "",
                prefix: prefix ?? const SizedBox.shrink(),
              contentPadding: contentPadding ?? const EdgeInsets.only(left: 15.0, right: 15.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 50.0),
                borderSide: BorderSide(color: outlineBorderColor ?? AppColors.greyColorDark),
              ),
              enabledBorder: enabledBorder ?? OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 50.0),
                borderSide: BorderSide(color: outlineBorderColor ?? AppColors.greyColorDark),
              ),
            ),
          ),
        ),
      ],
    );
  }

}


class CustomTextFieldRaiseQuery extends StatelessWidget{

  Function(String)? onChanged;
  TextInputAction? textInputAction;
  TextEditingController? controller;
  TextInputType? keyboardType;
  FocusNode? focus;
  Function()? onTap;
  String? hintText;
  int? maxLine;
  Widget? prefixIcon;
  Widget? suffixIcon;
  bool? readOnly = false;
  bool? autofocus = false;
  bool? isWhiteBg;
  bool? isCheckOut;
  double? radiusField;
  String? errorText;

  CustomTextFieldRaiseQuery({
    Key? key,
    this.onChanged,
    this.textInputAction,
    this.controller,
    this.keyboardType,
    this.focus,
    this.maxLine,
    this.onTap,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly,
    this.autofocus,
    this.isWhiteBg,
    this.isCheckOut,
    this.radiusField,
    this.errorText,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 0.5,color: isWhiteBg == true ? AppColors.blackColor:AppColors.transparentColor),
          borderRadius: BorderRadius.circular(5.0)
      ),
      child: TextField(
        controller: controller,
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        style: TextStyle(color: AppColors.blackColor),
        readOnly: readOnly ?? false,
        autofocus: autofocus ?? false,
        focusNode: focus,
        onTap: onTap,
        maxLines: maxLine ?? 6,
        maxLength: 500,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintStyle: TextStyle(
            color: AppColors.greyColorDark,
            fontSize: 14,
          ),
          errorText: errorText,
          counterText: "",
          hintText: hintText,
          suffixIcon: suffixIcon,
          suffixIconColor: AppColors.blackColor,
          prefixIcon: Padding(
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: prefixIcon
          ),
          prefixIconConstraints: const BoxConstraints(),
          prefixStyle: const TextStyle(height: 16,),
          filled: true,
          fillColor: isCheckOut == true ? Colors.transparent:AppColors.textFieldBorderColor.withOpacity(0.1),
          border: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: AppColors.textFieldActiveBorderColor,width: 1
            ),
            borderRadius: BorderRadius.circular(radiusField ?? 30),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusField ?? 30),
            borderSide: BorderSide(
                color: errorText != null && errorText != "" ? AppColors.textFieldErrorBorderColor:AppColors.textFieldBorderColor,width: 1
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusField ?? 30),
            borderSide: BorderSide(
                color: AppColors.textFieldErrorBorderColor,width: 1
            ),
          ),
        ),
      ),
    );
  }

}



