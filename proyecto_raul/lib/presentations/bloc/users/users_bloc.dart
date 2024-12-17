import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_raul/domain/usercase/user_usecase.dart';
import 'package:proyecto_raul/presentations/bloc/users/users_event.dart';
import 'package:proyecto_raul/presentations/bloc/users/users_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final CaseUser loginUser;
  final CaseUserInfo userInfo;
  final CreateUser createUser;

  UserBloc(this.loginUser, this.userInfo, this.createUser)
      : super(UserInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(LoginLoading());
      try {
        final user = await loginUser(event.email, event.password);
        emit(LoginSuccess(user));
      } catch (e) {
        emit(LoginFailure(e.toString()));
      }
    });

    on<UserDataRequest>((event, emit) async {
      emit(UserLoading());
      try {
        final user = await userInfo(event.email);
        emit(UserLoaded(user));
      } catch (e) {
        emit(UserError(message: e.toString()));
      }
    });
    on<UserCreateRequest>((event, emit) async {
      emit(UserLoading());
      try {
        final user = await createUser(event.email, event.password,
            event.username, event.idprovincia, event.idmunicipio, event.calle);
        emit(SignupSuccess(user));
      } catch (e) {
        emit(UserError(message: e.toString()));
      }
    });
  }
}
