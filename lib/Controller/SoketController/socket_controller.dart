import 'dart:async';
import 'package:flutter/material.dart';
import '../../main.dart';


// STEP1:  Stream setup
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

//STEP2: Add this function in main function in main.dart file and add incoming data to the stream
void connectAndListen() {
  // try {
  //   IO.Socket socket = IO.io(
  //     'ws://88.208.224.51:3000/socket.io/?EIO=4&transport=websocket&t=O3XL9a7',);
  //
  //   socket.onConnect((_) {
  //     print('connect');
  //     socket.emit('msg', 'test');
  //   });
  //
  //   //When an event recieved from server, data is added to the stream
  //   socket.on('event', (data) {
  //     streamSocket.addResponse;
  //   });
  //   socket.onDisconnect((_) {
  //     print('disconnect');
  //   }
  //   );
  //   socket.connect();
  // }catch(Ex){
  //   print(Ex);
  // }
}

//Step3: Build widgets with streambuilder

class BuildWithSocketStream extends StatefulWidget {
  const BuildWithSocketStream({
    required this.title,
  });

  final String title;

  @override
  State<BuildWithSocketStream> createState() => _BuildWithSocketStreamState();
}

class _BuildWithSocketStreamState extends State<BuildWithSocketStream> {
  var countUP = 0;

  @override
  void initState() {
    connectAndListen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: streamSocket.getResponse,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return Column(
          children: [
            Text("${snapshot.data}"),
            ElevatedButton(
              onPressed: () {
                countUP += 1;
                socket.emit('sendChatToServer', ' $countUP');
              },
              child: const Text("Send"),
            )
          ],
        );
      },
    );
  }
}
