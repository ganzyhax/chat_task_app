part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

final class ChatLoad extends ChatEvent {}

final class ChatSend extends ChatEvent {
  String message;

  String chatId;
  ChatSend({required this.message, required this.chatId});
}

final class ChatCreate extends ChatEvent {
  String clientId;
  final data;
  ChatCreate({required this.clientId, required this.data});
}

final class ChatUploadImage extends ChatEvent {
  BuildContext context;
  ChatUploadImage({required this.context});
}

final class ChatRemoveImage extends ChatEvent {}

final class ChatLogOut extends ChatEvent {}

final class ChatMakeReaded extends ChatEvent {
  String chatId;
  ChatMakeReaded({required this.chatId});
}

final class ChatSearch extends ChatEvent {
  String value;
  ChatSearch({required this.value});
}
