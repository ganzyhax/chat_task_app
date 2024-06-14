import 'dart:math';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:chat_task_app/app/api/api.dart';
import 'package:meta/meta.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    var globalUsersData;
    var userChats;
    on<ChatEvent>((event, emit) async {
      if (event is ChatLoad) {
        globalUsersData = await ApiClient().getCollection('users');
        List generatedColors = generateRandomColors(globalUsersData.length);
        for (var i in globalUsersData) {
          int index = globalUsersData.indexOf(i);
          i['color'] = generatedColors[index];
        }

        emit(ChatLoaded(data: globalUsersData));
      }
      if (event is ChatSend) {
        emit(ChatLoaded(data: globalUsersData));
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
