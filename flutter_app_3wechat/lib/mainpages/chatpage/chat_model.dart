class Chat {
  final String name;
  final String message;
  final String imageUrl;

  Chat({this.name, this.message, this.imageUrl});

  //json构造方法
  factory Chat.formJsonData(Map json) {
    return Chat(
        name: json['name'],
        message: json['message'],
        imageUrl: json['imageUrl']);
  }
}
