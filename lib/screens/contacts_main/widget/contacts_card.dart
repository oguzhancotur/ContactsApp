import 'package:flutter/material.dart';

import 'package:contactsapp/usermodel/model.dart';
import 'package:contactsapp/screens/contacts_profile/ui/contacts_profile.dart';

import '../../../constants/constant_color.dart';
import '../../../constants/constant_text.dart';

class ContactsCard extends StatefulWidget {
  String firstName;
  String lastName;
  String number;
  String image;
  String id;
  ContactsCard({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.number,
    required this.image,
    required this.id,
  }) : super(key: key);

  @override
  _ContactsCardState createState() => _ContactsCardState();
}

class _ContactsCardState extends State<ContactsCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.06,
        right: MediaQuery.of(context).size.width * 0.06,
        top: MediaQuery.of(context).size.width * 0.04,
        bottom: MediaQuery.of(context).size.width * 0.01,
      ),
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            isDismissible: false,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40.0),
            ),
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return ContactsProfile(
                user: UserInfo(
                    id: widget.id,
                    firstName: widget.firstName,
                    lastName: widget.lastName,
                    phoneNumber: widget.number,
                    profileImageUrl: widget.image),
              );
            },
          );
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.92,
          height: MediaQuery.of(context).size.height * 0.075,
          decoration: BoxDecoration(
            color: ConstantColor.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.04,
                  bottom: MediaQuery.of(context).size.width * 0.04,
                  top: MediaQuery.of(context).size.width * 0.04,
                  right: MediaQuery.of(context).size.width * 0.02,
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.10,
                  height: MediaQuery.of(context).size.width * 0.10,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(widget.image),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${widget.firstName} ${widget.lastName}",
                      style: ConstantTextStyles.nunitoBold16.copyWith(
                        color: ConstantColor.black,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.005,
                    ),
                    Text(
                      widget.number,
                      style: ConstantTextStyles.nunitoMedium16.copyWith(
                        color: ConstantColor.grey,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
