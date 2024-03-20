// ignore_for_file: non_constant_identifier_names

import 'package:chat_test/data/model/message.dart';
import 'package:flutter/material.dart';

import 'functions.dart';

Widget ChatTileWidget({
  required String chatId,
  required Message lastMessage,
  required List<Message> noReadMessages,
  String userId = 'X',
}) {
  return Container(
    padding: const EdgeInsets.all(8),
    margin: const EdgeInsets.symmetric(vertical: 5),
    width: double.infinity,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.deepPurple.withOpacity(.5)),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(
          radius: 22,
          backgroundColor: Colors.white,
          child: Icon(
            Icons.person,
            color: Colors.deepPurple,
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  chatId,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              "${lastMessage.senderId == userId ? "you : " : ""}${lastMessage.text}",
              style: TextStyle(
                color: Colors.white,
                fontSize: noReadMessages.isEmpty ? 14 : 16,
                fontWeight:
                    noReadMessages.isEmpty ? FontWeight.w300 : FontWeight.bold,
              ),
            ),
          ],
        ),
        const Spacer(),
        Column(
          children: [
            Text(
              getDate(lastMessage.dateTime),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (noReadMessages.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  "${noReadMessages.length}",
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
          ],
        ),
      ],
    ),
  );
}
