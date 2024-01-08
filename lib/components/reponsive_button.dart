// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'app_text.dart';

class ResponsiveButton extends StatelessWidget {
  final bool? isResponsive;
  final double? width;
  final VoidCallback onTap;

  const ResponsiveButton({Key? key, this.width = 120, this.isResponsive = false, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color mainColor = Colors.lightBlue;
    return Flexible(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: isResponsive == true ? double.maxFinite : width,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: mainColor,
          ),
          child: Row(
            mainAxisAlignment: isResponsive == true
                ? MainAxisAlignment.spaceAround
                : MainAxisAlignment.center,
            children: [
              isResponsive == true
                  ? AppText(
                text: "Book Now",
                color: Colors.white,
              )
                  : Container(),
              const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
