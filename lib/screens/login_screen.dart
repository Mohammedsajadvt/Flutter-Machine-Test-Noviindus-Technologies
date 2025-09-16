import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:novindus/core/constants/helpers.dart';
import 'package:novindus/core/widgets/CustomButton.dart';
import 'package:novindus/core/widgets/CustomTextField.dart';
import 'package:novindus/providers/auth_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: ResponsiveHelper.getScreenHeight(context) * 0.25,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: Colors.black.withOpacity(0.4),
              child: Center(
                child: Image.asset(
                  "assets/images/logo.png",
                  height: ResponsiveHelper.getScreenHeight(context) * 0.10,
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.getScreenWidth(context) * 0.05,
                  vertical: ResponsiveHelper.getScreenHeight(context) * 0.02,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Consumer<AuthProvider>(
                  builder: (context, authProvider, _) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (authProvider.error != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(authProvider.error!)),
                        );
                      } else if (authProvider.token != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Login successful!')),
                        );
                        // TODO: Navigate to home or booking screen
                      }
                    });
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Login Or Register To Book Your Appointments",
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getScreenWidth(context) * 0.06,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff404040),
                          ),
                        ),
                        SizedBox(height: ResponsiveHelper.getScreenHeight(context) * 0.08),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Text(
                                'Username',
                                style: TextStyle(
                                  color: const Color(0xff404040),
                                  fontSize: ResponsiveHelper.getScreenWidth(context) * 0.04,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: ResponsiveHelper.getScreenHeight(context) * 0.01),
                        CustomTextField(
                          label: "Username",
                          hint: "Enter your username",
                          controller: usernameController,
                        ),
                        SizedBox(height: ResponsiveHelper.getScreenHeight(context) * 0.04),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Text(
                                'Password',
                                style: TextStyle(
                                  color: const Color(0xff404040),
                                  fontSize: ResponsiveHelper.getScreenWidth(context) * 0.04,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: ResponsiveHelper.getScreenHeight(context) * 0.01),
                        CustomTextField(
                          label: "Password",
                          hint: "Enter password",
                          obscureText: true,
                          controller: passwordController,
                        ),
                        SizedBox(height: ResponsiveHelper.getScreenHeight(context) * 0.08),
                        CustomButton(
                          textColor: Colors.white,
                          text: authProvider.isLoading ? "Logging in..." : "Login",
                          onPressed: () {
                            if (!authProvider.isLoading) {
                              FocusScope.of(context).unfocus();
                              authProvider.login(
                                usernameController.text,
                                passwordController.text,
                              );
                            }
                          },
                          color: const Color(0xFF006837),
                        ),
                        SizedBox(height: ResponsiveHelper.getScreenHeight(context) * 0.10),
                        Text.rich(
                          TextSpan(
                            text: "By creating or logging into an account you are agreeing with our ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: ResponsiveHelper.getScreenWidth(context) * 0.03,
                            ),
                            children: [
                              TextSpan(
                                text: "Terms and Conditions",
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const TextSpan(text: " and "),
                              TextSpan(
                                text: "Privacy Policy.",
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
