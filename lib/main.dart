import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:novindus/screens/booking_list_screen.dart';
import 'package:novindus/screens/login_screen.dart';
import 'package:novindus/screens/register_screen.dart';
import 'package:novindus/screens/splash_screen.dart';
import 'package:novindus/providers/auth_provider.dart';
import 'package:novindus/providers/patient_provider.dart';
import 'package:novindus/providers/branch_provider.dart';
import 'package:novindus/providers/treatment_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PatientProvider()),
        ChangeNotifierProvider(create: (_) => BranchProvider()),
        ChangeNotifierProvider(create: (_) => TreatmentProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF006837),
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
      ),
    );
  }
}
