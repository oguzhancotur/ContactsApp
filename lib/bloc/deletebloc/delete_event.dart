abstract class DeleteUserEvent {}

class DeleteEvent extends DeleteUserEvent {
  String userId;

  DeleteEvent({required this.userId});
}
