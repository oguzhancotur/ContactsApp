abstract class UploadImageEvent {}

class UploadImage extends UploadImageEvent {
  String imagePath;
  UploadImage({
    required this.imagePath,
  });
}
