class Message {
  int? id;
  String title;
  String message;
  String? imagePath;

  Message({
    this.id,
    required this.title,
    required this.message,
    this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'image_path': imagePath,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      title: map['title'],
      message: map['message'],
      imagePath: map['image_path'],
    );
  }
}
