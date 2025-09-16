import 'package:flutter/material.dart';
import 'package:novindus/features/auth/pages/booking_list_screen.dart';
import 'package:novindus/features/auth/pages/login_screen.dart';
import 'package:novindus/features/auth/pages/register_screen.dart';
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
        primaryColor: const Color(0xFF006837), // Your app color
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF006837),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF006837),
          secondary: const Color(0xFF006837),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF006837),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
          '/': (context) => const SplashScreen(),
          '/login':(context) => const LoginScreen(),
          '/register':(context)=>  RegisterScreen(),
          '/booking':(context) => BookingListScreen(),
      },
    );
  }
}
