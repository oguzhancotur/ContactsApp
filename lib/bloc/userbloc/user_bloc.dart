import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:contactsapp/bloc/userbloc/user_event.dart';
import 'package:contactsapp/bloc/userbloc/user_state.dart';
import 'package:contactsapp/service/service.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  ApiService service;
  UserBloc({
    required this.service,
  }) : super(UserInitial()) {
    on<GetUserList>((event, emit) async {
      emit(UserLoading());
      try {
        final userList = await service.getUsers();
        emit(UserLoaded(userList: userList));
      } catch (e) {
        emit(UserError());
      }
    });

    on<ResetEvent>((event, emit) async {
      emit(UserInitial());
    });
  }
}
