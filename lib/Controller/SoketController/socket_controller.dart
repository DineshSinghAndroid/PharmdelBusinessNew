import 'dart:async';

class StreamSocket {
  static final StreamSocket _singleton = StreamSocket._internal();

  factory StreamSocket() {
    return _singleton;
  }

  StreamSocket._internal() : super();


  final _socketResponse = StreamController<dynamic>();
  var _socketResponseOutFoDelivery = StreamController<dynamic>();

  void Function(dynamic) get addLocationResponse => _socketResponse.sink.add;

  void Function(dynamic) get addResponse => _socketResponse.sink.add;

  void Function(dynamic) get addResponseOutForDelivery => _socketResponseOutFoDelivery.sink.add;

  Stream<dynamic> get getResponse => _socketResponse.stream;

  Stream<dynamic> get getResponseOutForDeliveyr => _socketResponseOutFoDelivery.stream;

  void dispose() {
    _socketResponse.close();
    _socketResponseOutFoDelivery.close();
  }

  void repoenSocketOutForDelivery() {
    _socketResponseOutFoDelivery.close();
    _socketResponseOutFoDelivery = StreamController<dynamic>();
  }
}

