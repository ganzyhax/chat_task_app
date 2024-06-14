import 'package:bloc/bloc.dart';
import 'package:chat_task_app/app/api/api.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    bool isLoading = false;
    on<LoginEvent>((event, emit) async {
      if (event is LoginLoad) {
        emit(LoginLoaded(isLoading: isLoading));
      }
      if (event is LoginLogin) {
        isLoading = true;
        emit(LoginLoaded(isLoading: isLoading));

        var res = await ApiClient().login(event.username, event.password);
        if (res != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('userId', res);
          emit(LoginSuccess(message: 'Logged in!'));
        } else {
          emit(LoginError(message: 'Неверный логин или пароль!'));
        }
        isLoading = false;
        emit(LoginLoaded(isLoading: isLoading));
      }
    });
  }
}
