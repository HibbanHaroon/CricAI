import 'dart:developer' as devtools show log;
import 'package:cricai/services/auth/auth_service.dart';
import 'package:cricai/views/page_controller.dart';
import 'package:cricai/views/sessions/create_update_session_view.dart';
import 'package:cricai/views/sessions/session_view.dart';
import 'package:cricai/views/sessions/view_result.dart';
import 'package:flutter/material.dart';
import 'package:cricai/constants/routes.dart';
import 'package:cricai/views/user_authentication/verify_email_view.dart';
import 'package:cricai/views/user_authentication/forgot_password_view.dart';
import 'package:cricai/views/user_authentication/login_view.dart';
import 'package:cricai/views/user_authentication/register_view.dart';
import 'package:cricai/views/splash.dart';
import 'package:cricai/views/sessions/video_player.dart';

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
        registerRoute: (context) => const RegisterView(),
        pagesControllerRoute: (context) => const PagesController(),
        createUpdateSessionRoute: (context) => const CreateUpdateSessionView(),
        sessionRoute: (context) => const SessionView(),
        viewResultRoute: (context) => const ResultView(),
        videoPlayerRoute: (context) => const VideoPlayer(),
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
                return const PagesController();
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
