import 'package:cricai/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:cricai/constants/routes.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _confirmPassword;

  @override
  void initState() {
    _name = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
    _confirmPassword = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
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
                      "Welcome to CricAI",
                      style: TextStyle(
                        color: Color(0xFFE4E4E7),
                        fontFamily: 'SF Pro Display',
                        fontSize: 18.0,
                      ),
                    ),
                    Text(
                      "Please signup",
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
                  width: 1, // Set the border width
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
                        controller: _name,
                        decoration: InputDecoration(
                          hintText: 'Name',
                          hintStyle: const TextStyle(
                            color: AppColors.placeholderColor,
                          ),
                          contentPadding:
                              const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
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
                          contentPadding:
                              const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
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
                          contentPadding:
                              const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
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
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 14.0, left: 7.0, right: 7.0, bottom: 0.0),
                      child: TextField(
                        controller: _confirmPassword,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          hintText: 'Confirm Password',
                          hintStyle: const TextStyle(
                            color: AppColors.placeholderColor,
                          ),
                          contentPadding:
                              const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
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
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 8.0, right: 8.0, bottom: 12.0),
                      child: ElevatedButton(
                        onPressed: () async {},
                        style: TextButton.styleFrom(
                          fixedSize: const Size(398.0, 60.0),
                          backgroundColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: const Text(
                          'Signup',
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
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0, bottom: 210.0),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            loginRoute,
                            (route) => false,
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          foregroundColor: const Color(0xFFFFFFFF),
                        ),
                        child: const Text.rich(
                          TextSpan(
                            text: "Already have an account? ",
                            style: TextStyle(
                                color: AppColors.darkTextColor,
                                fontWeight: FontWeight.w400),
                            children: [
                              TextSpan(
                                text: "Login!",
                                style: TextStyle(fontWeight: FontWeight.bold),
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
  }
}
