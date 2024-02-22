import 'package:cricai/constants/colors.dart';
import 'package:cricai/services/auth/auth_service.dart';
import 'package:cricai/services/cloud/cloud_user.dart';
import 'package:cricai/services/cloud/firebase_cloud_storage.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      backgroundColor: AppColors.lightBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(50),
              child: Center(
                child: Text(
                  'Good Morning',
                  style: TextStyle(
                    color: AppColors.darkTextColor,
                  ),
                ),
              ),
            ),
            FutureBuilder(
              future: _usersService.getUser(ownerUserId: currentUser.id),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    final user = snapshot.data as CloudUser;
                    return Text(user.name);
                  default:
                    return const Text('');
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
