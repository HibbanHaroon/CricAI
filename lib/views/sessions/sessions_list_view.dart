import 'package:cricai/constants/colors.dart';
import 'package:cricai/constants/routes.dart';
import 'package:cricai/enums/menu_action.dart';
import 'package:cricai/services/auth/auth_service.dart';
import 'package:cricai/services/auth/auth_user.dart';
import 'package:cricai/services/cloud/firebase_cloud_storage.dart';
import 'package:cricai/services/cloud/sessions/cloud_session.dart';
import 'package:cricai/utilities/dialogs/delete_dialog.dart';
import 'package:cricai/views/components/list_tile.dart';
import 'package:flutter/material.dart';

class SessionsListView extends StatefulWidget {
  const SessionsListView({super.key});

  @override
  State<SessionsListView> createState() => _SessionsListViewState();
}

class _SessionsListViewState extends State<SessionsListView> {
  late final FirebaseCloudStorage _sessionsService;

  AuthUser get user => AuthService.firebase().currentUser!;
  String get userId => user.id;

  @override
  void initState() {
    _sessionsService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
            top: 84.0, right: 24.0, left: 24.0, bottom: 24.0),
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
            StreamBuilder(
              stream: _sessionsService.allSessions(
                ownerUserId: userId,
              ),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    if (snapshot.hasData) {
                      final sessions = snapshot.data as List<CloudSession>;

                      return SizedBox(
                        height: (screenHeight / 4) * 3,
                        child: ListView.builder(
                          itemCount: sessions.length,
                          itemBuilder: (context, index) {
                            final session = sessions.elementAt(index);
                            return CustomListTile<CloudSession>(
                              title: session.name,
                              leadingIcon: Icons.format_list_bulleted_rounded,
                              leadingIconColor: AppColors.primaryColor,
                              onDelete: (session) async {
                                final shouldDelete =
                                    await showDeleteDialog(context);
                                if (shouldDelete) {
                                  await _sessionsService.deleteSession(
                                      documentId: session.documentId);
                                }
                              },
                              onEdit: (session) {
                                Navigator.of(context).pushNamed(
                                  createUpdateSessionRoute,
                                  arguments: session,
                                );
                              },
                              actions: const [
                                MenuAction.edit,
                                MenuAction.delete
                              ],
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
            )
          ],
        ),
      ),
    );
  }
}
