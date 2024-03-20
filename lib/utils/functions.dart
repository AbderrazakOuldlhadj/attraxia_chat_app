import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../data/model/message.dart';

String getDate(DateTime dateTime) {
  // Parse the input string to DateTime
  DateTime inputDate = dateTime;

  // Get the current date and time
  DateTime currentDate = DateTime.now();

  // Calculate the difference in days
  int differenceInDays = currentDate.difference(inputDate).inDays;

  if (differenceInDays < 1) {
    // If the difference is less than 24 hours, return the hour and minute
    return DateFormat('HH:mm').format(inputDate);
  } else if (differenceInDays < 2) {
    return "yesterday";
  } else if (differenceInDays < 7) {
    // If the difference is less than a week, return the abbreviated day name
    return DateFormat('E').format(inputDate);
  } else {
    // Otherwise, return the date in the specified format (e.g., 'Nov 30')
    return DateFormat('MMM d').format(inputDate);
  }
}

List<Message> getNoReadMessages({
  required List<QueryDocumentSnapshot<Map>> docs,
  bool isX = true,
}) {
  String senderId = isX ? 'X' : 'Y';
  return docs
      .where((element) =>
          element.data()['isRead'] == false &&
          element.data()['senderId'] != senderId)
      .map(
        (e) => Message.fromJson(
          json: e.data() as Map<String, dynamic>,
        ),
      )
      .toList();
}
