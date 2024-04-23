import 'package:cricai/constants/colors.dart';
import 'package:cricai/constants/routes.dart';
import 'package:cricai/services/auth/auth_service.dart';
import 'package:cricai/services/auth/auth_user.dart';
import 'package:cricai/services/cloud/firebase_cloud_storage.dart';
import 'package:cricai/services/cloud/users/user_types.dart';
import 'package:cricai/utilities/dialogs/logout_dialog.dart';
import 'package:cricai/utilities/generics/capitalize.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late final FirebaseCloudStorage _usersService;
  late final TextEditingController _name;
  late final TextEditingController _email;
  late String _userType;

  AuthUser get user => AuthService.firebase().currentUser!;
  String get userId => user.id;

  @override
  void initState() {
    _usersService = FirebaseCloudStorage();
    _name = TextEditingController();
    _email = TextEditingController();
    _userType = userTypes.first;
    _fetchUserData();
    super.initState();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _fetchUserData() async {
    final user = await _usersService.getUser(ownerUserId: userId);
    setState(() {
      _name.text = user.name;
      _email.text = user.email;
      _userType = user.userType.capitalize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 84.0,
          right: 24.0,
          left: 24.0,
          bottom: 24.0,
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(
                top: 14.0,
              ),
              child: Row(
                children: [
                  Text(
                    'Profile',
                    style: TextStyle(
                      color: AppColors.darkTextColor,
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primaryColor,
                    child: Text(
                      _name.text.isNotEmpty ? _name.text[0].toUpperCase() : '',
                      style: const TextStyle(
                        color: AppColors.lightTextColor,
                        fontSize: 36,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                top: 10.0,
              ),
              child: Row(
                children: [
                  Text(
                    'Name',
                    style: TextStyle(
                      color: AppColors.darkTextColor,
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
              ),
              child: TextField(
                controller: _name,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Name',
                  hintStyle: const TextStyle(
                    color: AppColors.placeholderColor,
                  ),
                  contentPadding:
                      const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: AppColors.placeholderColor, width: 1.0),
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
            const Padding(
              padding: EdgeInsets.only(
                top: 14.0,
              ),
              child: Row(
                children: [
                  Text(
                    'Email',
                    style: TextStyle(
                      color: AppColors.darkTextColor,
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
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
                    borderSide: const BorderSide(
                        color: AppColors.placeholderColor, width: 1.0),
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
            const Padding(
              padding: EdgeInsets.only(
                top: 14.0,
              ),
              child: Row(
                children: [
                  Text(
                    'User Type',
                    style: TextStyle(
                      color: AppColors.darkTextColor,
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
              ),
              child: Row(
                children: <Widget>[
                  DropdownMenu<String>(
                    width: screenWidth * 0.87,
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
              padding: const EdgeInsets.only(top: 44.0),
              child: ElevatedButton.icon(
                onPressed: () async {
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    await AuthService.firebase().logOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (route) => false,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(340.0, 60.0),
                  backgroundColor: Colors.red[100],
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
                      FontAwesomeIcons.arrowRightFromBracket,
                      size: 20,
                      color: Colors.red,
                    ),
                  ),
                ),
                label: const Padding(
                  padding: EdgeInsets.only(left: 45, right: 70),
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      fontFamily: 'Satoshi',
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.red,
                    ),
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
