// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UnderMaintenance extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(margin: EdgeInsets.only(top: 60), height: 250, child: Image.asset("assets/under_maintenance.png")),
          ),
          SizedBox(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "We were under maintenance",
                  style: TextStyle(color: Colors.black, fontSize: 22),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "PharmDel services will be under scheduled maintenance on 13 Dec, 2021 04:30 AM to 06:30 AM GMT, Sorry for the inconvenience.",
                    style: TextStyle(color: Colors.grey[600], fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
                  child: MaterialButton(color: Colors.blue, textColor: Colors.white, onPressed: () async {}, child: Text("Ok")),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
