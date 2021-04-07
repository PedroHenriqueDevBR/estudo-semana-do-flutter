import 'dart:io';

import 'package:socket_io/socket_io.dart';
import 'package:common/common.dart';

void main() {
  final Server server = Server();

  server.on('connection', (socket) {
    socket.on('enter_room', (data) {
      final name = data['name'];
      final room = data['room'];

      print(data);

      socket.join(room);

      socket.to(room).broadcast.emit(
          'message',
          SocketEvent(
            name: name,
            room: room,
            text: '',
            type: SocketEventType.enter_room,
          ).toJson());

      socket.on('disconnect', (json) {
        socket.to(room).broadcast.emit(
            'message',
            SocketEvent(
              name: name,
              room: room,
              text: '',
              type: SocketEventType.leave_room,
            ).toJson());
      });

      socket.on('message', (json) {
        final data = SocketEvent.fromJson(json);
        final room = data.room;
        socket.to(room).broadcast.emit('message', data);
      });
    });
  });

  server.listen(Platform.environment['PORT'] ?? 3000);
}
