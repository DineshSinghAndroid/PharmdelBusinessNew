import 'package:flutter/material.dart';
import 'package:pharmdel/Controller/Helper/Colors/custom_color.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';
import '../../Controller/WidgetController/StringDefine/StringDefine.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BuildText.buildText(
          text: kCustomerList,
          color: AppColors.blackColor,
          size: 18,
          weight: FontWeight.bold
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          color: AppColors.colorOrange,
          child: Center(
            child: BuildText.buildText(
              text: kAddNewCustomer,
              color: AppColors.whiteColor,
              size: 16),
          ),
        ),
      ),
    );
  }
}