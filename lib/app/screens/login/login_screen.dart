import 'package:chat_task_app/app/screens/login/bloc/login_bloc.dart';
import 'package:chat_task_app/app/widgets/custom_button.dart';
import 'package:chat_task_app/app/widgets/custom_snackbar.dart';
import 'package:chat_task_app/const/app_color.dart';
import 'package:chat_task_app/app/screens/chat/bloc/chat_bloc.dart';
import 'package:chat_task_app/app/screens/chat/components/chat_user_card.dart';
import 'package:chat_task_app/app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController loginController = TextEditingController();
    TextEditingController passController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.primaryBackgroundColor,
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {}
          if (state is LoginError) {
            CustomSnackbar().showCustomSnackbar(context, state.message, false);
          }
        },
        child: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            if (state is ChatLoaded) {
              return Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 5,
                    ),
                    Text(
                      'Логин',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    CustomTextField(
                      hintText: 'Логин',
                      controller: loginController,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CustomTextField(
                      hintText: 'Пароль',
                      isPassword: true,
                      passwordShow: true,
                      controller: passController,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CustomButton(
                        text: 'Войти',
                        onTap: () {
                          BlocProvider.of<LoginBloc>(context)
                            ..add(LoginLogin(
                                password: passController.text,
                                username: loginController.text));
                        })
                  ],
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
