// import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
//
// import 'log_print.dart';
//
// class PusherUtils{
//
//   PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
//   static String apikye = "c780bd2e243a7af5d6e7";
//   static String cluster = "ap2";
//   static String channelName = "private-DriverCheck";
//   static String eventName = "DriverExist";
//
//   static final PusherUtils _singleton = PusherUtils._internal();
//
//   factory PusherUtils() {
//     return _singleton;
//   }
//
//   PusherUtils._internal() : super();
//   void connectPusher(){
//
//   }
//   void onConnectPressed() async {
//     logger.i("Pusher connted ${pusher.connectionState}");
//       try {
//         await pusher.init(
//           apiKey: apikye,
//           cluster: cluster,
//           onConnectionStateChange: onConnectionStateChange,
//           // onError:(String message, int code, e) async {
//           //   assert(e != null);
//           //
//           // },
//           onSubscriptionSucceeded: onSubscriptionSucceeded,
//           onEvent: onEvent,
//           onSubscriptionError: onSubscriptionError,
//           onDecryptionFailure: onDecryptionFailure,
//           onMemberAdded: onMemberAdded,
//           onMemberRemoved: onMemberRemoved,
//           // authEndpoint: "<Your Authendpoint Url>",
//           // onAuthorizer: onAuthorizer
//         );
//
//       } catch (e) {
//         log("ERROR: $e");
//       }
//
//     await pusher.subscribe(channelName: channelName);
//     await pusher.connect();
//     onTriggerEventPressed();
//   }
//   void onTriggerEventPressed() async {
//     pusher.trigger(PusherEvent(
//         channelName: channelName,
//         eventName: eventName,
//         data: "testttestt"));
//   }
//
//   void log(String msg){
//     logger.i("PrintLogMessage - $msg");
//   }
//   void onConnectionStateChange(dynamic currentState, dynamic previousState) {
//     log("Connection: $currentState");
//   }
//
//   onError(String message, int code, dynamic e) {
//     log("onError: $message code: $code exception: $e");
//   }
//
//   void onEvent(PusherEvent event) {
//     log("onEvent: $event");
//   }
//
//   dynamic onAuthorizer(String channelName, String socketId, dynamic options) {
//     return {
//       "auth": "foo:bar",
//       "channel_data": '{"user_id": 1}',
//       "shared_secret": "foobar"
//     };
//   }
//
//   void onSubscriptionSucceeded(String channelName, dynamic data) {
//     log("onSubscriptionSucceeded: $channelName data: $data");
//     final me = pusher.getChannel(channelName)?.me;
//     log("Me: $me");
//   }
//
//   void onSubscriptionError(String message, dynamic e) {
//     log("onSubscriptionError: $message Exception: $e");
//   }
//
//   void onDecryptionFailure(String event, String reason) {
//     log("onDecryptionFailure: $event reason: $reason");
//   }
//
//   void onMemberAdded(String channelName, PusherMember member) {
//     log("onMemberAdded: $channelName user: $member");
//   }
//
//   void onMemberRemoved(String channelName, PusherMember member) {
//     log("onMemberRemoved: $channelName user: $member");
//   }
//
//
//   onErrorNew(String message, int code, error) {
//   }
//
//   Future<void> unScribed() async {
//     await pusher.unsubscribe(channelName: channelName);
//   }
// }
