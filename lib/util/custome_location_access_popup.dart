import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LocationAccessPopup {
  static showLocationPopUp(BuildContext context) {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Transform.scale(
                scale: a1.value,
                child: Opacity(
                  opacity: a1.value,
                  child: AlertDialog(
                    shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    titlePadding: EdgeInsets.zero,
                    title: Container(
                      height: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: Colors.red,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "Use your location",
                            style: TextStyle(fontSize: 17, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    actionsPadding: EdgeInsets.only(bottom: 10.0),
                    // actions: [button],
                    content: Text(
                      'Pharmdel collects location data of driver to create an optimised delivery route even when the app is closed or not in use. ',
                      style: TextStyle(fontSize: 17, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 40,
                                width: 100,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(width: 1, color: Colors.grey), color: Colors.white),
                                child: Center(
                                    child: Text(
                                  'No thanks',
                                  style: TextStyle(fontSize: 18, color: Colors.black),
                                )),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 40,
                                width: 100,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(width: 1, color: Colors.grey), color: Colors.white),
                                child: Center(
                                    child: Text(
                                  'Turn on',
                                  style: TextStyle(fontSize: 18, color: Colors.black),
                                )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        transitionDuration: Duration(milliseconds: 500),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return Text('');
        });
  }
}
