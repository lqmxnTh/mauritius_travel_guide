import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  final String imageUrl;
  const SquareTile({super.key,required this.imageUrl });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.white),borderRadius: BorderRadius.circular(15),color: Colors.white),
      child: Image.network(imageUrl,height: 60,),
    );
  }
}
