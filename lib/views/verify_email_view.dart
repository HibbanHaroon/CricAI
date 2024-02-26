import 'dart:async';
import 'dart:developer' as devtools show log;
import 'package:cricai/constants/colors.dart';
import 'package:cricai/services/auth/auth_service.dart';
import 'package:cricai/utilities/snackbar/error_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cricai/constants/routes.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  // ignore: unused_field
  late Timer _timer;

  @override
  void initState() {
    setTimerForAutoRedirect();
    super.initState();
  }

  void setTimerForAutoRedirect() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      AuthService.firebase().reloadUserState();
      final user = AuthService.firebase().currentUser;
      if (user?.isEmailVerified ?? false) {
        //user's email is verified.
        Navigator.of(context).pushNamedAndRemoveUntil(
          homeRoute,
          (route) => false,
        );
        timer.cancel();
      }
    });
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
                FontAwesomeIcons.solidEnvelopeOpen,
                size: 60,
                color: AppColors.darkTextColor,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 30.0, bottom: 10.0),
              child: Text(
                "Verify your email address",
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
                top: 10.0,
                left: 50.0,
                right: 50.0,
                bottom: 10.0,
              ),
              child: Text(
                "We have just send email verification link on your email. Please check email and click on that link to verify your email address.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.darkTextColor,
                  fontFamily: 'SF Pro Display',
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                top: 10.0,
                left: 50.0,
                right: 50.0,
                bottom: 20.0,
              ),
              child: Text(
                "If not auto redirected after verification, click on the Continue button.",
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
              child: ElevatedButton(
                onPressed: () {
                  AuthService.firebase().reloadUserState();
                  final user = AuthService.firebase().currentUser;
                  if (user?.isEmailVerified ?? false) {
                    //user's email is verified.
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      pagesControllerRoute,
                      (route) => false,
                    );
                  } else {
                    devtools.log('Email not verified.');
                    showErrorSnackbar(
                      context,
                      'Email not verified.',
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
                  'Continue',
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
              padding: const EdgeInsets.only(
                top: 40.0,
              ),
              child: TextButton(
                onPressed: () async {
                  await AuthService.firebase().sendEmailVerification();
                },
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  // padding: const EdgeInsets.symmetric(vertical: 12.0),
                  // foregroundColor: const Color(0xFFFFFFFF),
                ),
                child: const Text.rich(
                  TextSpan(
                    text: "Resend E-Mail Link",
                    style: TextStyle(
                        color: AppColors.darkTextColor,
                        fontWeight: FontWeight.bold),
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
