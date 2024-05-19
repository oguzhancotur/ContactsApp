import 'package:contactsapp/bloc/userbloc/user_bloc.dart';
import 'package:contactsapp/bloc/userbloc/user_event.dart';
import 'package:contactsapp/bloc/userbloc/user_state.dart';
import 'package:contactsapp/constants/constant_color.dart';
import 'package:contactsapp/constants/constant_text.dart';
import 'package:contactsapp/screens/contacts_main/widget/contacts_card.dart';
import 'package:contactsapp/screens/new_contact/ui/new_contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactsMain extends StatefulWidget {
  const ContactsMain({super.key});

  @override
  _ContactsMainState createState() => _ContactsMainState();
}

class _ContactsMainState extends State<ContactsMain> {
  String _searchTerm = '';

  void _filterContacts(String query) {
    setState(() {
      _searchTerm = query.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColor.pageColor,
      appBar: AppBar(
        backgroundColor: ConstantColor.pageColor,
        elevation: 0,
        title: Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.02,
            right: MediaQuery.of(context).size.width * 0.01,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ConstantText.contacts,
                style: ConstantTextStyles.nunitoBold24.copyWith(
                  color: ConstantColor.black,
                ),
              ),
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    isDismissible: false,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return const NewContact();
                    },
                  );
                },
                icon: Image.asset(ConstantImages.addIcon),
              )
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.005,
              bottom: MediaQuery.of(context).size.height * 0.005,
              left: MediaQuery.of(context).size.width * 0.06,
              right: MediaQuery.of(context).size.width * 0.06,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.92,
              height: MediaQuery.of(context).size.height * 0.045,
              child: TextField(
                onChanged: _filterContacts,
                decoration: InputDecoration(
                  fillColor: ConstantColor.white,
                  filled: true,
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.01,
                    ),
                    child: Icon(
                      Icons.search,
                      color: ConstantColor.grey,
                      size: MediaQuery.of(context).size.width * 0.07,
                    ),
                  ),
                  hintText: ConstantText.search,
                  labelStyle: ConstantTextStyles.nunitoMedium16.copyWith(
                    color: ConstantColor.grey,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserInitial) {
                  context.read<UserBloc>().add(GetUserList());
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is UserLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is UserLoaded) {
                  if (state.userList.isEmpty) {
                    return Center(
                        child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.35,
                        ),
                        CircleAvatar(
                          backgroundColor: ConstantColor.grey,
                          radius: MediaQuery.of(context).size.width * 0.08,
                          child: Icon(
                            Icons.person_sharp,
                            color: ConstantColor.white,
                            size: MediaQuery.of(context).size.width * 0.13,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.015,
                        ),
                        Text(
                          ConstantText.noContacts,
                          style: ConstantTextStyles.nunitoBold24.copyWith(
                            color: ConstantColor.black,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.006,
                        ),
                        Text(
                          ConstantText.contactsHere,
                          style: ConstantTextStyles.nunitoBold16.copyWith(
                            color: ConstantColor.black,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.006,
                        ),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              isDismissible: false,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              isScrollControlled: true,
                              context: context,
                              builder: (BuildContext context) {
                                return const NewContact();
                              },
                            );
                          },
                          child: Text(
                            ConstantText.contactsNew,
                            style: ConstantTextStyles.nunitoBold16.copyWith(
                              color: ConstantColor.blue,
                            ),
                          ),
                        ),
                      ],
                    ));
                  } else {
                    return ListView.builder(
                      itemCount: state.userList.length,
                      itemBuilder: (context, index) {
                        final user = state.userList[index];
                        if (_searchTerm.isEmpty ||
                            user.firstName!
                                .toLowerCase()
                                .contains(_searchTerm)) {
                          return ContactsCard(
                            id: user.id!,
                            firstName: user.firstName!,
                            lastName: user.lastName!,
                            number: user.phoneNumber!,
                            image: user.profileImageUrl!,
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    );
                  }
                } else if (state is UserError) {
                  return const Center(
                    child: Text(ConstantText.errorMessage),
                  );
                } else {
                  return const Center(
                    child: Text(ConstantText.wrong),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
