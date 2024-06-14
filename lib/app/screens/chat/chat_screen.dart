import 'dart:developer';

import 'package:chat_task_app/app/app.dart';
import 'package:chat_task_app/app/screens/chat/components/chat_windows_page.dart';
import 'package:chat_task_app/app/screens/login/login_screen.dart';
import 'package:chat_task_app/app/screens/splash/splash_screen.dart';
import 'package:chat_task_app/app/services/on_close_service.dart';
import 'package:chat_task_app/const/app_color.dart';
import 'package:chat_task_app/app/screens/chat/bloc/chat_bloc.dart';
import 'package:chat_task_app/app/screens/chat/components/chat_user_card.dart';
import 'package:chat_task_app/app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final AppLifecycleObserver _appLifecycleObserver = AppLifecycleObserver();

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(_appLifecycleObserver);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_appLifecycleObserver);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    return Scaffold(
      backgroundColor: AppColors.primaryBackgroundColor,
      body: BlocListener<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatLoggedOut) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (BuildContext context) => ChatApp()),
                (Route<dynamic> route) => false);
          }
          if (state is ChatCreated) {
            log(state.data.toString());
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatWindowPage(data: state.data)),
            );
          }
        },
        child: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            if (state is ChatLoaded) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 60,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Чаты',
                            style: TextStyle(color: Colors.black, fontSize: 24),
                          ),
                          GestureDetector(
                              onTap: () {
                                BlocProvider.of<ChatBloc>(context)
                                  ..add(ChatLogOut());
                              },
                              child: Icon(Icons.logout))
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      CustomTextField(
                        hintText: 'Поиск',
                        controller: searchController,
                        onChanged: (value) {
                          BlocProvider.of<ChatBloc>(context)
                            ..add(ChatSearch(value: value));
                        },
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      ListView.separated(
                          padding: EdgeInsets.all(0),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return UserCard(
                              data: state.data[index],
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Container();
                          },
                          itemCount: state.data.length),
                    ],
                  ),
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
