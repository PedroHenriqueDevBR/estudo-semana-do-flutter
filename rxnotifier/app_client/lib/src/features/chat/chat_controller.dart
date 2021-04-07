import 'package:app_client/src/features/shared/models/chat_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:common/common.dart';

class ChatController {
  Socket socket;
  ChatData chatData;
  ScrollController scrollController;
  ValueNotifier<List<SocketEvent>> listEvents = ValueNotifier<List<SocketEvent>>([]);
  TextEditingController messageController = TextEditingController(text: '');
  FocusNode inputMessageFocus = FocusNode();
  String testApiURL = 'http://192.168.2.3:3000';
  String productionApiURL = 'https://dart-socket-pedro.herokuapp.com/';

  ChatController({this.chatData}) {
    scrollController = ScrollController();
  }

  void init() {
    socket = io(
      productionApiURL,
      OptionBuilder().setTransports(['websocket']).disableAutoConnect().build(),
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
      listEvents.value.add(event);
      listEvents.notifyListeners();
    });
  }

  void send() {
    SocketEvent event = SocketEvent(
      name: chatData.name,
      room: chatData.room,
      text: messageController.text,
      type: SocketEventType.message,
    );
    socket.emit('message', event.toJson());
    addMessageToList(event);
    setValuesToDefault();
  }

  void setValuesToDefault() {
    goToEndPage();
    messageController.clear();
    inputMessageFocus.requestFocus();
  }

  void addMessageToList(SocketEvent event) {
    listEvents.value.add(event);
    listEvents.notifyListeners();
  }

  void goToEndPage() {
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
