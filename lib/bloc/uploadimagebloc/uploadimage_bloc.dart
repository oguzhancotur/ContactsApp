import 'package:contactsapp/bloc/uploadimagebloc/uploadimage_event.dart';
import 'package:contactsapp/bloc/uploadimagebloc/uploadimage_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contactsapp/service/service.dart';

class UploadImageBloc extends Bloc<UploadImageEvent, UploadImageState> {
  ApiService service;
  UploadImageBloc({required this.service}) : super(UploadImageInitial()) {
    on<UploadImage>((event, emit) async {
      emit(UploadImageLoading());
      try {
        final imageUrl = await service.uploadImage(event.imagePath);
        emit(UploadImageLoaded(imageUrl: imageUrl));
      } catch (e) {
        emit(UploadImageError());
      }
    });
  }
}
