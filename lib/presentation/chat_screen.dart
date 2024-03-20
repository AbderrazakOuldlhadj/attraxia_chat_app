import 'dart:convert';

import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:chat_test/application/chat/chat_cubit.dart';
import 'package:chat_test/application/chat/chat_states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;

import '../data/model/message.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({
    required this.senderId,
    this.chatId,
  }) : super();

  String senderId;
  String? chatId;

  TextEditingController messageController = TextEditingController();

  TextDirection? textDirection;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        FocusScope.of(context).unfocus();
        return true;
      },
      child: BlocConsumer<ChatCubit, ChatStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = ChatCubit.getCubit(context);
          return Scaffold(
            appBar: AppBar(
              title: const Row(
                children: [
                  CircleAvatar(
                    radius: 20.0,
                    backgroundImage: NetworkImage(
                        "https://images.unsplash.com/photo-1633332755192-727a05c4013d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlcnxlbnwwfHwwfHx8MA%3D%3D&w=1000&q=80"),
                  ),
                  SizedBox(width: 15),
                  Text("User_Y"),
                ],
              ),
            ),
            body: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
              child: Column(
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: cubit.getStreamMessages(chatId: chatId!),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: Text(
                            "Start a chat with ${senderId != "X" ? "user_X" : "user_Y"}",
                          ),
                        );
                      }
                      List<QueryDocumentSnapshot<Object?>> messages =
                          snapshot.data!.docs.toList();
                      return Expanded(
                        child: messages.isEmpty
                            ? Center(
                                child: Text(
                                  "Start a chat with ${senderId != "X" ? "user_X" : "user_Y"}",
                                ),
                              )
                            : ListView.separated(
                                reverse: true,
                                itemCount: messages.length,
                                separatorBuilder: (cx, _) =>
                                    const SizedBox(height: 15.0),
                                itemBuilder: (cx, index) {
                                  Message message = Message.fromJson(
                                    json: messages[index].data()
                                        as Map<String, dynamic>,
                                  );

                                  if (message.senderId != senderId) {
                                    /// set isRead to true if the widget has built

                                    cubit.setReading(
                                      chatId: chatId!,
                                      messageId: messages[index].id,
                                    );
                                    return messageReceiver(message.text);
                                  }

                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      myMessage(message.text),
                                      StreamBuilder(
                                        stream: cubit.getStreamReading(
                                          chatId: chatId!,
                                          messageId: messages[index].id,
                                        ),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData &&
                                              snapshot.data!
                                                  .data()?['isRead'] &&
                                              index == 0) {
                                            return const Text("seen");
                                          } else {
                                            return Container();
                                          }
                                        },
                                      )
                                    ],
                                  );
                                },
                              ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  StatefulBuilder(
                    builder: (context, set) {
                      return Card(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            //border: Border.all(),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextFormField(
                            controller: messageController,
                            textDirection: textDirection,

                            onChanged: (value) {
                              final oldTextDirection = textDirection;
                              if (value.isEmpty) {
                                textDirection = TextDirection.ltr;
                                if (oldTextDirection != TextDirection.ltr) {
                                  set(() {});
                                }
                                return;
                              }
                              textDirection = detectTextDirection(value[0]);
                              if (oldTextDirection != textDirection) {
                                set(() {});
                              }
                            },
                            decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 8,
                              ),
                              border: InputBorder.none,
                              hintText: "Message",
                              suffixIcon: MaterialButton(
                                minWidth: 1.0,
                                child: const Icon(
                                  Icons.send,
                                  size: 35,
                                ),
                                onPressed: () async {
                                  messageController.text =
                                      removeLeadingWhitespace(
                                    messageController.text,
                                  );
                                  if (messageController.text.isNotEmpty) {
                                    final message = Message(
                                      text: messageController.text,
                                      senderId: senderId,
                                      dateTime: DateTime.now(),
                                      isRead: false,
                                    );
                                    messageController.clear();

                                    cubit.sendMessage(
                                      message: message,
                                      chatId: chatId,
                                    );
                                  }

                                  //messageController.clear();
                                },
                              ),
                            ),

                            // style:,
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String removeLeadingWhitespace(String inputText) {
    // Use RegExp to match and replace leading white spaces
    return inputText.replaceAll(RegExp(r'^\s+'), '');
  }

  TextDirection detectTextDirection(String text) {
    intl.Bidi.hasAnyRtl(text);

    return intl.Bidi.detectRtlDirectionality(text)
        ? TextDirection.rtl
        : TextDirection.ltr;
  }

  Widget myMessage(String message) => BubbleSpecialThree(
        text: message,
        textStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
          fontSize: 18,
        ),
        color: Colors.black,
      );

  Widget messageReceiver(String message) => BubbleSpecialThree(
        text: message,
        textStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
          fontSize: 18,
        ),
        color: Colors.blueGrey,
        isSender: false,
      );
}
