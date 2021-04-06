import 'package:app_client/src/features/chat/chat_controller.dart';
import 'package:flutter/material.dart';

import 'package:app_client/src/features/shared/models/chat_model.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:common/common.dart';

class ChatPage extends StatefulWidget {
  final ChatData chatData;

  const ChatPage({
    Key? key,
    required this.chatData,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late ChatController _controller;

  void goToHomePage() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _controller = ChatController(chatData: widget.chatData);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('${_controller.chatData.room}'),
        elevation: 0.0,
        actions: [
          IconButton(
              icon: Icon(
                Icons.close,
                color: Theme.of(context).accentColor,
              ),
              onPressed: goToHomePage),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: RxBuilder(
                builder: (context) {
                  return ListView.builder(
                    controller: _controller.scrollController,
                    physics: BouncingScrollPhysics(),
                    itemCount: _controller.listEvents.length,
                    itemBuilder: (_, index) {
                      final event = _controller.listEvents[index];

                      if (event.type == SocketEventType.enter_room) {
                        return userInTheRoomActioWidget(event: event);
                      } else if (event.type == SocketEventType.leave_room) {
                        return userInTheRoomActioWidget(event: event);
                      } else {
                        if (event.name == _controller.chatData.name) {
                          return messageSentWidget(event);
                        } else {
                          return messageReceivedWidget(event);
                        }
                      }
                    },
                  );
                },
              ),
            ),
            inputMessage(),
          ],
        ),
      ),
    );
  }

  Widget userInTheRoomActioWidget({required SocketEvent event}) {
    return Column(
      children: [
        ListTile(
          subtitle: Text(
            event.type == SocketEventType.enter_room ? '${event.name} entrou na sala.' : '${event.name} saiu da sala.',
            style: TextStyle(
              color: event.type == SocketEventType.enter_room ? Colors.lightGreen : Colors.red.shade400,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Divider(),
      ],
    );
  }

  Widget messageWidget({
    required SocketEvent event,
    required Color backgrouColor,
    required Color borderColor,
    double marginLeft = null ?? 4.0,
    double marginRight = null ?? 4.0,
    bool disableRadiusTopLeft = null ?? false,
    bool disableRadiusTopRight = null ?? false,
  }) {
    return Container(
      margin: EdgeInsets.only(
        left: marginLeft,
        right: marginRight,
        top: 4.0,
        bottom: 4.0,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: borderColor,
        ),
        borderRadius: BorderRadius.only(
          topLeft: disableRadiusTopLeft ? Radius.zero : Radius.circular(24.0),
          topRight: disableRadiusTopRight ? Radius.zero : Radius.circular(24.0),
          bottomLeft: Radius.circular(24.0),
          bottomRight: Radius.circular(24.0),
        ),
        color: backgrouColor,
      ),
      child: ListTile(
        dense: true,
        title: Text(event.text),
        subtitle: Text('${event.name}'),
      ),
    );
  }

  Widget messageSentWidget(SocketEvent event) {
    return messageWidget(
      event: event,
      backgrouColor: Colors.blueGrey.shade900,
      borderColor: Colors.blueGrey.shade800,
      disableRadiusTopLeft: true,
      marginRight: 24.0,
    );
  }

  messageReceivedWidget(SocketEvent event) {
    return messageWidget(
      event: event,
      backgrouColor: Theme.of(context).accentColor,
      borderColor: Theme.of(context).accentColor,
      disableRadiusTopRight: true,
      marginLeft: 24.0,
    );
  }

  Widget inputMessage() {
    return Container(
      padding: EdgeInsets.all(6.0),
      color: Theme.of(context).primaryColor,
      child: Form(
        child: Column(
          children: [
            TextFormField(
              focusNode: _controller.inputMessageFocus,
              controller: _controller.messageController,
              keyboardType: TextInputType.multiline,
              onEditingComplete: () => _controller.send,
              decoration: InputDecoration(
                hintText: 'Mensagem',
                border: InputBorder.none,
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  color: Theme.of(context).accentColor,
                  onPressed: _controller.send,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
