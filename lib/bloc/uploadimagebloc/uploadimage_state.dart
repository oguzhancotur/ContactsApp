abstract class UploadImageState {}

class UploadImageInitial extends UploadImageState {}

class UploadImageLoading extends UploadImageState {}

class UploadImageLoaded extends UploadImageState {
  String imageUrl;
  UploadImageLoaded({
    required this.imageUrl,
  });
}

class UploadImageError extends UploadImageState {}
