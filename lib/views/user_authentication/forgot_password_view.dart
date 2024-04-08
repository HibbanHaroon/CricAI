import 'dart:developer' as devtools show log;
import 'package:cricai/constants/colors.dart';
import 'package:cricai/services/auth/auth_exceptions.dart';
import 'package:cricai/services/auth/auth_service.dart';
import 'package:cricai/utilities/snackbar/error_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cricai/constants/routes.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _email;

  @override
  void initState() {
    _email = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 80.0),
              child: FaIcon(
                FontAwesomeIcons.lock,
                size: 60,
                color: AppColors.darkTextColor,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: Text(
                "Forget Password",
                style: TextStyle(
                  color: AppColors.darkTextColor,
                  fontFamily: 'SF Pro Display',
                  fontSize: 30.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                  top: 10.0, left: 30.0, right: 30.0, bottom: 30.0),
              child: Text(
                "Provide your account's email and we will send you a password reset link!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.darkTextColor,
                  fontFamily: 'SF Pro Display',
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 20.0,
                left: 30.0,
                right: 30.0,
                bottom: 12.0,
              ),
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
                    borderSide:
                        const BorderSide(color: Color(0xFFD4D4D8), width: 1.0),
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
                left: 30.0,
                right: 30.0,
                bottom: 12.0,
              ),
              child: ElevatedButton(
                onPressed: () async {
                  final email = _email.text.trim();
                  try {
                    await AuthService.firebase().passwordReset(
                      email: email,
                    );
                    devtools.log('Reset Password Email Sent!');
                    showErrorSnackbar(
                      context,
                      'Reset Password Successfully!',
                    );
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (route) => false,
                    );
                  } on UserNotFoundAuthException {
                    devtools.log('User not found.');
                    showErrorSnackbar(
                      context,
                      'User Not Found',
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
                  'Reset Password',
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
          ],
        ),
      ),
    );
  }
}
