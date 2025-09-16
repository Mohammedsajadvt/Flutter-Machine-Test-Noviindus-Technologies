import 'package:flutter/material.dart';
import 'package:novindus/features/auth/pages/login_screen.dart';
import 'package:novindus/features/auth/pages/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routes: {
          '/': (context) => const SplashScreen(),
          '/login':(context) => const LoginScreen()
      },
    );
  }
}
