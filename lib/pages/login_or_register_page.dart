import 'package:flutter/cupertino.dart';
import 'package:mauritius_travel_guide/pages/sign_in_page.dart';
import 'package:mauritius_travel_guide/pages/sign_up_page.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({Key? key}) : super(key: key);

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLoginPage = true;

  void togglePages(){
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showLoginPage){
      return SignInPage(
        onTap: togglePages,
      );
    }
    else{
      return SignUpPage(
        onTap: togglePages,
      );
    }
  }
}
