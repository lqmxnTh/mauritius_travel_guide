import 'package:flutter/cupertino.dart';

class SubHeadingTxt extends StatelessWidget {
  final String txt;
  const SubHeadingTxt({Key? key, required this.txt}) : super(key: key);

  @override

  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            txt,
            style:
            const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ],
      );
  }
}
