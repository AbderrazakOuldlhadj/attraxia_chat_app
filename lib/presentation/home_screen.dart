import 'package:chat_test/application/chat/chat_cubit.dart';
import 'package:chat_test/application/home/home_cubit.dart';
import 'package:chat_test/application/home/home_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'chat_screen.dart';
import 'screen_1.dart';
import 'screen_2.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        final cubit = HomeCubit.getCubit(context);
        return Scaffold(
          body: Visibility(
            visible: cubit.currentPageIndex == 0,
            replacement: const Screen2(),
            child: const Screen1(),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ChatScreen(
                    senderId: cubit.currentPageIndex == 0 ? "X" : "Y",
                    chatId: ChatCubit.getCubit(context).createChatId(),
                  ),
                ),
              );
            },
            label: const Text(
              "New Chat",
              style: TextStyle(fontSize: 18),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(
              bottom: 16.0,
              left: 16,
              right: 16,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: BottomNavigationBar(
                currentIndex: cubit.currentPageIndex,
                onTap: (index) => cubit.setPageIndex(index),
                items: [
                  BottomNavigationBarItem(
                    icon: Container(),
                    label: "User_X",
                  ),
                  BottomNavigationBarItem(
                    icon: Container(),
                    label: "User_Y",
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
