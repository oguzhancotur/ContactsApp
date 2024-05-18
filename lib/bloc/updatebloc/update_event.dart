abstract class UpdateEvent {}

class UpdateUser extends UpdateEvent {
  final String id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String imagePath;

  UpdateUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.imagePath,
  });
}
