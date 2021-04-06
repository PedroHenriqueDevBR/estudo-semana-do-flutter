class ChatData {
  String name;
  String room;

  ChatData({
    required this.name,
    required this.room,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'room': room,
    };
  }
}
