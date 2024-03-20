import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../application/chat/chat_cubit.dart';
import '../application/chat/chat_states.dart';
import '../data/model/message.dart';
import '../utils/functions.dart';
import '../utils/widgets.dart';
import 'chat_screen.dart';

class Screen2 extends StatelessWidget {
  const Screen2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats Y"),
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
                                    senderId: "Y",
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
                                  isX: false,
                                );

                                return ChatTileWidget(
                                  chatId: chats[index].data()['id'],
                                  lastMessage: lastMessage,
                                  noReadMessages: noReadMessages,
                                  userId: 'Y',
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
