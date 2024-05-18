import 'package:contactsapp/usermodel/model.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  List<UserInfo> userList;
  UserLoaded({
    required this.userList,
  });
}

class UserError extends UserState {}
