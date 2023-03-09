import 'package:flutter/material.dart';

import '../../../Helper/Colors/custom_color.dart';
import '../../../Helper/TextController/BuildText/BuildText.dart';

class PharmacyDrawerTile extends StatelessWidget {
  String? text;
  VoidCallback? ontap;
  PharmacyDrawerTile({super.key,required this.ontap,required this.text,});

  @override
  Widget build(BuildContext context) {      
    return InkWell(
      onTap: ontap,
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            BuildText.buildText(
              text: text ?? "",
              size: 17,
              color: AppColors.blackColor,              
            ),
            const Icon(
              Icons.arrow_forward_ios_sharp,
              size: 17,
            ),
          ],
        ),
      ),
    );
  
}
  }
