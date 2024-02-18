import 'dart:developer' as devtools show log;
import 'package:cricai/services/auth/auth_exceptions.dart';
import 'package:cricai/services/auth/auth_service.dart';
import 'package:cricai/utilities/snackbar/error_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:cricai/constants/colors.dart';
import 'package:cricai/constants/routes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ),
            child: Column(
              children: [
                Container(
                  width: screenWidth,
                  color: AppColors.backgroundColor,
                  child: const Padding(
                    padding: EdgeInsets.only(top: 80.0, bottom: 30),
                    child: Column(
                      children: [
                        Text(
                          "Welcome back",
                          style: TextStyle(
                            color: Color(0xFFE4E4E7),
                            fontFamily: 'SF Pro Display',
                            fontSize: 18.0,
                          ),
                        ),
                        Text(
                          "Please login",
                          style: TextStyle(
                            color: Color(0xFFE4E4E7),
                            fontFamily: 'SF Pro Display',
                            fontSize: 30.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    border: Border.all(
                      color: const Color(0xFFE1EFFE),
                      width: 1,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(35.0),
                      topRight: Radius.circular(35.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 14.0, left: 7.0, right: 7.0, bottom: 0.0),
                          child: TextField(
                            controller: _email,
                            autocorrect: false,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              hintStyle: const TextStyle(
                                color: AppColors.placeholderColor,
                              ),
                              contentPadding: const EdgeInsets.fromLTRB(
                                  20.0, 20.0, 20.0, 20.0),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: AppColors.placeholderColor,
                                    width: 1.0),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            style: const TextStyle(
                              fontFamily: 'SF Pro Display',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              fontSize: 18.0,
                              height: 1.0,
                              color: AppColors.darkTextColor,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 14.0, left: 7.0, right: 7.0, bottom: 0.0),
                          child: TextField(
                            controller: _password,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              hintStyle: const TextStyle(
                                color: AppColors.placeholderColor,
                              ),
                              contentPadding: const EdgeInsets.fromLTRB(
                                  20.0, 20.0, 20.0, 20.0),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color(0xFFD4D4D8), width: 1.0),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            style: const TextStyle(
                              fontFamily: 'SF Pro Display',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              fontSize: 18.0,
                              height: 1.0,
                              color: AppColors.darkTextColor,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 15.0, right: 15.0),
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                  forgotPasswordRoute,
                                );
                              },
                              style: TextButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                foregroundColor: const Color(0xFFFFFFFF),
                              ),
                              child: const Text(
                                "Forgot password?",
                                style: TextStyle(
                                  fontFamily: 'Satoshi',
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.0,
                                  decoration: TextDecoration.underline,
                                  color: Color(0xFF2A2A2A),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, left: 8.0, right: 8.0, bottom: 12.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              final email = _email.text.trim();
                              final password = _password.text;
                              try {
                                await AuthService.firebase().logIn(
                                  email: email,
                                  password: password,
                                );
                                final user = AuthService.firebase().currentUser;
                                if (user?.isEmailVerified ?? false) {
                                  //user's email is verified.
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                    homeRoute,
                                    (route) => false,
                                  );
                                } else {
                                  //user's email is not verified.
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                    verifyEmailRoute,
                                    (route) => false,
                                  );
                                }
                                /*Navigator.of(context).pushNamedAndRemoveUntil('', (route) => false)*/
                              } on UserNotFoundAuthException {
                                devtools.log('User not found.');
                                showErrorSnackbar(
                                  context,
                                  'User Not Found',
                                );
                              } on WrongPasswordAuthException {
                                devtools.log('Wrong Password');
                                showErrorSnackbar(
                                  context,
                                  'Incorrect Password',
                                );
                              } on GenericAuthException {
                                devtools.log('Authentication error.');
                                showErrorSnackbar(
                                  context,
                                  'Authentication Error.',
                                );
                              }
                            },
                            style: TextButton.styleFrom(
                              fixedSize: const Size(398.0, 60.0),
                              backgroundColor: AppColors.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                fontFamily: 'SF Pro Display',
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w700,
                                fontSize: 18.0,
                                color: AppColors.lightTextColor,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 5.0,
                                left: 20.0,
                                right: 12.0,
                                bottom: 5.0,
                              ),
                              child: Container(
                                width: 147,
                                height: 1,
                                color: const Color(0xFFD4D4D8),
                              ),
                            ),
                            const Text(
                              "or",
                              style: TextStyle(
                                color: Color(0xFF71717A),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 5.0,
                                left: 12.0,
                                right: 12.0,
                                bottom: 5.0,
                              ),
                              child: Container(
                                width: 147,
                                height: 1,
                                color: const Color(0xFFD4D4D8),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Handle button press
                            },
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(340.0, 60.0),
                              backgroundColor: const Color(0xFF1877F2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                            icon: const Padding(
                              padding: EdgeInsets.only(),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: FaIcon(
                                  FontAwesomeIcons.facebookF,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            label: const Padding(
                              padding: EdgeInsets.only(left: 45, right: 70),
                              child: Text(
                                'Continue with Facebook',
                                style: TextStyle(
                                  fontFamily: 'Satoshi',
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Handle button press
                            },
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(340.0, 60.0),
                              backgroundColor: const Color(0xFFD4D4D8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                            icon: const Padding(
                              padding: EdgeInsets.only(),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: FaIcon(
                                  FontAwesomeIcons.google,
                                  size: 20,
                                  color: AppColors.darkTextColor,
                                ),
                              ),
                            ),
                            label: const Padding(
                              padding: EdgeInsets.only(left: 47, right: 80),
                              child: Text(
                                'Continue with Google',
                                style: TextStyle(
                                  fontFamily: 'Satoshi',
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: AppColors.darkTextColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 110.0, bottom: 31.0),
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                registerRoute,
                                (route) => false,
                              );
                            },
                            style: TextButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                              foregroundColor: const Color(0xFFFFFFFF),
                            ),
                            child: const Text.rich(
                              TextSpan(
                                text: "Don't have an account? ",
                                style: TextStyle(
                                    color: AppColors.darkTextColor,
                                    fontWeight: FontWeight.w400),
                                children: [
                                  TextSpan(
                                    text: "Sign up!",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
