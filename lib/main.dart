import 'package:contactsapp/bloc/deletebloc/delete_bloc.dart';
import 'package:contactsapp/bloc/newcontactbloc/newcontactbloc_bloc.dart';
import 'package:contactsapp/bloc/updatebloc/update_bloc.dart';
import 'package:contactsapp/bloc/uploadimagebloc/uploadimage_bloc.dart';
import 'package:contactsapp/bloc/userbloc/user_bloc.dart';
import 'package:contactsapp/screens/contacts_main/ui/contacts_main.dart';
import 'package:contactsapp/service/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MultiBlocProvider(providers: [
    BlocProvider<UserBloc>(
      create: (context) => UserBloc(service: ApiService()),
    ),
    BlocProvider<NewContactBloc>(
      create: (context) => NewContactBloc(service: ApiService()),
    ),
    BlocProvider<UploadImageBloc>(
      create: (context) => UploadImageBloc(service: ApiService()),
    ),
    BlocProvider<DeleteBloc>(
        create: (context) => DeleteBloc(service: ApiService())),
    BlocProvider<UpdateBloc>(
        create: (context) => UpdateBloc(service: ApiService())),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Contacts App',
        home: ContactsMain());
  }
}
