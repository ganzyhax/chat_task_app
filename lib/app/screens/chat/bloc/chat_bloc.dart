import 'dart:math';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:chat_task_app/app/api/api.dart';
import 'package:chat_task_app/app/functions/funcations.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    var globalUsersData;
    var searchedData;
    String selectedImage = '';
    on<ChatEvent>((event, emit) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = await prefs.getString('userId') ?? '';

      if (event is ChatLoad) {
        selectedImage = '';
        await ApiClient()
            .updateDocumentField('users', userId, {'isOnline': true});
        globalUsersData = await ApiClient().getCollection('users');
        List generatedColors = generateRandomColors(globalUsersData.length);
        for (var i in globalUsersData) {
          int index = globalUsersData.indexOf(i);
          var chatDatas = await ApiClient().findChat(i['id'], userId);
          if (chatDatas.length == 0) {
            i['chatData'] = null;
          } else {
            i['chatData'] = chatDatas[0];
          }
          i['color'] = generatedColors[index];
        }

        emit(ChatLoaded(
          selectedImage: selectedImage,
          data: globalUsersData,
        ));
      }
      if (event is ChatSend) {
        var chatData = await ApiClient().getById('chats', event.chatId);

        chatData!['chats'].add({
          'senderId': userId,
          'message': (selectedImage != '')
              ? selectedImage + '^' + event.message
              : event.message,
          'timestamp': DateTime.now(),
          'isReaded': false,
        });

        await ApiClient().update('chats', event.chatId, chatData);
        emit(ChatLoaded(
          data: globalUsersData,
          selectedImage: selectedImage,
        ));
      }
      if (event is ChatCreate) {
        var res = await ApiClient().create(
          'chats',
          {'clientId': event.clientId, 'userId': userId, 'chats': []},
        );
        event.data['chatData'] = res;

        emit(ChatCreated(data: event.data));

        emit(ChatLoaded(
          selectedImage: selectedImage,
          data: globalUsersData,
        ));
      }
      if (event is ChatUploadImage) {
        selectedImage =
            await GlobalFunctions().uploadImageToImgBB(event.context);
        emit(ChatLoaded(
          selectedImage: selectedImage,
          data: globalUsersData,
        ));
      }
      if (event is ChatRemoveImage) {
        selectedImage = '';
        emit(ChatLoaded(
          selectedImage: selectedImage,
          data: globalUsersData,
        ));
      }
      if (event is ChatLogOut) {
        await prefs.clear();
        emit(ChatLoggedOut());
        emit(ChatLoaded(
          selectedImage: selectedImage,
          data: globalUsersData,
        ));
      }
      if (event is ChatMakeReaded) {
        var chatData = await ApiClient().getById('chats', event.chatId);
        if (!chatData!['chats'].isEmpty) {
          if (chatData!['chats'][chatData!['chats'].length - 1]['senderId'] !=
              userId) {
            chatData!['chats'][chatData!['chats'].length - 1]['isReaded'] =
                true;
            await ApiClient().update('chats', event.chatId, chatData);
          }
        }
      }
      if (event is ChatSearch) {
        if (event.value == '') {
          emit(ChatLoaded(
            selectedImage: selectedImage,
            data: globalUsersData,
          ));
        } else {
          searchedData = globalUsersData
              .where((data) => (data['fullname'] as String)
                  .toLowerCase()
                  .startsWith(event.value.toLowerCase()))
              .toList();
          emit(ChatLoaded(
            selectedImage: selectedImage,
            data: searchedData,
          ));
        }
      }
    });
  }
  List<Color> generateRandomColors(int count) {
    Random random = Random();
    List<Color> colors = [];

    for (int i = 0; i < count; i++) {
      int r = random.nextInt(256);
      int g = random.nextInt(256);
      int b = random.nextInt(256);

      Color color = Color.fromARGB(255, r, g, b);

      colors.add(color);
    }

    return colors;
  }
}
