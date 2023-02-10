import 'package:flutter/material.dart';

import 'bulk_delivery_list.dart';

class SuggestionScreen extends StatefulWidget {
  const SuggestionScreen({Key? key}) : super(key: key);

  @override
  _SuggestionScreenState createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends State<SuggestionScreen> {
  List<String> title = ["Scan the package you wish to deliver", " to add multiple orders", "Complete Bulk Drop "];
  List<String> content = ["Scan the package barcode", "Scan barcode and add multiple orders", "Complete the multiple order at a place"];

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
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 15.0, left: 10.0),
                  child: Icon(
                    Icons.arrow_back,
                    size: 25,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 10.0, top: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "Instructions to Bulk Drop",
                      style: TextStyle(color: Colors.blue, fontSize: 16.0, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "Please correlate the package when scanning.",
                      style: TextStyle(color: Colors.grey, fontSize: 13.0),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: title.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Container(
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircleAvatar(
                                      child: Text(
                                        "${index + 1}",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      backgroundColor: Colors.grey[200],
                                      radius: 15.0,
                                    ),
                                    VerticalDivider(
                                      endIndent: 5.0,
                                      indent: 5.0,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                                title: index == 1
                                    ? RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(text: "Press ", style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w600, color: Colors.black)),
                                            WidgetSpan(
                                              child: Icon(
                                                Icons.add_circle,
                                                size: 14,
                                                color: Colors.blue,
                                              ),
                                            ),
                                            TextSpan(text: title[index], style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w600, color: Colors.black)),
                                          ],
                                        ),
                                      )
                                    : Text(
                                        title[index],
                                        style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w600),
                                      ),
                                subtitle: Text(
                                  content[index],
                                  style: TextStyle(fontSize: 12.0),
                                ),
                                horizontalTitleGap: 0.0,
                              ),
                            ),
                            Divider(
                              height: 0.0,
                            ),
                            SizedBox(
                              height: 10.0,
                            )
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
        child: Container(
          width: MediaQuery.of(context).size.width,
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => BulkDeliveryList())).then((value) {
                  Navigator.pop(context);
                });
              },
              child: new Text(
                "Start Bulk Drop",
                style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
