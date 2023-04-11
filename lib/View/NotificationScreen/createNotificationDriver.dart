import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';

import '../../Controller/ProjectController/NotificationController/driver_create_notification_controller.dart';

class createNotificationDriver extends StatefulWidget {
  String customerId;

  createNotificationDriver({Key? key, required this.customerId}) : super(key: key);

  @override
  State<createNotificationDriver> createState() => _createNotificationDriverState();
}

DriverCreateNotificationController createNotf = Get.put(DriverCreateNotificationController());

class _createNotificationDriverState extends State<createNotificationDriver> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createNotf.messageController.clear();
    createNotf.notificationNameController.clear();
    createNotf.customerId = widget.customerId;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: createNotf,
      builder: (controller) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: const Text(kCreateNotification),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      kNotificationName,
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      controller: createNotf.notificationNameController,
                      onFieldSubmitted: (v) {},
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.emailAddress,
                      autofocus: false,
                      decoration: const InputDecoration(hintText: kName, border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))),
                    ),
                    buildSizeBox(5.0, 0.0),
                    buildSizeBox(5.0, 0.0),
                    const Text(
                      kMessage,
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                    ),
                    buildSizeBox(10.0, 0.0),
                    TextFormField(
                      controller: createNotf.messageController,
                      onFieldSubmitted: (v) {},
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.emailAddress,
                      autofocus: false,
                      decoration: const InputDecoration(hintText: kMessage, border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))),
                    ),
                    buildSizeBox(15.0, 0.0),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(bottom: 20.0, left: 12.0, right: 12.0),
              child: Container(
                margin: const EdgeInsets.only(left: 0, right: 0, top: 20, bottom: 0),
                width: MediaQuery.of(context).size.width,
                child: MaterialButton(
                    color: Colors.black,
                    height: 50,
                    onPressed: (){controller.checkValidation(context);},
                    child: const Text(
                      kSubmit,
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    )),
              ),
            ),
          ),
        );
      },
    );
  }

// Future<void> SaveScreenshot() async {
//   FilePickerResult? result = await FilePicker.platform.pickFiles(
//     type: FileType.image,
//     allowedExtensions: ['jpg','jpeg', 'pdf', 'doc'],
//   );
// }
}
