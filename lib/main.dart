import 'dart:developer' as devtools show log;
import 'package:cricai/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:cricai/constants/routes.dart';
import 'package:cricai/views/new_password_view.dart';
import 'package:cricai/views/verify_email_view.dart';
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
        verifyEmailRoute: (context) => const VerifyEmailView(),
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
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                //user is present and account is verified
                devtools.log('You are a verified user.');
                return const HomeView();
              } else {
                //user is present but email is not verified.
                devtools.log('You need to verify your email first.');
                return const VerifyEmailView();
              }
            } else {
              //user is not present
              return const LoginView();
            }
          default:
            //Instead of writing Loading
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
