import 'dart:developer';

import 'package:chat_task_app/app/screens/chat/bloc/chat_bloc.dart';
import 'package:chat_task_app/app/screens/chat/chat_screen.dart';
import 'package:chat_task_app/app/widgets/custom_chatbubble.dart';
import 'package:chat_task_app/const/app_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ChatWindowPage extends StatelessWidget {
  final data;
  const ChatWindowPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    log(data.toString());
    var time;
    TextEditingController msgController = TextEditingController();
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is ChatLoaded) {
          try {
            BlocProvider.of<ChatBloc>(context)
              ..add(ChatMakeReaded(chatId: data['chatData'].data()['id']));
          } catch (e) {}
          try {
            if (data['chatData']['chats'] != null &&
                data['chatData']['chats'].isNotEmpty) {
              var lastChat = data['chatData']['chats']
                  [data['chatData']['chats'].length - 1];
              var timestamp = lastChat['timestamp'] as Timestamp;
              var dateTime = timestamp.toDate();

              time = DateFormat.Hm().format(dateTime);
            }
          } catch (e) {
            time = '';
          }
          return Scaffold(
              backgroundColor: AppColors.primaryBackgroundColor,
              appBar: AppBar(
                backgroundColor: AppColors.secondaryBackgroundColor,
                leading: GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => ChatScreen()),
                        (Route<dynamic> route) => false);
                  },
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.black,
                  ),
                ),
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: data['color'],
                      child: Center(
                        child: Text(
                          data['fullname']
                                  .split(' ')[0][0]
                                  .toString()
                                  .toUpperCase() +
                              data['fullname']
                                  .split(' ')[1][0]
                                  .toString()
                                  .toUpperCase(),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['fullname'],
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Colors.black),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('users')
                              .doc(data['id'])
                              .get(),
                          builder:
                              (ctx, AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            }
                            if (!snapshot.hasData ||
                                snapshot.data!.exists == false) {
                              return Center(child: Text(''));
                            }

                            // Document data
                            var data =
                                snapshot.data!.data() as Map<String, dynamic>;
                            return Text(
                              data['isOnline'] ? 'В сети' : 'Не в сети',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.grey[600]),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: (state.selectedImage != '')
                          ? MediaQuery.of(context).size.height / 1.35
                          : MediaQuery.of(context).size.height / 1.315,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: FutureBuilder<DocumentSnapshot>(
                              future: (data['chatData'].toString() ==
                                      "Instance of '_JsonQueryDocumentSnapshot'")
                                  ? FirebaseFirestore.instance
                                      .collection('chats')
                                      .doc(data['chatData'].data()['id'])
                                      .get()
                                  : FirebaseFirestore.instance
                                      .collection('chats')
                                      .doc(data['chatData']['id'])
                                      .get(),
                              builder: (ctx,
                                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                }
                                if (!snapshot.hasData ||
                                    snapshot.data!.exists == false) {
                                  return Center(child: Text('Загрузка...'));
                                }

                                var messageData = snapshot.data!.data()
                                    as Map<String, dynamic>;
                                List<dynamic> messages = messageData['chats'];
                                List<Map<String, dynamic>> reversedMessages =
                                    messages.reversed
                                        .map((item) =>
                                            item as Map<String, dynamic>)
                                        .toList();
                                return ListView.builder(
                                  reverse: true,
                                  itemCount: reversedMessages.length,
                                  itemBuilder: (context, index) {
                                    return ChatBubble(
                                      message: reversedMessages[index]
                                          ['message'],
                                      timestamp: time.toString(),
                                      isReaded: reversedMessages[index]
                                          ['isReaded'],
                                      isMe: reversedMessages[index]
                                                  ['senderId'] !=
                                              data['id']
                                          ? true
                                          : false,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.secondaryBackgroundColor,
                          border: Border(
                            top: BorderSide(
                                width: 0.4,
                                color: Color.fromARGB(255, 219, 234, 255)),
                          ),
                        ),
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            (state.selectedImage != '')
                                ? Column(
                                    children: [
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.image),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text('Изоброжение загружено.'),
                                              ],
                                            ),
                                            GestureDetector(
                                                onTap: () {
                                                  BlocProvider.of<ChatBloc>(
                                                      context)
                                                    ..add(ChatRemoveImage());
                                                },
                                                child: Icon(Icons.close))
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                    ],
                                  )
                                : SizedBox(),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    BlocProvider.of<ChatBloc>(context)
                                      ..add(ChatUploadImage(context: context));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Color.fromARGB(255, 233, 238, 245),
                                    ),
                                    padding: EdgeInsets.all(0),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.add_photo_alternate_sharp,
                                        color: Colors.black87,
                                      ),
                                      onPressed: () {
                                        BlocProvider.of<ChatBloc>(context)
                                          ..add(ChatUploadImage(
                                              context: context));
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(15.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Color.fromARGB(255, 233, 238, 245),
                                    ),
                                    child: TextField(
                                      controller: msgController,
                                      decoration: InputDecoration.collapsed(
                                        hintText: 'Сообщение',
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Color.fromARGB(255, 233, 238, 245),
                                  ),
                                  padding: EdgeInsets.all(0),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.send,
                                      color: Colors.black87,
                                    ),
                                    onPressed: () {
                                      BlocProvider.of<ChatBloc>(context)
                                          .add(ChatSend(
                                        chatId: (data['chatData'].toString() ==
                                                "Instance of '_JsonQueryDocumentSnapshot'")
                                            ? data['chatData'].data()['id']
                                            : data['chatData']['id'],
                                        message: msgController.text,
                                      ));
                                      msgController.text = '';
                                      BlocProvider.of<ChatBloc>(context)
                                          .add(ChatLoad());
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ));
        }
        return Scaffold(
          backgroundColor: AppColors.primaryBackgroundColor,
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
