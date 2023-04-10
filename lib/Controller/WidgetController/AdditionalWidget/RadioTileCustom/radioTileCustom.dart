import 'package:flutter/material.dart';
import '../../../Helper/Colors/custom_color.dart';
import '../../../Helper/TextController/BuildText/BuildText.dart';

class RadioTileCusotm extends StatefulWidget {
  String? text;
  Color? bgColor;
  VoidCallback? onTap;

  RadioTileCusotm({super.key, required this.text, required this.bgColor, required this.onTap});

  @override
  State<RadioTileCusotm> createState() => _RadioTileCusotmState();
}

class _RadioTileCusotmState extends State<RadioTileCusotm> {
  bool? isSelect;
  @override
  Widget build(BuildContext context,) {
    return Row(
      children: [
        Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.greyColorDark, width: 2),
              shape: BoxShape.circle),
          child: InkWell(
            onTap: widget.onTap,            
            child: Container(
              margin: const EdgeInsets.all(2),
              height: 15,
              width: 15,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: isSelect == true ? AppColors.purpleColor : AppColors.whiteColor),
            ),
          ),
        ),
        buildSizeBox(0.0, 10.0),
        Container(
          alignment: Alignment.center,
          height: 30,
          width: 90,
          decoration: BoxDecoration(
              color: widget.bgColor,
              borderRadius: BorderRadius.circular(10)),
          child: BuildText.buildText(
              text: widget.text!, color: AppColors.whiteColor, size: 12),
        )
      ],
    );
  }
}
