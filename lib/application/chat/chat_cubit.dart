import 'package:chat_test/application/chat/chat_states.dart';
import 'package:chat_test/application/home/home_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../data/model/message.dart';

class ChatCubit extends Cubit<ChatStates> {
  ChatCubit() : super(ChatInitialState());

  static ChatCubit getCubit(BuildContext context) => BlocProvider.of(context);

  final firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> getStreamChats() {
    return firestore
        .collection("test_chats")
        .orderBy('dateTime', descending: true)
        .snapshots(includeMetadataChanges: true);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getStreamMessages({
    required String chatId,
  }) {
    return firestore
        .collection('test_chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('dateTime', descending: true)
        .snapshots(includeMetadataChanges: true);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getStreamReading({
    required String chatId,
    required String messageId,
  }) {
    return firestore
        .collection('test_chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .snapshots(includeMetadataChanges: true);
  }

  void setReading({
    required String chatId,
    required String messageId,
  }) {
    firestore
        .collection('test_chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .update({'isRead': true});
  }

  String createChatId() {
    ///create chatDoc
    final DocumentReference<Map<String, dynamic>> chatDoc =
        firestore.collection('test_chats').doc();

    ///set chatId to chatDocX fields (this instruction is required when get docs)
    chatDoc.set({
      "id": chatDoc.id,
      "dateTime": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
    });

    return chatDoc.id;
  }

  Future<void> sendMessage({
    required Message message,
    String? chatId,
  }) async {
    final doc = firestore.collection('test_chats').doc(chatId);

    ///set last message model
    doc.set({
      'id': doc.id,
      ...message.toJson(),
    });
    doc.collection("messages").add(message.toJson());
  }
}
