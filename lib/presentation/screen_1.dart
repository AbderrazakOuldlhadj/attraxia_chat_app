import 'package:chat_test/application/chat/chat_cubit.dart';
import 'package:chat_test/application/home/home_cubit.dart';
import 'package:chat_test/data/model/message.dart';
import 'package:chat_test/presentation/chat_screen.dart';
import 'package:chat_test/utils/functions.dart';
import 'package:chat_test/utils/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../application/chat/chat_states.dart';

class Screen1 extends StatelessWidget {
  const Screen1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats X"),
      ),
      body: BlocBuilder<ChatCubit, ChatStates>(
        builder: (context, state) {
          final cubit = ChatCubit.getCubit(context);
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: StreamBuilder<QuerySnapshot<Map>>(
              stream: cubit.getStreamChats(),
              builder: (context, snapshot) {
                final chats = snapshot.data?.docs.toList();
                return !snapshot.hasData || chats!.isEmpty
                    ? const Center(
                        child: Text(
                          "No Chats!",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemCount: chats.length,
                        separatorBuilder: (cx, _) =>
                            const SizedBox(height: 15.0),
                        itemBuilder: (cx, index) {
                          final Message lastMessage = Message.fromJson(
                            json: chats[index].data() as Map<String, dynamic>,
                          );
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ChatScreen(
                                    senderId: "X",
                                    chatId: chats[index].data()['id'],
                                  ),
                                ),
                              );
                            },
                            child: StreamBuilder<QuerySnapshot<Map>>(
                              stream: cubit.getStreamMessages(
                                chatId: chats[index].id,
                              ),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                List<Message> noReadMessages =
                                    getNoReadMessages(
                                  docs: snapshot.data!.docs,
                                );

                                return ChatTileWidget(
                                  chatId: chats[index].data()['id'],
                                  lastMessage: lastMessage,
                                  noReadMessages: noReadMessages,
                                );
                              },
                            ),
                          );
                        },
                      );
              },
            ),
          );
        },
      ),
    );
  }
}
