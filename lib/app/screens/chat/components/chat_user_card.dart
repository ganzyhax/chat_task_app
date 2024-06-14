import 'package:chat_task_app/const/app_color.dart';
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final data;
  const UserCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(width: 1, color: AppColors.secondaryColor))),
      child: Row(children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: data['color'],
          child: Center(
            child: Text(
              data['fullname'].split(' ')[0].toString().toUpperCase() +
                  data['fullname'].split(' ')[1].toString().toUpperCase(),
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        Column(
          children: [
            Text(
              data['fullname'],
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        )
      ]),
    );
  }
}
