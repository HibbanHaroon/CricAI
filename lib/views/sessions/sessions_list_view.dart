import 'package:cricai/constants/colors.dart';
import 'package:flutter/material.dart';

class SessionsListView extends StatefulWidget {
  const SessionsListView({super.key});

  @override
  State<SessionsListView> createState() => _SessionsListViewState();
}

class _SessionsListViewState extends State<SessionsListView> {
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
              ),
              child: Column(
                children: [
                  const Row(
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
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 5.0,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.greyColor,
                                width: 1.0, // Border width
                              ),
                              borderRadius:
                                  BorderRadius.circular(12.0), // Border radius
                            ),
                            child: ListTile(
                              titleAlignment: ListTileTitleAlignment.center,
                              dense: false,
                              leading: const Icon(
                                Icons.format_list_bulleted_rounded,
                                color: AppColors.primaryColor,
                              ),
                              title: const Text(
                                "Al-Amar Stadium Session",
                                style: TextStyle(
                                  color: AppColors.darkTextColor,
                                  fontFamily: 'SF Pro Display',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.more_vert,
                                  color: AppColors.placeholderColor,
                                ),
                                onPressed: () {},
                                splashRadius: 24,
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 5.0,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.greyColor,
                                width: 1.0, // Border width
                              ),
                              borderRadius:
                                  BorderRadius.circular(12.0), // Border radius
                            ),
                            child: ListTile(
                              titleAlignment: ListTileTitleAlignment.center,
                              dense: false,
                              leading: const Icon(
                                Icons.format_list_bulleted_rounded,
                                color: AppColors.primaryColor,
                              ),
                              title: const Text(
                                "Al-Amar Stadium Session",
                                style: TextStyle(
                                  color: AppColors.darkTextColor,
                                  fontFamily: 'SF Pro Display',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.more_vert,
                                  color: AppColors.placeholderColor,
                                ),
                                onPressed: () {},
                                splashRadius: 24,
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        )
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
