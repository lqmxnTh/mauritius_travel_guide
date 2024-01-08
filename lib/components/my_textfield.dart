// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  final IconData? iconData;
  final double borderRadius;

  const MyTextField({required this.controller,this.iconData, required this.hintText, required this.obscureText, super.key, this.borderRadius = 8});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: Icon(iconData),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(borderRadius)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(borderRadius)),
            fillColor: Colors.grey.shade200,
            filled: true,
            hintText: hintText,),
      ),
    );
  }
}
