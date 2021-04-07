class ChatData {
  String name;
  String room;

  ChatData({
    this.name,
    this.room,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'room': room,
    };
  }
}
