import 'package:cricai/constants/colors.dart';
import 'package:cricai/constants/routes.dart';
import 'package:cricai/services/auth/auth_service.dart';
import 'package:cricai/services/cloud/firebase_cloud_storage.dart';
import 'package:cricai/views/home_view.dart';
import 'package:cricai/views/profile_view.dart';
import 'package:cricai/views/sessions/sessions_list_view.dart';
import 'package:cricai/views/players/players_list_view.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class PagesController extends StatefulWidget {
  const PagesController({super.key});

  @override
  State<PagesController> createState() => _PagesControllerState();
}

class _PagesControllerState extends State<PagesController> {
  late final FirebaseCloudStorage _usersService;
  final currentUser = AuthService.firebase().currentUser!;
  var _currentIndex;
  late List<Widget> _pages;
  late List<SalomonBottomBarItem> _bottomNavBarItems;

  @override
  void initState() {
    _usersService = FirebaseCloudStorage();
    _currentIndex = 0;
    _pages = [
      const HomeView(),
      const SessionsListView(),
      const ProfileView(),
    ];
    _bottomNavBarItems = [
      SalomonBottomBarItem(
        icon: const Icon(Icons.home),
        title: const Text("Home"),
        selectedColor: AppColors.primaryColor,
      ),
      SalomonBottomBarItem(
        icon: const Icon(Icons.format_list_bulleted_rounded),
        title: const Text("Sessions"),
        selectedColor: AppColors.primaryColor,
      ),
      SalomonBottomBarItem(
        icon: const Icon(Icons.person),
        title: const Text("Profile"),
        selectedColor: AppColors.primaryColor,
      ),
    ];

    getUserType().then((userType) => {
          setState(() {
            _pages = userType == 'coach'
                ? [
                    const HomeView(),
                    const SessionsListView(),
                    const PlayersListView(),
                    const ProfileView(),
                  ]
                : _pages;
            _bottomNavBarItems = userType == 'coach'
                ? [
                    SalomonBottomBarItem(
                      icon: const Icon(Icons.home),
                      title: const Text("Home"),
                      selectedColor: AppColors.primaryColor,
                    ),
                    SalomonBottomBarItem(
                      icon: const Icon(Icons.format_list_bulleted_rounded),
                      title: const Text("Sessions"),
                      selectedColor: AppColors.primaryColor,
                    ),
                    SalomonBottomBarItem(
                      icon: const Icon(Icons.people),
                      title: const Text("Players"),
                      selectedColor: AppColors.primaryColor,
                    ),
                    SalomonBottomBarItem(
                      icon: const Icon(Icons.person),
                      title: const Text("Profile"),
                      selectedColor: AppColors.primaryColor,
                    ),
                  ]
                : _bottomNavBarItems;
          })
        });
    super.initState();
  }

  Future<String> getUserType() async {
    final user = await _usersService.getUser(ownerUserId: currentUser.id);
    final userType = user.userType;
    return userType;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackgroundColor,
      body: _pages[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(
            createSessionRoute,
          );
        },
        tooltip: 'Add',
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.lightBackgroundColor,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 24.0),
        child: SalomonBottomBar(
          currentIndex: _currentIndex,
          onTap: (i) {
            setState(() => _currentIndex = i);
          },
          items: _bottomNavBarItems,
        ),
      ),
    );
  }
}
