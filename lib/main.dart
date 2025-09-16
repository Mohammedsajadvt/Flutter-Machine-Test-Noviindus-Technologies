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
import 'package:novindus/core/constants/app_colors.dart';

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
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.background,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primary,
          ),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: AppColors.primary,
            secondary: AppColors.primary,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
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
