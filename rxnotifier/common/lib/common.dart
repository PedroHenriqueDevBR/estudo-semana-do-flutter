import 'dart:convert';

const API_URL = 'http://dart-socket-pedro.herokuapp.com/';

class SocketEvent {
  final String name;
  final String room;
  final String text;
  final SocketEventType type;

  SocketEvent({
    required this.name,
    required this.room,
    required this.text,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'room': room,
      'text': text,
      'type': type.toString(),
    };
  }

  factory SocketEvent.fromMap(Map<String, dynamic> map) {
    return SocketEvent(
      name: map['name'],
      room: map['room'],
      text: map['text'],
      type: SocketEventType.values.firstWhere((element) => element.toString() == map['type']),
    );
  }

  String toJson() => json.encode(toMap());

  factory SocketEvent.fromJson(String source) => SocketEvent.fromMap(json.decode(source));
}

enum SocketEventType { enter_room, leave_room, message }
