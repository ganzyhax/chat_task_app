import 'package:chat_task_app/const/app_color.dart';
import 'package:chat_task_app/app/screens/chat/bloc/chat_bloc.dart';
import 'package:chat_task_app/app/screens/chat/components/chat_user_card.dart';
import 'package:chat_task_app/app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    return Scaffold(
      backgroundColor: AppColors.primaryBackgroundColor,
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatLoaded) {
            return Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Text('Чаты'),
                  SizedBox(
                    height: 5,
                  ),
                  CustomTextField(
                    hintText: 'Поиск',
                    controller: searchController,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ListView.separated(
                      itemBuilder: (context, index) {
                        return UserCard(data: state.data);
                      },
                      separatorBuilder: (context, index) {
                        return Container();
                      },
                      itemCount: state.data.length),
                ],
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
