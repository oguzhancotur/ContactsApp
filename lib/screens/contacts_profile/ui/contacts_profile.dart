import 'dart:convert';
import 'dart:io';
import 'package:contactsapp/bloc/deletebloc/delete_bloc.dart';
import 'package:contactsapp/bloc/deletebloc/delete_event.dart';
import 'package:contactsapp/bloc/userbloc/user_bloc.dart';
import 'package:contactsapp/bloc/userbloc/user_event.dart';
import 'package:contactsapp/screens/contacts_profile/widget/alert_modal.dart';
import 'package:flutter/material.dart';
import 'package:contactsapp/usermodel/model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../constants/constant_color.dart';
import '../../../constants/constant_text.dart';

class ContactsProfile extends StatefulWidget {
  final UserInfo user;
  const ContactsProfile({
    super.key,
    required this.user,
  });

  @override
  _ContactsProfileState createState() => _ContactsProfileState();
}

class _ContactsProfileState extends State<ContactsProfile> {
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
                TextButton(
                  onPressed: () {},
                  child: Text(
                    ConstantText.edit,
                    style: ConstantTextStyles.nunitoMedium16.copyWith(
                      color: ConstantColor.blue,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            CircleAvatar(
              backgroundImage: NetworkImage(widget.user.profileImageUrl!),
              backgroundColor: ConstantColor.grey,
              radius: MediaQuery.of(context).size.width * 0.24,
              child: imagefile == null
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
                ConstantText.changePhoto,
                style: ConstantTextStyles.nunitoBold16.copyWith(
                  color: ConstantColor.black,
                ),
              ),
              onTap: () {},
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.02),
                      child: Text(
                        widget.user.firstName!,
                        style: ConstantTextStyles.nunitoBold16.copyWith(
                          color: ConstantColor.black,
                        ),
                      ),
                    ),
                    Divider(
                      height: MediaQuery.of(context).size.width * 0.08,
                      thickness: 2,
                      color: ConstantColor.grey,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.02),
                      child: Text(
                        widget.user.lastName!,
                        style: ConstantTextStyles.nunitoBold16.copyWith(
                          color: ConstantColor.black,
                        ),
                      ),
                    ),
                    Divider(
                      height: MediaQuery.of(context).size.width * 0.08,
                      thickness: 2,
                      color: ConstantColor.grey,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.02),
                      child: Text(
                        widget.user.phoneNumber!,
                        style: ConstantTextStyles.nunitoBold16.copyWith(
                          color: ConstantColor.black,
                        ),
                      ),
                    ),
                    Divider(
                      height: MediaQuery.of(context).size.width * 0.08,
                      thickness: 2,
                      color: ConstantColor.grey,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.02),
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            isDismissible: false,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            isScrollControlled: true,
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.26,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.03,
                                    ),
                                    Text(
                                      ConstantText.deleteAccount,
                                      style: ConstantTextStyles.nunitoBold24
                                          .copyWith(
                                        color: ConstantColor.redDeleteAccount,
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.03,
                                    ),
                                    ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  ConstantColor.pageColor),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                          ),
                                          minimumSize:
                                              MaterialStateProperty.all(Size(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.80,
                                                  MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.06))),
                                      onPressed: () {
                                        context.read<DeleteBloc>().add(
                                            DeleteEvent(
                                                userId: widget.user.id!));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: AlertModal(
                                              info:
                                                  ConstantText.accountDeleted),
                                          duration: const Duration(seconds: 2),

                                          backgroundColor: ConstantColor
                                              .white, // Arka plan rengi
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ));
                                        context
                                            .read<UserBloc>()
                                            .add(ResetEvent());
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        ConstantText.yes,
                                        style: ConstantTextStyles.nunitoBold24
                                            .copyWith(
                                          color: ConstantColor.black,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.012,
                                    ),
                                    ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  ConstantColor.pageColor),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                          ),
                                          minimumSize:
                                              MaterialStateProperty.all(Size(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.80,
                                                  MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.06))),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        ConstantText.no,
                                        style: ConstantTextStyles.nunitoBold24
                                            .copyWith(
                                          color: ConstantColor.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Text(
                          ConstantText.deleteContact,
                          style: ConstantTextStyles.nunitoBold16.copyWith(
                            color: ConstantColor.redDeleteAccount,
                          ),
                        ),
                      ),
                    ),
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
