abstract class NewContactEvent {}

class CreateUserEvent extends NewContactEvent {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String imagePath;
  CreateUserEvent({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.imagePath,
  });
}
