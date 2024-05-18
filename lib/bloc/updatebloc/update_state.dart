abstract class UpdateState {}

final class UpdateInitial extends UpdateState {}

class UpdateLoading extends UpdateState {}

class UpdateLoaded extends UpdateState {}

class UpdateError extends UpdateState {}
