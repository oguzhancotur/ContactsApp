import 'package:contactsapp/service/service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contactsapp/bloc/updatebloc/update_event.dart';
import 'package:contactsapp/bloc/updatebloc/update_state.dart';

class UpdateBloc extends Bloc<UpdateEvent, UpdateState> {
  ApiService service;
  UpdateBloc({required this.service}) : super(UpdateInitial()) {
    on<UpdateUser>((event, emit) async {
      emit(UpdateLoading());
      try {
        final userUpdate = await service.updateUser(event.id, event.firstName,
            event.lastName, event.phoneNumber, event.imagePath);
        emit(UpdateLoaded());
      } catch (e) {
        emit(UpdateError());
      }
    });
  }
}
