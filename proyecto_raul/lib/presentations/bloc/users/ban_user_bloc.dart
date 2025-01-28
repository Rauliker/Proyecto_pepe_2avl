import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_raul/domain/usercase/user_usecase.dart';
import 'package:proyecto_raul/presentations/bloc/users/users_event.dart';
import 'package:proyecto_raul/presentations/bloc/users/users_state.dart';

class BanUserBloc extends Bloc<UserEvent, UserState> {
  final CaseUserUpdateBan userBanUpdate;

  BanUserBloc(this.userBanUpdate) : super(UserBanBanInitial()) {
    on<UserUpdateBan>((event, emit) async {
      emit(UserBanBanLoading());
      try {
        final user = await userBanUpdate(event.banned, event.email);
        emit(UserBanBanLoaded(user));
      } catch (e) {
        emit(UserBanError(message: e.toString()));
      }
    });
  }
}
