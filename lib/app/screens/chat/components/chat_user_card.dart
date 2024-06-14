import 'dart:developer';

import 'package:chat_task_app/app/screens/chat/bloc/chat_bloc.dart';
import 'package:chat_task_app/app/screens/chat/components/chat_windows_page.dart';
import 'package:chat_task_app/const/app_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class UserCard extends StatelessWidget {
  final data;
  const UserCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    var time;
    try {
      if (data['chatData']['chats'] != null &&
          data['chatData']['chats'].isNotEmpty) {
        var lastChat =
            data['chatData']['chats'][data['chatData']['chats'].length - 1];
        var timestamp = lastChat['timestamp'] as Timestamp;
        var dateTime = timestamp.toDate();

        time = DateFormat.Hm().format(dateTime);
      }
    } catch (e) {
      time = '';
    }

    return GestureDetector(
      onTap: () {
        if (data['chatData'] == null) {
          BlocProvider.of<ChatBloc>(context)
            ..add(ChatCreate(clientId: data['id'], data: data));
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatWindowPage(data: data)),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.only(bottom: 10, top: 10),
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    width: 1, color: Color.fromARGB(255, 198, 198, 198)))),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 35,
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
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.8,
                        child: Text(
                          (data['chatData'] == null)
                              ? 'Начать чат!'
                              : (data['chatData']['chats'].length == 0
                                  ? 'Начать чат!'
                                  : data['chatData']['chats']
                                          [data['chatData']['chats'].length - 1]
                                      ['message']),
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (data['chatData'] == null)
                        ? ''
                        : (data['chatData']['chats'].length == 0 ? '' : time),
                  )
                ],
              )
            ]),
      ),
    );
  }
}
