import 'package:cricai/constants/colors.dart';
import 'package:cricai/constants/routes.dart';
import 'package:cricai/services/auth/auth_service.dart';
import 'package:cricai/services/cloud/sessions/cloud_session.dart';
import 'package:cricai/services/cloud/users/cloud_user.dart';
import 'package:cricai/services/cloud/firebase_cloud_storage.dart';
import 'package:cricai/views/components/session_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeView extends StatefulWidget {
  final Function(int) changePageIndex;
  const HomeView({super.key, required this.changePageIndex});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final FirebaseCloudStorage _firebaseService;
  final currentUser = AuthService.firebase().currentUser!;
  String get userId => currentUser.id;

  @override
  void initState() {
    _firebaseService = FirebaseCloudStorage();
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
                        future: _firebaseService.getUser(
                            ownerUserId: currentUser.id),
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
                        onPressed: () {
                          // Changing the page index of the bottom nav bar to 1 to display the session list
                          widget.changePageIndex(1);
                        },
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
                  StreamBuilder(
                    stream:
                        _firebaseService.recentSessions(ownerUserId: userId),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.active:
                          if (snapshot.hasData) {
                            final sessions =
                                snapshot.data as List<CloudSession>;

                            return SizedBox(
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: sessions.length,
                                itemBuilder: (context, index) {
                                  final session = sessions.elementAt(index);
                                  return SessionCard(
                                    name: session.name,
                                    time: session.time,
                                    item: session,
                                    onTap: (session) {
                                      Navigator.of(context).pushNamed(
                                        sessionRoute,
                                        arguments: session,
                                      );
                                    },
                                  );
                                },
                              ),
                            );
                          } else {
                            //return const CircularProgressIndicator();
                            // print(snapshot.data);
                            return const Text('No Sessions yet.');
                          }
                        default:
                          return const CircularProgressIndicator();
                      }
                    },
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
