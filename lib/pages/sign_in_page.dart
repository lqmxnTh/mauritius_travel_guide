// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mauritius_travel_guide/components/my_button.dart';
import 'package:mauritius_travel_guide/components/my_textfield.dart';
import 'package:mauritius_travel_guide/components/square_tile.dart';

class SignInPage extends StatefulWidget {
  final Function()? onTap;
  const SignInPage({super.key, required this.onTap});

  @override
  State<SignInPage> createState() => _SignInPageState();
  
}

class _SignInPageState extends State<SignInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signInUser() async{
    showDialog(context: context, builder: (context){
      return const Center(
        child: CircularProgressIndicator(),
      );
    });
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch(e){
      Navigator.pop(context);
      showErrowMessage(e.code);
    }
  }
  void showErrowMessage(String errorMsg){
    showDialog(context: context, builder: (context){
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: const AssetImage("assets/images/Beach3.jpg"),
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
                        Text("Welcome Back!", style: TextStyle(fontSize: 25))
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
             MyTextField(controller: emailController, iconData: Icons.email, hintText: "Enter email", obscureText: false),
              const SizedBox(
                height: 15,
              ),
              MyTextField(controller: passwordController,iconData: Icons.password, hintText: "Enter password", obscureText: true),
              const SizedBox(height: 10,),
              // const Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 25),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     children: [Text("Forget Password?")],
              //   ),
              // ),
              const SizedBox(
                height: 25,
              ),
              MyButton(onTap: signInUser, btnText: "Sign In",color: Colors.blue,icon: Icons.arrow_forward,iconColour: Colors.white,),
              const SizedBox(
                height: 40,
              ),
              // const Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 25),
              //   child: Row(children: [
              //     Expanded(
              //         child: Divider(
              //           thickness: 1.5,
              //           color: Colors.black,
              //         )),
              //     Padding(
              //         padding: EdgeInsets.symmetric(horizontal: 10.0),
              //         child: Text(
              //           "Or Continue with",
              //           style: TextStyle(color: Colors.black, fontSize: 16),
              //         )),
              //     Expanded(
              //         child: Divider(
              //       thickness: 1.5,
              //       color: Colors.black,
              //     )),
              //   ]),
              // ),
              // const SizedBox(height: 20,),
              // const Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     SquareTile(imageUrl: "http://pngimg.com/uploads/google/google_PNG19635.png",),
              //     SizedBox(width: 20,),
              //     SquareTile(imageUrl: "https://pngimg.com/uploads/facebook_logos/small/facebook_logos_PNG19753.png",)
              //   ],
              // ),
              const SizedBox(height: 70,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Not a member yet?", style: TextStyle(fontSize: 17),),
                  const SizedBox(width: 4,),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      "Join Now!",style: TextStyle(color: Colors.blue),),
                  )],
              )
            ],
          ),
        ),
      ),
    );
  }
}
