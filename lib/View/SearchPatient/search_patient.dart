import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';

class SearchPatientScreen extends StatefulWidget {
  const SearchPatientScreen({super.key});

  @override
  State<SearchPatientScreen> createState() => _SearchPatientScreenState();
}

class _SearchPatientScreenState extends State<SearchPatientScreen> {

bool noData = false;
bool isLoading = false;

TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        leading: Icon(
          Icons.arrow_back,
          color: AppColors.blackColor,
        ),
        flexibleSpace: Container(
          margin: const EdgeInsets.only(left: 30),
          color: Colors.transparent,
          child: Container(
            height: 40,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: TextFormField(
              textAlign: TextAlign.start,
              controller: searchController,
              decoration: const InputDecoration(
                  focusColor: Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  filled: true,
                  fillColor: Colors.transparent,
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.black38),
                  hintText: kSearchPat),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                //height: MediaQuery.of(context).size.height/1.5,
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  strIMG_HomeBg,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            CustomScrollView(slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildListDelegate([
                      noData == true
                          ? const SizedBox(
                              height: 200,
                              child: Center(
                                child: Text(
                                  kNoPatAvl,
                                  style: TextStyle(color: Colors.black38, fontSize: 24),
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ]),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                          padding: const EdgeInsets.all(4),
                          child:  Center(
                            child: isLoading == true ? const CircularProgressIndicator() : const SizedBox(height: 8.0),
                          ))
                    ]),
                  ),
          ],
        ),
          ])
    )
    );
  }

  SliverList _getSlivers(List myList, BuildContext context, double? c_width) {
    const blue = Color(0xFF2188e5);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Visibility(
              // visible: showList,
              child:  InkResponse(
                onTap: (){},
                child:  Padding(
                  padding: const EdgeInsets.only(top: 1, bottom: 0, left: 3, right: 3),
                  child:  Card(
                    color: Colors.primaries[Random().nextInt(Colors.primaries.length)].shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child:  Row(
                        children: [
                           Expanded(
                            flex: 4,
                            child: Column(
                              children: [
                                 Padding(
                                  padding: const EdgeInsets.all(4),
                                  child:  Row(
                                    children: [
                                       BuildText.buildText(
                                        text: "$kName :",
                                        size: 14,
                                        color: AppColors.greyColor,                                        
                                      ),
                                      Flexible(
                                        child: RichText(
                                          text: TextSpan(
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              color: AppColors.blackColor,
                                            ),
                                            children: const <TextSpan>[
                                               TextSpan(
                                                text: "First Name",
                                                style: TextStyle(fontSize: 14, color: Colors.black),
                                              ),
                                               TextSpan(text: "Middle Name", style:  TextStyle(fontSize: 14, color: Colors.black)),
                                               TextSpan(text: "LAst Name", style:  TextStyle(fontSize: 14, color: Colors.black)),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4),
                                  child:  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [                                    
                                      BuildText.buildText(
                                        text: "$kAddress :",
                                        size: 14,
                                        color: AppColors.greyColor,                                        
                                      ),
                                 
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Flexible(
                                              child:  BuildText.buildText(
                                                text: "Address 1", textAlign: TextAlign.left),
                                            ),
                                            // if (list != null && list.isNotEmpty && list[index]['alt_address'] != null && list[index]['alt_address'] != "" && list[index]['alt_address'].toString() == "t")
                                              Image.asset(
                                                strIMG_AltAdd,
                                                height: 18,
                                                width: 18,
                                              ),
                                          ],
                                        ),
                                      ),
                                    
                                    ],
                                  ),
                                ),
                               
                                 Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Row(
                                    children: [
                                       BuildText.buildText(
                                        text: 'Date of Birth : ',
                                        size: 14,
                                        color: AppColors.greyColor,                                        
                                      ),
                                       BuildText.buildText(
                                        text: "DOB",
                                        size: 14,
                                        color: AppColors.blackColor,                                        
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ), 
                        ],
                      ),
                    ),
                  ),
                ),
              ));
        },
        childCount: myList.length,
      ),
    );
  }
}
