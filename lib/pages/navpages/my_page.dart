import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mauritius_travel_guide/components/app_text.dart';
import 'package:mauritius_travel_guide/components/my_button.dart';
import 'package:mauritius_travel_guide/components/profile_picture.dart';
import 'package:mauritius_travel_guide/components/sub_heading_text.dart';

import '../../components/editable_text.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  void SignOut() {
    FirebaseAuth.instance.signOut();
  }

  Future<String?> getUserName() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String email = user.email!;

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.size > 0) {
        DocumentSnapshot userDocument = querySnapshot.docs[0];
        String name = userDocument['name'];
        return name;
      }
    }
    return null;
  }

  getUserEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.email.toString();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getUserName(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          String? userName = snapshot.data;
          return Scaffold(
            body: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/Beach2.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.white.withOpacity(0.6),
                      BlendMode.dstATop,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            const ProfilePictureWidget(),
                            const Text(
                              'Welcome,',
                              style: TextStyle(fontSize: 30),
                            ),
                            Text(
                              userName.toString(),
                              style: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 25,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100] ?? Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[400] ?? Colors.grey,
                              offset: Offset(0, 4),
                              blurRadius: 6,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                AppText(text: "Name"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SubHeadingTxt(txt: userName.toString()),
                              ],
                            ),
                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                AppText(text: "Email"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SubHeadingTxt(txt: getUserEmail()),
                              ],
                            ),
                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                AppText(text: "Number"),
                              ],
                            ),
                            EditableLabel(initialLabel: 'Phone Num',),
                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                AppText(text: "Nationality"),
                              ],
                            ),
                            EditableLabel(initialLabel: 'Nationality',)
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    MyButton(
                      onTap: SignOut,
                      btnText: "Sign Out",
                      color: Colors.blue,
                      icon: Icons.logout,
                      iconColour: Colors.white,
                      marginWidth: 92,
                    )
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
