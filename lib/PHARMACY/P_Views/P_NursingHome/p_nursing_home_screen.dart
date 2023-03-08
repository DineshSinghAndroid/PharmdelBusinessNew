import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pharmdel/Controller/Helper/Colors/custom_color.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';
import 'package:pharmdel/Controller/WidgetController/AdditionalWidget/Default%20Functions/defaultFunctions.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';

class NursingHomeScreen extends StatefulWidget {
  const NursingHomeScreen({super.key});

  @override
  State<NursingHomeScreen> createState() => _NursingHomeScreenState();
}

class _NursingHomeScreenState extends State<NursingHomeScreen> {
  String selectedDate = "";
  String showDatedDate = "";
  String? _chosenValue;
  int selectedNursingPosition = 0;

  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final DateFormat formatterShow = DateFormat('dd-MM-yyyy');

  @override
  void initState() {
    final DateTime now = DateTime.now();
    selectedDate = formatter.format(now);
    showDatedDate = formatterShow.format(now);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BuildText.buildText(text: kBulkScan, size: 18),
        backgroundColor: AppColors.whiteColor,
        iconTheme: IconThemeData(color: AppColors.blackColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(5),
                    height: 50,
                    decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _chosenValue,
                        items: <String>[
                          'Android',
                          'IOS',
                          'Flutter',
                          'Node',
                          'Java',
                          'Python',
                          'PHP',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        hint: BuildText.buildText(
                          text: kSelectRoute,
                          color: AppColors.blackColor,
                          size: 14,
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            _chosenValue = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                buildSizeBox(0.0, 10.0),
               Flexible(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(5),
                    height: 50,
                    decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _chosenValue,
                        items: <String>[
                          'Android',
                          'IOS',
                          'Flutter',
                          'Node',
                          'Java',
                          'Python',
                          'PHP',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        hint: BuildText.buildText(
                          text: kSelectDriver,
                          color: AppColors.blackColor,
                          size: 14,
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            _chosenValue = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            buildSizeBox(10.0, 0.0),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: InkWell(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(DateTime.now().year,
                              DateTime.now().month, DateTime.now().day),
                          lastDate: DateTime(2101));
                      if (picked != null) {
                        setState(() {
                          selectedDate = formatter.format(picked);
                          showDatedDate = formatterShow.format(picked);
                        });
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      padding: const EdgeInsets.only(
                          left: 10.0, top: 10, bottom: 10, right: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: AppColors.whiteColor,
                      ),
                      child: Row(
                        children: [
                          Text(showDatedDate),
                          const Spacer(),
                          const Icon(Icons.calendar_today_sharp)
                        ],
                      ),
                    ),
                  ),
                ),
                buildSizeBox(0.0, 10.0),
                Flexible(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(5),
                    height: 50,
                    decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _chosenValue,
                        items: <String>[
                          'Android',
                          'IOS',
                          'Flutter',
                          'Node',
                          'Java',
                          'Python',
                          'PHP',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        hint: BuildText.buildText(
                          text: kSelectNursHome,
                          color: AppColors.blackColor,
                          size: 14,
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            _chosenValue = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: Transform.translate(
        offset: const Offset(20, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FloatingActionButton.extended(
                backgroundColor: AppColors.colorOrange,
                onPressed: () {
                  DefaultFuntions.barcodeScanning();
                },
                label: Column(
                  children: [
                    Icon(
                      Icons.qr_code_scanner,
                      color: AppColors.whiteColor,
                    ),
                    BuildText.buildText(
                        text: kScanRx, color: AppColors.whiteColor),
                  ],
                )),
            FloatingActionButton.extended(
                onPressed: () {},
                label: BuildText.buildText(
                    text: kCloseTote, color: AppColors.whiteColor)),
          ],
        ),
      ),
    );
  }
}
