import 'package:flutter/material.dart';
import 'package:cricai/constants/routes.dart';
import 'package:cricai/views/new_password_view.dart';
import 'package:cricai/views/verification_code_view.dart';
import 'package:cricai/views/forgot_password_view.dart';
import 'package:cricai/views/home_view.dart';
import 'package:cricai/views/login_view.dart';
import 'package:cricai/views/register_view.dart';
import 'package:cricai/views/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CricAI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashView(),
      routes: {
        splashRoute: (context) => SplashView(),
        loginRoute: (context) => const LoginView(),
        forgotPasswordRoute: (context) => const ForgotPasswordView(),
        verificationCodeRoute: (context) => const VerificationCodeView(),
        newPasswordRoute: (context) => const NewPasswordView(),
        registerRoute: (context) => const RegisterView(),
        homeRoute: (context) => const HomeView(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginView();
  }
}
