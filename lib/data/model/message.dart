import 'package:intl/intl.dart';

class Message {
  late String senderId, text;
  late DateTime dateTime;
   bool? isRead;

  Message({
    required this.text,
    required this.dateTime,
    required this.senderId,
    this.isRead = false,
  });

  Message.fromJson({required Map<String, dynamic> json}) {
    text = json['text'] ?? "";
    senderId = json['senderId'].toString();
    dateTime = DateTime.parse(json['dateTime'].toString());
    isRead = json['isRead'];
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'senderId': senderId,
      'dateTime': DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime),
      'isRead': isRead,
    };
  }
}
