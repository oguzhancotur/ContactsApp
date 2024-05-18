import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:contactsapp/bloc/deletebloc/delete_event.dart';
import 'package:contactsapp/bloc/deletebloc/delete_state.dart';
import 'package:contactsapp/service/service.dart';

class DeleteBloc extends Bloc<DeleteEvent, DeleteState> {
  ApiService service;
  DeleteBloc({required this.service}) : super(DeleteInitial()) {
    on<DeleteEvent>((event, emit) async {
      emit(DeleteLoading());
      try {
        await service.deleteUser(event.userId);
      } catch (e) {
        emit(DeleteError());
      }
    });
  }
}
