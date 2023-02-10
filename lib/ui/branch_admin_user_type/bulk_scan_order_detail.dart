//@dart=2.9
import 'package:flutter/material.dart';

import '../../util/colors.dart';
import '../../util/custom_color.dart';
import '../../util/text_style.dart';

class BulkScanOrderDetails extends StatefulWidget {
  const BulkScanOrderDetails({Key key}) : super(key: key);

  @override
  State<BulkScanOrderDetails> createState() => _BulkScanOrderDetailsState();
}

class _BulkScanOrderDetailsState extends State<BulkScanOrderDetails> {
  TextEditingController remarkController = TextEditingController();

  String dropdownValue = "Unpick";

  bool value1 = false;
  bool value = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: materialAppThemeColor,
        title: Text("Details"),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  color: CustomColors.yetToStartColor,
                ),
                SizedBox(
                  width: 8.0,
                ),
                Text(
                  "Patient Details",
                  style: Regular16Style.copyWith(color: CustomColors.yetToStartColor),
                ),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 31.0),
              child: FittedBox(
                child: Text(
                  "Dummy Name",
                  style: TextStyleblueGrey14,
                ),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 31.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: Text(
                      "1 Kingsway, Second floor, Cardiff CF10 3AQ",
                      style: TextStyleblueGrey14,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey[700]), borderRadius: BorderRadius.circular(50.0)),
                child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        isExpanded: true,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle8Black,
                        underline: Container(
                          height: 2,
                          color: Colors.black,
                        ),
                        onChanged: (String newValue) {
                          dropdownValue = newValue;
                          setState(() {});
                        },
                        items: <String>[
                          'Unpick',
                          'Cancelled',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle8Black,
                            ),
                          );
                        }).toList(),
                      ),
                    )),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: new TextField(
                controller: remarkController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                autofocus: false,
                decoration: new InputDecoration(
                    labelText: "Delivery remark",
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.only(left: 15.0, right: 15.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      borderSide: BorderSide(color: Colors.grey[200]),
                    )),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 30,
                      padding: EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.blue,
                      ),
                      child: Row(
                        children: [
                          Checkbox(
                            visualDensity: VisualDensity(horizontal: -4),
                            value: value,
                            onChanged: (newValue) {
                              setState(() {
                                value = newValue;
                              });
                            },
                          ),
                          Image.asset(
                            "assets/fridge.png",
                            height: 21,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: 30,
                      padding: EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.red,
                      ),
                      child: Row(
                        children: [
                          Checkbox(
                            visualDensity: VisualDensity(horizontal: -4),
                            value: value1,
                            onChanged: (newValue) {
                              setState(() {
                                value1 = newValue;
                              });
                            },
                          ),
                          new Text(
                            'C. D.',
                            style: TextStyle6White,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 4, right: 4, top: 15, bottom: 10),
                child: new SizedBox(
                  width: MediaQuery.of(context).size.width - 20,
                  height: 45,
                  child: new ElevatedButton(
                    onPressed: () {},
                    child: new Text(
                      "Update Status",
                      style: TextStyle6White,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
