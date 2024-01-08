// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mauritius_travel_guide/components/my_button.dart';
import 'package:mauritius_travel_guide/components/my_textfield.dart';

class SignUpPage extends StatefulWidget {
  final Function()? onTap;
  const SignUpPage({super.key, required this.onTap});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  void signUpUser() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    try {
      addUserDetail(nameController.text.trim(), emailController.text.trim());
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showErrowMessage(e.code);
    }
  }

  void showErrowMessage(String errorMsg) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.blue,
            title: Center(
              child: Text(
                errorMsg,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        });
  }

  Future addUserDetail(String name, String email) async {
    await FirebaseFirestore.instance
        .collection("users")
        .add({'email': email,'name': name});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: const AssetImage("assets/images/Beach1.jpg"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.5), BlendMode.dstATop),
        )),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                  height: 160,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage("assets/images/logo.png"),
                    fit: BoxFit.contain,
                  ))),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 40),
                        ),
                        Text("Join Us Now!", style: TextStyle(fontSize: 25))
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              MyTextField(
                  controller: nameController,
                  hintText: "Enter name",
                  iconData: Icons.person,
                  obscureText: false),
              const SizedBox(
                height: 15,
              ),
              MyTextField(
                  controller: emailController,
                  hintText: "Enter email",
                  iconData: Icons.email,
                  obscureText: false),
              const SizedBox(
                height: 15,
              ),
              MyTextField(
                  controller: passwordController,
                  hintText: "Enter password",
                  iconData: Icons.password,
                  obscureText: true),
              const SizedBox(
                height: 25,
              ),
              MyButton(onTap: signUpUser, btnText: "Sign Up",color: Colors.blue,icon: Icons.arrow_forward,iconColour: Colors.white,),
              const SizedBox(
                height: 40,
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already a member?",
                    style: TextStyle(fontSize: 17),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      "Login Now!",
                      style: TextStyle(color: Colors.blue),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
