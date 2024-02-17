import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cricai/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cricai/constants/routes.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerificationCodeView extends StatefulWidget {
  const VerificationCodeView({super.key});

  @override
  State<VerificationCodeView> createState() => _VerificationCodeViewState();
}

class _VerificationCodeViewState extends State<VerificationCodeView> {
  late final TextEditingController textEditingController;

  bool hasError = false;
  String currentText = "";
  String code = "123456";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
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
                FontAwesomeIcons.key,
                size: 60,
                color: AppColors.darkTextColor,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: Text(
                "Verification",
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
                  top: 10.0, left: 50.0, right: 50.0, bottom: 30.0),
              child: Text(
                "Enter the one time password that was sent to your email.",
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
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 30,
              ),
              child: PinCodeTextField(
                appContext: context,
                pastedTextStyle: const TextStyle(
                  color: AppColors.darkTextColor,
                  fontWeight: FontWeight.bold,
                ),
                length: 6,
                obscureText: false,
                blinkWhenObscuring: true,
                animationType: AnimationType.fade,
                validator: (v) {
                  if (v!.length < 6) {
                    return "Incomplete Code";
                  } else {
                    return null;
                  }
                },
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  activeColor: AppColors.primaryColor,
                  selectedColor: AppColors.primaryColor,
                  inactiveColor: AppColors.primaryColor,
                  activeFillColor: Colors.white,
                  selectedFillColor: Colors.white,
                  inactiveFillColor: Colors.white,
                ),
                cursorColor: AppColors.darkTextColor,
                animationDuration: const Duration(milliseconds: 300),
                enableActiveFill: true,
                controller: textEditingController,
                keyboardType: TextInputType.number,
                boxShadows: const [
                  BoxShadow(
                    offset: Offset(0, 1),
                    color: Colors.black12,
                    blurRadius: 10,
                  )
                ],
                onChanged: (value) {
                  setState(() {
                    currentText = value;
                  });
                },
                beforeTextPaste: (text) {
                  //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                  return true;
                },
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
                  if (currentText.length != 6 || currentText != code) {
                    setState(() => hasError = true);

                    final snackBar = SnackBar(
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      content: AwesomeSnackbarContent(
                        title: 'Oh Snap!',
                        message:
                            'The verification code you entered doesn\'t match the code we sent you!',

                        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                        contentType: ContentType.failure,
                      ),
                    );

                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(snackBar);
                  } else {
                    setState(
                      () {
                        hasError = false;

                        Navigator.of(context).pushNamed(
                          newPasswordRoute,
                        );
                      },
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
                  'Verify Code',
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
