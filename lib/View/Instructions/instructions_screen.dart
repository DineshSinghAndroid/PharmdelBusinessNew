import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/Helper/Colors/custom_color.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';
import '../../Controller/RouteController/RouteNames.dart';
import '../../Controller/WidgetController/StringDefine/StringDefine.dart';

class InstructionScreen extends StatefulWidget {
  const InstructionScreen({Key? key}) : super(key: key);

  @override
  State<InstructionScreen> createState() => _InstructionScreenState();
}

class _InstructionScreenState extends State<InstructionScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: const Padding(
                  padding: EdgeInsets.only(top: 15.0, left: 10.0),
                  child: Icon(Icons.arrow_back,size: 25, color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 10.0, top: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// Title
                    buildSizeBox(10.0, 0.0),
                    BuildText.buildText(text: kInstructionTitle,size: 16,weight: FontWeight.w600,color: AppColors.blueColor,),

                    /// Description
                    buildSizeBox(10.0, 0.0),
                    BuildText.buildText(text: kInstructionsDes,size: 13,color: AppColors.greyColor,),

                    buildSizeBox(30.0, 0.0),

                    /// List
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: kInstructionsTitle.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [

                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.grey[200],
                                    radius: 15.0,
                                    child: BuildText.buildText(text: "${index + 1}"),
                                  ),
                                  VerticalDivider(
                                    endIndent: 5.0,
                                    indent: 5.0,
                                    color: AppColors.greyColor,
                                  ),
                                ],
                              ),
                              title: index == 1
                                  ? RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(text: "$kPress ", style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w600, color: Colors.black)),
                                    WidgetSpan(
                                      child: Icon(
                                        Icons.add_circle,
                                        size: 14,
                                        color: AppColors.blueColor,
                                      ),
                                    ),
                                    TextSpan(text: kInstructionsTitle[index].toString(), style: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.w600, color: Colors.black)),
                                  ],
                                ),
                              )
                                  : Text(
                                kInstructionsTitle[index].toString(),
                                style: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text(
                                kInstructionsTitle[index].toString(),
                                style: const TextStyle(fontSize: 12.0),
                              ),
                              horizontalTitleGap: 0.0,
                            ),

                            const Divider(height: 0.0),
                            buildSizeBox(10.0, 0.0),

                          ],
                        );
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
        child: SizedBox(
          width:Get.width,
          child: SizedBox(
            height: 45,
            width: 110,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                elevation: 2.0,
                backgroundColor: Colors.blue,
              ),
              onPressed: () {
                Get.toNamed(bulkDeliveryListScreenRoute)?.then((value) {
                  Get.back();
                });
              },
              child: BuildText.buildText(
                  text: kStartBulkDrop,size: 16,color: AppColors.whiteColor, weight: FontWeight.w700
              )
            ),
          ),
        ),
      ),
    );
  }
}
