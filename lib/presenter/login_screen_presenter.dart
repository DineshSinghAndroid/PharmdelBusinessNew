import 'package:pharmdel_business/data/rest_ds.dart';

abstract class LoginScreenContract {
  void onLoginSuccess(Map<String, Object> user);

  void onLoginError(String errorTxt);
}

class LoginScreenPresenter {
  LoginScreenContract _view;
  RestDatasource api = new RestDatasource();

  LoginScreenPresenter(this._view);

  doLogin(String username, String password, String deviceName, String fcm_token) {
    api.loginGetMethod(username, password, deviceName, fcm_token).then((Map<String, Object> user) {
      _view.onLoginSuccess(user);
      // print(".............$user");
    }).catchError((error) => {
          _view.onLoginError(error.toString())
          // _view.onLoginError("Something went wrong, Failed connection with server.")
        });
  }
}
