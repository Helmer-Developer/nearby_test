part of 'protocol.dart';

///Class to abscarct all infomation about a node in a message route
///
///[isSender] and [isReceiver] can't be true at the same time.
class RouteNode {
  RouteNode({
    required this.deviceId,
    required this.isSender,
    required this.isReceiver,
  }) : assert(
          (isSender && isReceiver) == false,
          'isSender and isReciver can not be true at the same time',
        );

  ///Id to identify the device
  String deviceId;

  ///Boolean value wether [RouteNode] is sender or not
  bool isSender;

  ///Boolean value wether [RouteNode] is receiver or not
  bool isReceiver;
}
