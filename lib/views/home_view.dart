import 'package:cricai/constants/colors.dart';
import 'package:cricai/services/auth/auth_service.dart';
import 'package:cricai/services/cloud/cloud_user.dart';
import 'package:cricai/services/cloud/firebase_cloud_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final FirebaseCloudStorage _usersService;
  final currentUser = AuthService.firebase().currentUser!;

  @override
  void initState() {
    _usersService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 60.0,
                left: 0,
                right: 0,
                bottom: 12,
              ),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Good Morning,',
                        style: TextStyle(
                          color: AppColors.darkTextColor,
                          fontFamily: 'Satoshi',
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FutureBuilder(
                        future:
                            _usersService.getUser(ownerUserId: currentUser.id),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.done:
                              final user = snapshot.data as CloudUser;
                              return Text(
                                user.name,
                                style: const TextStyle(
                                  color: AppColors.darkTextColor,
                                  fontFamily: 'SF Pro Display',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 30,
                                ),
                              );
                            default:
                              return const Text('');
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Sessions',
                        style: TextStyle(
                          color: AppColors.darkTextColor,
                          fontFamily: 'SF Pro Display',
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.lightPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Text(
                              'See All',
                              style: TextStyle(
                                color: AppColors.darkTextColor,
                                fontFamily: 'SF Pro Display',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            FaIcon(
                              FontAwesomeIcons.arrowRight,
                              size: 16,
                              color: AppColors.darkTextColor,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Card(
                    elevation: 3,
                    color: AppColors.lightBackgroundColor,
                    surfaceTintColor: Colors.transparent,
                    margin: const EdgeInsets.only(
                      top: 15.0,
                      bottom: 5.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(25),
                            topLeft: Radius.circular(25),
                          ),
                          child: Image.asset(
                            'assets/images/session.png',
                            height: 200,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                        const ListTile(
                          title: Text(
                            'Al-Amar Stadium Session',
                            style: TextStyle(
                              color: AppColors.darkTextColor,
                              fontFamily: 'SF Pro Display',
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text(
                            '18th December, 2023',
                            style: TextStyle(
                              color: AppColors.darkTextColor,
                              fontFamily: 'SF Pro Display',
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    elevation: 3,
                    color: AppColors.lightBackgroundColor,
                    surfaceTintColor: Colors.transparent,
                    margin: const EdgeInsets.only(
                      top: 15.0,
                      bottom: 5.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(25),
                            topLeft: Radius.circular(25),
                          ),
                          child: Image.asset(
                            'assets/images/session.png',
                            height: 200,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                        const ListTile(
                          title: Text(
                            'Al-Amar Stadium Session',
                            style: TextStyle(
                              color: AppColors.darkTextColor,
                              fontFamily: 'SF Pro Display',
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text(
                            '18th December, 2023',
                            style: TextStyle(
                              color: AppColors.darkTextColor,
                              fontFamily: 'SF Pro Display',
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    elevation: 3,
                    color: AppColors.lightBackgroundColor,
                    surfaceTintColor: Colors.transparent,
                    margin: const EdgeInsets.only(
                      top: 15.0,
                      bottom: 5.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(25),
                            topLeft: Radius.circular(25),
                          ),
                          child: Image.asset(
                            'assets/images/session.png',
                            height: 200,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                        const ListTile(
                          title: Text(
                            'Al-Amar Stadium Session',
                            style: TextStyle(
                              color: AppColors.darkTextColor,
                              fontFamily: 'SF Pro Display',
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text(
                            '18th December, 2023',
                            style: TextStyle(
                              color: AppColors.darkTextColor,
                              fontFamily: 'SF Pro Display',
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
