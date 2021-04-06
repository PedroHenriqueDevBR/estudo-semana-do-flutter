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
        title: Text('${_controller.chatData.room}'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: RxBuilder(
                builder: (context) => ListView.builder(
                  itemCount: _controller.listEvents.length,
                  itemBuilder: (_, index) {
                    final event = _controller.listEvents[index];

                    if (event.name == SocketEventType.enter_room) {
                      return ListTile(
                        title: Text(event.text),
                        subtitle: Text('${event.name} entrou na sala.'),
                      );
                    } else if (event.name == SocketEventType.leave_room) {
                      return ListTile(
                        title: Text(event.text),
                        subtitle: Text('${event.name} saiu da sala.'),
                      );
                    } else {
                      return ListTile(
                        title: Text(event.text),
                        subtitle: Text('${event.name}'),
                      );
                    }
                  },
                ),
              ),
            ),
            Container(
              child: Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _controller.messageController,
                      decoration: InputDecoration(
                        hintText: 'Mensagem',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.zero),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.send),
                          onPressed: _controller.send,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
