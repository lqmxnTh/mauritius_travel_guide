// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class AppButtons extends StatelessWidget {
  final Color color;
  final IconData? icon;
  final Color backgroundColor;
  final double size;
  final Color borderColor;
  final void Function()? onTap;

  bool isFavorite = false;

  AppButtons({
    Key? key,
    required this.onTap,
    this.icon,
    required this.size,
    required this.color,
    required this.backgroundColor,
    required this.borderColor,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: 1.0),
            borderRadius: BorderRadius.circular(15),
            color: backgroundColor,
          ),
          child: Center(
            child: Icon(
              icon,
              color: color,
              size: 35,
            ),
          ),
      ),
    );
  }
}
