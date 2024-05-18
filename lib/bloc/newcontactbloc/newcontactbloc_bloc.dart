import 'package:contactsapp/bloc/newcontactbloc/newcontactbloc_event.dart';
import 'package:contactsapp/bloc/newcontactbloc/newcontactbloc_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contactsapp/service/service.dart';

class NewContactBloc extends Bloc<NewContactEvent, NewContactState> {
  final ApiService service;
  NewContactBloc({required this.service}) : super(NewContactInitial()) {
    on<CreateUserEvent>((event, emit) async {
      emit(NewContactLoading());
      try {
        final createUser = await service.createUser(event.firstName,
            event.lastName, event.phoneNumber, event.imagePath);
      } catch (e) {
        emit(NewContactError());
      }
    });
  }
}
