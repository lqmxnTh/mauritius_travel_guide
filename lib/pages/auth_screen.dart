import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mauritius_travel_guide/pages/login_or_register_page.dart';
import 'package:mauritius_travel_guide/pages/navpages/main_page.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          //user is log in
          if(snapshot.hasData){
            return const MainPage();
          }
          //user is not log in
          else{
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
