import 'package:cricai/constants/colors.dart';
import 'package:cricai/views/components/list_tile.dart';
import 'package:flutter/material.dart';

class SessionsListView extends StatefulWidget {
  const SessionsListView({super.key});

  @override
  State<SessionsListView> createState() => _SessionsListViewState();
}

class _SessionsListViewState extends State<SessionsListView> {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 60.0,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Sessions List',
                        style: TextStyle(
                          color: AppColors.darkTextColor,
                          fontFamily: 'SF Pro Display',
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Column(
                      children: [
                        CustomListTile(
                          title: 'Al-Amar Stadium Session',
                          leadingIcon: Icons.format_list_bulleted_rounded,
                          leadingIconColor: AppColors.primaryColor,
                        ),
                        CustomListTile(
                          title: 'Al-Amar Stadium Session',
                          leadingIcon: Icons.format_list_bulleted_rounded,
                          leadingIconColor: AppColors.primaryColor,
                        ),
                        CustomListTile(
                          title: 'Al-Amar Stadium Session',
                          leadingIcon: Icons.format_list_bulleted_rounded,
                          leadingIconColor: AppColors.primaryColor,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
