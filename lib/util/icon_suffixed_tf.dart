// @dart=2.9
import 'package:flutter/material.dart';
import 'package:pharmdel_business/util/network_utils.dart';

class IconSuffixedTF extends StatelessWidget {
  final double height;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String placeHolder;
  final bool isValidValue;
  final Icon suffixIcon;

  IconSuffixedTF({this.height, this.controller, this.focusNode, this.placeHolder, this.isValidValue, this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(4),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              textAlign: TextAlign.left,
              cursorColor: Colors.black,
              controller: controller,
              focusNode: focusNode,
              style: kTextFieldTextStyle,
              textAlignVertical: TextAlignVertical.bottom,
              decoration: InputDecoration(
                suffixIcon: isValidValue
                    ? null
                    : Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                hintText: '',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    borderSide: BorderSide.none),
                hintStyle: kTextFieldTextStyle.copyWith(color: Colors.grey.shade400),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: suffixIcon,
          )
        ],
      ),
    );
  }
}
