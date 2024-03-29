part of '../protocol.dart';

class Communications {
  const Communications(this.ncpService);

  final NcpService ncpService;

  /// Sends all neighbors [devices] to receiver [receiverId]
  ///
  /// Needs [receiverId] and [ownId] for proper sending
  /// [devices] and [route] are required for proper routing
  void sendNeighborsToId({
    required String receiverId,
    required String ownId,
    required List<DiscoveredDevice> devices,
    required MessageRoute route,
    String? messageId,
  }) {
    final List<Map> data = devices.map((device) => device.toMap()).toList();
    final Message message = Message(
      id: messageId ?? const Uuid().v4(),
      senderId: ownId,
      receiverId: receiverId,
      route: route,
      payload: data,
      messageType: MessageType.neighborsResponse,
    );
    handleMessage(message, ownId);
  }

  /// Request neighbors from [receiverId]
  ///
  /// Needs [ownId] and [route] for proper sending
  /// [route] shall be generated by [ConnectedDevicesGraph]
  void requestNeighbors({
    required String receiverId,
    required String ownId,
    required MessageRoute route,
    String? messageId,
  }) {
    final Message message = Message(
      id: messageId ?? const Uuid().v4(),
      senderId: ownId,
      receiverId: receiverId,
      route: route,
      payload: null,
      messageType: MessageType.neighborsRequest,
    );
    handleMessage(message, ownId);
  }

  /// Sends the given [text] to [receiverId]
  ///
  /// Needs [ownId] and [route] for proper sending
  /// [route] shall be generated by [ConnectedDevicesGraph]
  void sendTextToId({
    required String receiverId,
    required String ownId,
    required String text,
    required MessageRoute route,
    String? messageId,
  }) {
    final Message message = Message(
      id: messageId ?? const Uuid().v4(),
      senderId: ownId,
      receiverId: receiverId,
      route: route,
      payload: text,
      messageType: MessageType.text,
    );
    handleMessage(message, ownId);
  }

  ///Handles a message
  ///
  ///Needs [ownId] to put message in context to device
  ///Returns the Message if device is last node in message route
  ///Function does not check if route is valid or operational because routing is always defined by the sender
  Message? handleMessage(Message message, String ownId) {
    if (message.receiverId == ownId) {
      return message;
    }
    final MessageRoute messageRoute = message.route;
    final List<String> routeDeviceIdList =
        messageRoute.map<String>((node) => node.deviceId).toList();
    final ownIndex = routeDeviceIdList.indexOf(ownId);
    sendMessageToId(message, routeDeviceIdList[ownIndex + 1]);
    return null;
  }

  ///Sends [message] to [id]
  ///
  ///Uses [ncpService] defined in constructor to send message
  ///[message] and [id] are required
  Future<void> sendMessageToId(Message message, String id) async {
    await ncpService.sendMessageToId(message, id);
  }

  /// Input method for received messages
  ///
  /// Needs [message] and [graph] to handle message
  String? messageInput({
    required Message message,
    required ConnectedDevicesGraph graph,
    required Me me,
  }) {
    final messageForMe = handleMessage(message, me.ownId);
    if (messageForMe != null) {
      final senderId = messageForMe.senderId;
      if (messageForMe.messageType == MessageType.neighborsRequest) {
        messageForMe.interpret();
        sendNeighborsToId(
          receiverId: senderId,
          ownId: me.ownId,
          devices: graph.connectedDevices(),
          route: messageForMe.route.reversed.toList(),
        );
      } else if (messageForMe.messageType == MessageType.neighborsResponse) {
        final response = messageForMe.interpret() as List<DiscoveredDevice>;
        graph.addDeviceWithAncestors(
          DiscoveredDevice(id: senderId),
          response,
        );
      } else if (messageForMe.messageType == MessageType.text) {
        return messageForMe.interpret() as String;
      }
    }
    return null;
  }
}
