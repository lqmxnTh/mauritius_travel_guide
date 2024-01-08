import 'package:flutter/material.dart';
import 'package:mauritius_travel_guide/pages/auth_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double imageSize = 100.0; // Initial size of the image

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() async {
    await Future.delayed(Duration(milliseconds: 200));
    setState(() {
      imageSize = 300.0;
    });
    await Future.delayed(Duration(milliseconds: 1600 + 1000));

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => AuthScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 1600),
            width: imageSize,
            height: imageSize,
            child: Image.asset('assets/images/splash.png'),
          ),
        ),
      ),
    );
  }
}
