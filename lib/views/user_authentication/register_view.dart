import 'dart:developer' as devtools show log;
import 'package:cricai/constants/colors.dart';
import 'package:cricai/services/auth/auth_exceptions.dart';
import 'package:cricai/services/auth/auth_service.dart';
import 'package:cricai/services/cloud/firebase_cloud_storage.dart';
import 'package:cricai/utilities/snackbar/error_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:cricai/constants/routes.dart';
import 'package:cricai/services/cloud/users/user_types.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final FirebaseCloudStorage _usersService;
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _confirmPassword;
  late String _userType;

  @override
  void initState() {
    _usersService = FirebaseCloudStorage();
    _name = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
    _confirmPassword = TextEditingController();
    _userType = userTypes.first;
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
                          top: 14.0, left: 7.0, right: 7.0, bottom: 0.0),
                      child: Row(
                        children: <Widget>[
                          DropdownMenu<String>(
                            width: screenWidth - ((9 * screenWidth) / 100),
                            initialSelection: _userType,
                            label: const Text('User Type'),
                            onSelected: (String? value) {
                              setState(() {
                                _userType = value!;
                              });
                            },
                            dropdownMenuEntries: userTypes
                                .map<DropdownMenuEntry<String>>((String value) {
                              return DropdownMenuEntry<String>(
                                value: value,
                                label: value,
                                style: MenuItemButton.styleFrom(
                                  textStyle: const TextStyle(
                                    fontFamily: 'SF Pro Display',
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18.0,
                                    height: 1.0,
                                    color: AppColors.darkTextColor,
                                  ),
                                  foregroundColor: AppColors.primaryColor,
                                ),
                              );
                            }).toList(),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 8.0, right: 8.0, bottom: 12.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          final name = _name.text.trim();
                          final email = _email.text.trim();
                          final password = _password.text;

                          try {
                            await AuthService.firebase().createUser(
                              email: email,
                              password: password,
                            );
                            //sending the email for the user beforehand so the user only has to verify it
                            await AuthService.firebase()
                                .sendEmailVerification();

                            final currentUser =
                                AuthService.firebase().currentUser!;
                            final userId = currentUser.id;

                            await _usersService.createUser(
                              ownerUserId: userId,
                              name: name,
                              userType: _userType.toLowerCase(),
                            );

                            Navigator.of(context).pushNamed(verifyEmailRoute);
                          } on EmailAlreadyInUseAuthException {
                            devtools.log('Email already in use');
                            showErrorSnackbar(
                              context,
                              'Email already in use',
                            );
                          } on WeakPasswordAuthException {
                            devtools.log('Weak Password');
                            showErrorSnackbar(
                              context,
                              'Weak Password',
                            );
                          } on InvalidEmailAuthException {
                            showErrorSnackbar(
                              context,
                              'Invalid email entered',
                            );
                          } on GenericAuthException {
                            devtools.log('Failed to Register.');
                            showErrorSnackbar(
                              context,
                              'Failed to Register.',
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
