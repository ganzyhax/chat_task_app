part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

final class ChatLoad extends ChatEvent {}

final class ChatSend extends ChatEvent {
  String message;
  String userId;
  ChatSend({required this.message, required this.userId});
}
