import 'package:firebase_connection_1/blocs/auth/auth_bloc.dart';
import 'package:firebase_connection_1/pages/home_page.dart';
import 'package:firebase_connection_1/pages/sign_in_page.dart';
import 'package:firebase_connection_1/pages/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
      ],
      child: MaterialApp(
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData.dark(useMaterial3: true),
        home: SignUpPage(),
      ),
    );
  }
}