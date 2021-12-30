part of 'communication.dart';

//TODO: Remove whene not used anymore

MessageRoute getDummyRoute() {
  return [
    RouteNode(deviceId: '1', isSender: true, isReceiver: false),
    RouteNode(deviceId: '2', isSender: false, isReceiver: false),
    RouteNode(deviceId: '3', isSender: false, isReceiver: true),
  ];
}
