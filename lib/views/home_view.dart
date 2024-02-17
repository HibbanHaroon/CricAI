import 'package:cricai/constants/colors.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.lightBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
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
          ],
        ),
      ),
    );
  }
}
