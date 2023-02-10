// @dart=2.9
class User {
  String _userId;
  String _token;
  String _name;
  String _email;
  String _mobile;
  String _userType;

  User(this._userId, this._token, this._name, this._email, this._mobile, this._userType);

  User.map(dynamic obj) {
    this._userId = obj["userId"];
    this._token = obj["token"];
    this._name = obj["name"];
    this._email = obj["email"];
    this._mobile = obj["mobile"];
    this._userType = obj["userType"];
  }

  String get userId => userId;

  String get token => token;

  String get name => name;

  String get email => email;

  String get mobile => mobile;

  String get userType => userType;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["userId"] = userId;
    map["token"] = token;
    map["name"] = name;
    map["email"] = email;
    map["mobile"] = mobile;
    map["userType"] = userType;

    return map;
  }

  factory User.fromMap(Map<String, dynamic> json) {
    return User(json['userId'], json['token'], json['name'], json['email'], json['mobile'], json["userType"]);
  }
}
