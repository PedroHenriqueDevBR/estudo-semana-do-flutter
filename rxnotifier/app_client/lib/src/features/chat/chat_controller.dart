import 'package:app_client/src/features/shared/models/chat_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:common/common.dart';

class ChatController {
  late Socket socket;
  late ChatData chatData;
  late ScrollController scrollController;
  RxList<SocketEvent> listEvents = RxList<SocketEvent>([]);
  TextEditingController messageController = TextEditingController(text: '');
  FocusNode inputMessageFocus = FocusNode();

  ChatController({required this.chatData}) {
    _init();
    scrollController = ScrollController();
  }

  void _initFakeData() {
    SocketEvent event = SocketEvent(
      name: 'Pedro',
      room: 'teste',
      text: 'Olá mundo, mensagem de Pedro!',
      type: SocketEventType.message,
    );
    SocketEvent event2 = SocketEvent(
      name: 'Henrique',
      room: 'teste',
      text: 'Olá mundo, mensagem de Henrique!',
      type: SocketEventType.message,
    );
    SocketEvent enterRoomEvent = SocketEvent(
      name: 'Henrique',
      room: 'teste',
      text: '',
      type: SocketEventType.enter_room,
    );
    SocketEvent leaveRoomEvent = SocketEvent(
      name: 'Henrique',
      room: 'teste',
      text: '',
      type: SocketEventType.leave_room,
    );
    listEvents.add(enterRoomEvent);
    listEvents.add(event);
    listEvents.add(event2);
    listEvents.add(leaveRoomEvent);
    listEvents.add(event);
  }

  void _init() {
    socket = io(
      'https://dart-socket-pedro.herokuapp.com/',
      OptionBuilder().setTransports(['websocket']).build(),
    );
    socket.connect();

    socket.onConnect((_) {
      socket.emit('enter_room', {
        'name': chatData.name,
        'room': chatData.room,
      });
    });

    socket.on('message', (data) {
      SocketEvent event = SocketEvent.fromJson(data);
      listEvents.add(event);
    });
  }

  void send() {
    SocketEvent event = SocketEvent(
      name: chatData.name,
      room: chatData.room,
      text: messageController.text,
      type: SocketEventType.message,
    );
    listEvents.add(event);
    socket.emit('message', event.toJson());
    messageController.clear();
    inputMessageFocus.requestFocus();
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: Duration(seconds: 2),
      curve: Curves.linearToEaseOut,
    );
  }

  void dispose() {
    socket.clearListeners();
    socket.dispose();
    messageController.dispose();
  }
}
