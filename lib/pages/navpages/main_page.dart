// ignore_for_file: non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mauritius_travel_guide/pages/homepage.dart';
import 'package:mauritius_travel_guide/pages/navpages/booking.dart';
import 'package:mauritius_travel_guide/pages/navpages/favourite_page.dart';
import 'package:mauritius_travel_guide/pages/navpages/my_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}
void SignOut() {
  FirebaseAuth.instance.signOut();
}
class _MainPageState extends State<MainPage> {
  List pages = [
    HomePage(),
    const FavouritePage(),
    const BookingPage(),
    const MyPage(),
  ];
  int _currentIndex = 0;
  void onTap(int index){
    setState(() {
      _currentIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        onTap: onTap,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.blue.shade100,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        elevation: 0,
        items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home),label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.favorite_border),label: "Loves"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today_rounded),label: "Booking"),
          BottomNavigationBarItem(icon: Icon(Icons.person),label: "Account"),

      ],),
    );
  }
}
