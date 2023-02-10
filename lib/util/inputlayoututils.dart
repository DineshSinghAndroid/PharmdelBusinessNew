// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class InputLayoutWidiget extends StatelessWidget {
  final OnTextChanged onChanged;
  var yetToStartColor = const Color(0xFFF8A340);
  var labelText = "";
  TextEditingController textEditingController;
  FocusNode focus;
  bool enable;

  TextInputType inputType;
  TextInputAction inputAction;

  String hintText;
  String errorText;

  int maxLength = 100;
  int maxLines = 1;
  TextCapitalization textCapitalization;

  InputLayoutWidiget({this.enable, this.onChanged, this.labelText, this.inputType, this.inputAction, this.hintText, this.maxLength, this.maxLines, this.errorText, this.focus, this.textEditingController, this.textCapitalization});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: new TextFormField(
        validator: (val) {
          return val.trim().isEmpty ? "Enter Username" : null;
        },
        textCapitalization: textCapitalization == null ? TextCapitalization.characters : textCapitalization,
        textInputAction: inputAction,
        keyboardType: inputType,
        autofocus: false,
        enabled: enable,
        maxLength: maxLength,
        maxLines: maxLines,
        controller: textEditingController,
        decoration: new InputDecoration(
            contentPadding: EdgeInsets.only(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0),
            // suffixIcon: IconButton(
            //   onPressed: textEditingController.clear,
            //   icon: textEditingController.text.length > 0 ? Icon(Icons.clear) : Icon(Icons.add_rounded),
            // ),
            counter: Offstage(),
            hintText: hintText,
            errorText: errorText,
            labelText: labelText,
            border: new OutlineInputBorder(borderRadius: const BorderRadius.all(const Radius.circular(5.0)))),
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(focus);
        },
        onChanged: (value) {
          if (onChanged != null) onChanged(value);
        },
      ),
    );
    throw UnimplementedError();
  }
}

typedef OnTextChanged = void Function(String value);
