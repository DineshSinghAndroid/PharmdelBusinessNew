// @dart=2.9
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:progress_dialog/progress_dialog.dart';
import 'package:pharmdel_business/presenter/login_screen_presenter.dart';
import 'package:pharmdel_business/ui/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/web_constent.dart';
import '../util/custom_loading.dart';
import 'branch_admin_user_type/branch_admin_dashboard.dart';

class DeliveryPage extends StatefulWidget {
  static String tag = 'signup-page';

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new DeliveryPageState();
  }
}

class DeliveryPageState extends State<DeliveryPage> implements LoginScreenContract {
  int _currVal = 1;
  String _currText = '';
  BuildContext _ctx;

  // ProgressDialog progressDialog;
  GoogleMapController mapController;

  final scaffoldKey = new GlobalKey<ScaffoldMessengerState>();
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(bearing: 192.8334901395799, target: LatLng(37.43296265331129, -122.08832357078792), tilt: 59.440717697143555, zoom: 19.151926040649414);

  @override
  void initState() {
    super.initState();
  }

  void _asyncConfirmDialog() {
    showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(WebConstant.LOGOUT),
          content: const Text(WebConstant.ARE_YOU_SURE_LOGOUT),
          actions: <Widget>[
            TextButton(
              child: const Text(WebConstant.CANCEL),
              onPressed: () {
                Navigator.pop(_ctx);
              },
            ),
            TextButton(
              child: const Text(WebConstant.YES),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.remove('token');
                prefs.remove('userId');
                prefs.remove('name');
                prefs.remove('email');
                prefs.remove('mobile');
                Navigator.pushAndRemoveUntil(
                    context,
                    PageRouteBuilder(pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
                      return LoginScreen();
                    }, transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
                      return new SlideTransition(
                        position: new Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      );
                    }),
                    (Route route) => false);
              },
            )
          ],
        );
      },
    );
    // Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    String _user;
    _ctx = context;

    const PrimaryColor = const Color(0xFFffffff);
    const titleColor = const Color(0xFF151026);
    return Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          centerTitle: true,
          title: const Text(WebConstant.DELIVERY_LIST, style: TextStyle(color: Colors.black)),
          backgroundColor: PrimaryColor,
          leading: new Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: _asyncConfirmDialog,
                child: CircleAvatar(
                  backgroundImage: NetworkImage('https://picsum.photos/250?image=9'),
                ),
              )),
        ),
        body: Container(
          height: 200,
          child: GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
        ));
  }

  @override
  Future<void> onLoginError(String errorTxt) async {
    _showSnackBar(errorTxt);
    // ProgressDialog(context).hide();
    await CustomLoading().showLoadingDialog(context, false);

    //setState(() => _isLoading = false);
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(text)));
  }

  @override
  void onLoginSuccess(Map<String, Object> user) async {
    // ProgressDialog(context).hide();
    await CustomLoading().showLoadingDialog(context, false);

    // _showSnackBar(user.toString());
    //setState(() => _isLoading = false);
    var status = user['status'];
    var uName = user['message'];
    if (status == 1) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => BranchAdminDashboard(),
          ),
          ModalRoute.withName('/'));
    }
  }
}

class GroupModel {
  String text;
  int index;

  GroupModel({this.text, this.index});
}
