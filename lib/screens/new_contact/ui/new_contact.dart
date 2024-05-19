import 'dart:convert';
import 'dart:io';

import 'package:contactsapp/bloc/newcontactbloc/newcontactbloc_bloc.dart';
import 'package:contactsapp/bloc/newcontactbloc/newcontactbloc_event.dart';
import 'package:contactsapp/bloc/uploadimagebloc/uploadimage_bloc.dart';
import 'package:contactsapp/bloc/uploadimagebloc/uploadimage_event.dart';
import 'package:contactsapp/bloc/uploadimagebloc/uploadimage_state.dart';
import 'package:contactsapp/bloc/userbloc/user_bloc.dart';
import 'package:contactsapp/bloc/userbloc/user_event.dart';
import 'package:contactsapp/constants/constant_color.dart';
import 'package:contactsapp/screens/contacts_profile/widget/alert_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../constants/constant_text.dart';

class NewContact extends StatefulWidget {
  const NewContact({Key? key}) : super(key: key);

  @override
  _NewContactState createState() => _NewContactState();
}

class _NewContactState extends State<NewContact> {
  File? imagefile;
  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        imagefile = File(pickedImage.path);
      });

      List<int> imageBytes = await imagefile!.readAsBytes();
      String base64Image = base64Encode(imageBytes);
    }
  }

  String? _imageUrl;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 50,
      decoration: BoxDecoration(
        color: ConstantColor.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    ConstantText.cancel,
                    style: ConstantTextStyles.nunitoMedium16.copyWith(
                      color: ConstantColor.blue,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.08),
                  child: Text(
                    ConstantText.newContact,
                    style: ConstantTextStyles.nunitoMedium16.copyWith(
                      color: ConstantColor.black,
                    ),
                  ),
                ),
                BlocBuilder<UploadImageBloc, UploadImageState>(
                  builder: (context, state) {
                    if (state is UploadImageInitial) {
                      return Container();
                    } else if (state is UploadImageLoading) {
                      return Container();
                    } else if (state is UploadImageLoaded) {
                      _imageUrl = state.imageUrl;

                      context.read<NewContactBloc>().add(CreateUserEvent(
                            firstName: _firstNameController.text,
                            lastName: _lastNameController.text,
                            phoneNumber: _phoneNumberController.text,
                            imagePath: _imageUrl!,
                          ));
                      context.read<UploadImageBloc>().add(UploadImageReset());
                      context.read<UserBloc>().add(ResetEvent());
                      Navigator.pop(context);

                      return Container();
                    } else if (state is UploadImageError) {
                      return Container();
                    } else {
                      return Container();
                    }
                  },
                ),
                TextButton(
                  onPressed: () {
                    context
                        .read<UploadImageBloc>()
                        .add(UploadImage(imagePath: imagefile!.path));
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: AlertModal(info: ConstantText.userAdded),
                      duration: const Duration(seconds: 2),

                      backgroundColor: ConstantColor.white, // Arka plan rengi
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ));
                  },
                  child: Text(
                    ConstantText.done,
                    style: ConstantTextStyles.nunitoMedium16.copyWith(
                      color: ConstantColor.blue,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            CircleAvatar(
              backgroundImage: imagefile != null ? FileImage(imagefile!) : null,
              backgroundColor: ConstantColor.grey,
              radius: MediaQuery.of(context).size.width * 0.24,
              child: imagefile != null
                  ? Container()
                  : Icon(
                      Icons.person_sharp,
                      color: ConstantColor.white,
                      size: MediaQuery.of(context).size.width * 0.45,
                    ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            InkWell(
              child: Text(
                ConstantText.addPhoto,
                style: ConstantTextStyles.nunitoBold16.copyWith(
                  color: ConstantColor.black,
                ),
              ),
              onTap: () {
                showModalBottomSheet(
                  isDismissible: false,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.26,
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.1,
                                right: MediaQuery.of(context).size.width * 0.1),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          ConstantColor.pageColor),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                  minimumSize: MaterialStateProperty.all(Size(
                                      MediaQuery.of(context).size.width * 0.80,
                                      MediaQuery.of(context).size.height *
                                          0.06))),
                              onPressed: () {
                                _pickImage(ImageSource.camera);
                                Navigator.pop(context);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(ConstantImages.camera),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.03),
                                  Text(
                                    ConstantText.cameraText,
                                    style: ConstantTextStyles.nunitoBold24
                                        .copyWith(
                                      color: ConstantColor.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.012,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.1,
                                right: MediaQuery.of(context).size.width * 0.1),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          ConstantColor.pageColor),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                  minimumSize: MaterialStateProperty.all(Size(
                                      MediaQuery.of(context).size.width * 0.80,
                                      MediaQuery.of(context).size.height *
                                          0.06))),
                              onPressed: () {
                                _pickImage(ImageSource.gallery);
                                Navigator.pop(context);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    ConstantImages.picture,
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.03),
                                  Text(
                                    ConstantText.gallery,
                                    style: ConstantTextStyles.nunitoBold24
                                        .copyWith(
                                      color: ConstantColor.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.012,
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        ConstantColor.pageColor),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                                minimumSize: MaterialStateProperty.all(Size(
                                    MediaQuery.of(context).size.width * 0.80,
                                    MediaQuery.of(context).size.height *
                                        0.06))),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              ConstantText.cancel,
                              style: ConstantTextStyles.nunitoBold24.copyWith(
                                color: ConstantColor.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                    ;
                  },
                );
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.width * 0.1,
                  child: TextFormField(
                    controller: _firstNameController,
                    textAlignVertical: TextAlignVertical.top,
                    keyboardType: TextInputType.name,
                    style: ConstantTextStyles.nunitoBold16.copyWith(
                      color: ConstantColor.black,
                    ),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ConstantColor.black),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      label: const Text(ConstantText.fName),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: ConstantColor.black, width: 2),
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Container(
                  height: MediaQuery.of(context).size.width * 0.1,
                  child: TextFormField(
                    controller: _lastNameController,
                    textAlignVertical: TextAlignVertical.top,
                    keyboardType: TextInputType.name,
                    style: ConstantTextStyles.nunitoBold16.copyWith(
                      color: ConstantColor.black,
                    ),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ConstantColor.black),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      label: const Text(ConstantText.lName),
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: ConstantColor.black, width: 2),
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Container(
                  height: MediaQuery.of(context).size.width * 0.1,
                  child: TextFormField(
                    controller: _phoneNumberController,
                    textAlignVertical: TextAlignVertical.top,
                    keyboardType: TextInputType.number,
                    style: ConstantTextStyles.nunitoBold16.copyWith(
                      color: ConstantColor.black,
                    ),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ConstantColor.black),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      label: const Text(ConstantText.pNumber),
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: ConstantColor.black, width: 2),
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
