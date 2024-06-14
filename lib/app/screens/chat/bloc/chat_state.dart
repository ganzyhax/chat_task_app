part of 'chat_bloc.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

final class ChatLoaded extends ChatState {
  var data;
  final selectedImage;
  ChatLoaded({
    required this.data,
    required this.selectedImage,
  });
}

final class ChatLoggedOut extends ChatState {}

final class ChatCreated extends ChatState {
  final data;
  ChatCreated({
    required this.data,
  });
}
