import 'package:cricai/constants/colors.dart';
import 'package:cricai/constants/routes.dart';
import 'package:cricai/services/auth/auth_service.dart';
import 'package:cricai/services/auth/auth_user.dart';
import 'package:cricai/services/cloud/firebase_cloud_storage.dart';
import 'package:cricai/services/cloud/sessions/cloud_sessions.dart';
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
                          // shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final session = sessions.elementAt(index);
                            return CustomListTile<CloudSession>(
                              title: session.name,
                              leadingIcon: Icons.format_list_bulleted_rounded,
                              leadingIconColor: AppColors.primaryColor,
                              // onDeleteSession: (session) async {
                              //   await _sessionsService.deleteSession(
                              //     session.documentId);
                              //   );
                              // },
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

                      // return NotesListView(
                      //   notes: allNotes,
                      //   onDeleteNote: (note) async {
                      //     await _notesService.deleteNote(
                      //         documentId: note.documentId);
                      //   },
                      //   onTap: (note) {
                      //     Navigator.of(context).pushNamed(
                      //       createOrUpdateNoteRoute,
                      //       arguments: note,
                      //     );
                      //   },
                      // );
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
