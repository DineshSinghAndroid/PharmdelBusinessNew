// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:progress_dialog/progress_dialog.dart';
import 'package:pharmdel_business/presenter/login_screen_presenter.dart';

import '../util/custom_loading.dart';
import '../util/sentryExeptionHendler.dart';
import 'branch_admin_user_type/branch_admin_dashboard.dart';

class SignupPage extends StatefulWidget {
  static String tag = 'signup-page';

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new SignupPageState();
  }
}

class SignupPageState extends State<SignupPage> implements LoginScreenContract {
  int _currVal = 1;
  String _currText = '';
  BuildContext _ctx;
  final scaffoldKey = new GlobalKey<ScaffoldMessengerState>();

  int _radioValue1 = -1;
  int correctScore = 0;
  int _radioValue2 = -1;
  int _radioValue3 = -1;
  int _radioValue4 = -1;
  int _radioValue5 = -1;
  final formKey = new GlobalKey<FormState>();
  LoginScreenPresenter _presenter;
  String _userType, _orgName, _contactPersonName, _mobile, _email, _address, _website, _password;

  SignupPageState() {
    _presenter = new LoginScreenPresenter(this);
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> _submit() async {
    final form = formKey.currentState;
    if (_userType != null) {
      if (form.validate()) {
        try {
          // ProgressDialog(context, isDismissible: false).show();
          await CustomLoading().showLoadingDialog(context, true);
          // setState(() => _isLoading = true);
          form.save();
        } catch (e, stackTrace) {
          SentryExemption.sentryExemption(e, stackTrace);
          // print(e);
        }
      }
    } else {
      Fluttertoast.showToast(msg: 'Select User Type', toastLength: Toast.LENGTH_SHORT);
    }
  }

  void _handleRadioValueChange1(int value) {
    setState(() {
      _radioValue1 = value;

      switch (_radioValue1) {
        case 0:
          _userType = "Hotel";
          //Fluttertoast.showToast(msg: 'Hotel', toastLength: Toast.LENGTH_SHORT);
          //correctScore++;
          break;
        case 1:
          _userType = "Company";
          //Fluttertoast.showToast(msg: 'Company', toastLength: Toast.LENGTH_SHORT);
          break;
        case 2:
          _userType = "Agent";
          //Fluttertoast.showToast(msg: 'Agent', toastLength: Toast.LENGTH_SHORT);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String _user;
    _ctx = context;

    final focus = FocusNode();
    final nameFocus = FocusNode();
    final mobileFocus = FocusNode();
    final emailFocus = FocusNode();
    final addressFocus = FocusNode();
    final websiteFocus = FocusNode();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    // Fluttertoast.showToast(msg: "signup",toastLength: Toast.LENGTH_LONG);
    var radiog = new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Radio(
          value: 0,
          groupValue: _radioValue1,
          onChanged: _handleRadioValueChange1,
        ),
        new Text(
          'Hotel',
          style: new TextStyle(fontSize: 16.0),
        ),
        new Radio(
          value: 1,
          groupValue: _radioValue1,
          onChanged: _handleRadioValueChange1,
        ),
        new Text(
          'Company',
          style: new TextStyle(
            fontSize: 16.0,
          ),
        ),
        new Radio(
          value: 2,
          groupValue: _radioValue1,
          onChanged: _handleRadioValueChange1,
        ),
        new Text(
          'Agent',
          style: new TextStyle(fontSize: 16.0),
        ),
      ],
    );

    final usertype = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Text(
          'Select User Type',
          style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
        ),
        radiog,
        new Padding(
          padding: new EdgeInsets.all(3.0),
        ),
      ],
    );

    var loginForm = new Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      new Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            SizedBox(height: 15.0),
            TextFormField(
              keyboardType: TextInputType.text,
              initialValue: '',
              autofocus: false,
              onSaved: (val) => _orgName = val,
              validator: (val) {
                return val.trim().isEmpty ? "Enter Organization Name" : null;
              },
              onFieldSubmitted: (v) {
                FocusScope.of(context).requestFocus(focus);
              },
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: 'Organization Name',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              keyboardType: TextInputType.text,
              initialValue: '',
              autofocus: false,
              focusNode: focus,
              onSaved: (val) => _contactPersonName = val,
              validator: (val) {
                return val.trim().isEmpty ? "Enter Contact Person Name" : null;
              },
              onFieldSubmitted: (v) {
                FocusScope.of(context).requestFocus(nameFocus);
              },
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: 'Contact Person Name',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              keyboardType: TextInputType.phone,
              initialValue: '',
              autofocus: false,
              focusNode: nameFocus,
              onSaved: (val) => _mobile = val,
              validator: (val) {
                return val.trim().isEmpty ? "Enter Mobile" : null;
              },
              onFieldSubmitted: (v) {
                FocusScope.of(context).requestFocus(mobileFocus);
              },
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: 'Mobile',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              initialValue: '',
              autofocus: false,
              focusNode: mobileFocus,
              onSaved: (val) => _email = val,
              validator: (val) {
                return val.trim().isEmpty ? "Enter Email" : null;
              },
              onFieldSubmitted: (v) {
                FocusScope.of(context).requestFocus(emailFocus);
              },
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: 'Email',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              keyboardType: TextInputType.text,
              initialValue: '',
              autofocus: false,
              focusNode: emailFocus,
              onSaved: (val) => _address = val,
              validator: (val) {
                return val.trim().isEmpty ? "Enter Address" : null;
              },
              onFieldSubmitted: (v) {
                FocusScope.of(context).requestFocus(addressFocus);
              },
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: 'Address',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              keyboardType: TextInputType.text,
              initialValue: '',
              autofocus: false,
              focusNode: addressFocus,
              onSaved: (val) => _website = val,
              validator: (val) {
                return val.trim().isEmpty ? "Enter Website" : null;
              },
              onFieldSubmitted: (v) {
                FocusScope.of(context).requestFocus(websiteFocus);
              },
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: 'Website',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              autofocus: false,
              initialValue: '',
              obscureText: true,
              focusNode: websiteFocus,
              textInputAction: TextInputAction.done,
              onSaved: (val) => _password = val,
              validator: (val) {
                return val.trim().isEmpty ? "Enter Password" : null;
              },
              decoration: InputDecoration(
                hintText: 'Password',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              ),
            )
          ],
        ),
      )
    ]);

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: EdgeInsets.all(12),
          backgroundColor: Colors.green,
        ),
        onPressed: () {
          _submit();
          /*Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));*/
          // Navigator.of(context).pushNamed(HomePage.tag);
        },
        child: Text('Signup', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        iconTheme: IconThemeData(
          color: Colors.white, //c// hange your color here
        ),
        title: const Text('Signup', style: TextStyle(color: Colors.white)),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context, false);
            }),
        // centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            SizedBox(height: 20.0),
            usertype,
            SizedBox(height: 12.0),
            loginForm,
            SizedBox(height: 24.0),
            loginButton,
          ],
        ),
      ),
    );
  }

  /* child: SingleChildScrollView(
  child: new Center(
  //height: double.infinity,
  //color: Colors.white,
  // child: new Center(
  child: new Align(
  alignment: Alignment.center,
  child: loginForm,
  )
  //),
  ),
  ),*/

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
      // Navigator.of(_ctx).pushNamed(HomePage.tag);
      // Navigator.push(_ctx, MaterialPageRoute(builder: (context) => HomePage()));
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => BranchAdminDashboard(),
          ),
          ModalRoute.withName('/'));
      /* var authStateProvider = new AuthStateProvider();
        authStateProvider.notify(AuthState.LOGGED_IN);*/
      // _showSnackBar("Login success");
    }
  }
}

class GroupModel {
  String text;
  int index;

  GroupModel({this.text, this.index});
}
