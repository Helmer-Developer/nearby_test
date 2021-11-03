part of 'protocol.dart';

class RouteNode {
  RouteNode({
    required this.deviceId,
    required this.isSender,
    required this.isReceiver,
  }) : assert(
          (isSender && isReceiver) == false,
          'isSender and isReciver can not be true at the same time',
        );

  String deviceId;
  bool isSender;
  bool isReceiver;
}
