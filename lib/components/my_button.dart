import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String btnText;
  final IconData? icon;
  final Color? color;
  final Color? iconColour;
  final double marginWidth;
  const MyButton({Key? key, required this.onTap, this.icon,this.marginWidth = 25.0, required this.btnText, this.color, this.iconColour})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(15),
            margin: EdgeInsets.symmetric(horizontal: marginWidth),
            decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8)),
            child: Center(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      btnText,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    Icon(icon,color: iconColour,)
                  ]),
            ),
          ),
        ));
  }
}
