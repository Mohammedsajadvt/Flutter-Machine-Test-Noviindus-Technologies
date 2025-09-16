import 'package:flutter/material.dart';
import 'dart:async';

import 'package:novindus/core/constants/helpers.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login'); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          color: Colors.black.withOpacity(0.5), 
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Image.asset(
              "assets/images/logo.png",
              width: ResponsiveHelper.getScreenWidth(context) * 0.35,
height: ResponsiveHelper.getScreenWidth(context) * 0.35,
            ),
          ),
        ),
      ],
    );
  }
}
