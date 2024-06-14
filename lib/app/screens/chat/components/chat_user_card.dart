import 'dart:developer';

import 'package:chat_task_app/const/app_color.dart';
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final data;
  const UserCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    log(data.toString());
    return Container(
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
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Начать чат!',
                      style: TextStyle(
                          fontWeight: FontWeight.w300, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text('Вчера')],
            )
          ]),
    );
  }
}
