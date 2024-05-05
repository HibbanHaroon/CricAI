import 'package:cricai/constants/colors.dart';
import 'package:cricai/services/auth/auth_service.dart';
import 'package:cricai/services/auth/auth_user.dart';
import 'package:cricai/services/cloud/firebase_cloud_storage.dart';
import 'package:cricai/services/cloud/players/cloud_players.dart';
import 'package:cricai/services/cloud/users/cloud_user.dart';
import 'package:cricai/utilities/dialogs/delete_dialog.dart';
import 'package:cricai/views/components/list_tile.dart';
import 'package:cricai/views/players/add_player_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PlayersListView extends StatefulWidget {
  const PlayersListView({super.key});

  @override
  State<PlayersListView> createState() => _PlayersListViewState();
}

class _PlayersListViewState extends State<PlayersListView> {
  late final FirebaseCloudStorage _playersService;

  AuthUser get user => AuthService.firebase().currentUser!;
  String get userId => user.id;

  @override
  void initState() {
    _playersService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
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
            AddPlayerView(),
            const Padding(
              padding: EdgeInsets.only(
                top: 14.0,
              ),
              child: Row(
                children: [
                  Text(
                    'Players List',
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
            StreamBuilder(
              stream: _playersService.allPlayers(
                coachId: userId,
              ),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    if (snapshot.hasData) {
                      final players = snapshot.data as List<CloudPlayer>;

                      return SizedBox(
                        height: (screenHeight / 4) * 3,
                        child: ListView.builder(
                          itemCount: players.length,
                          // shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final player = players.elementAt(index);
                            return FutureBuilder(
                              future: _playersService.getUser(
                                  ownerUserId: player.playerId),
                              builder: (context, snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting:
                                  case ConnectionState.done:
                                    if (snapshot.hasData) {
                                      final playerUser =
                                          snapshot.data as CloudUser?;
                                      final playerName = playerUser!.name;
                                      return CustomListTile<CloudPlayer>(
                                        title: playerName,
                                        leadingIcon:
                                            Icons.format_list_bulleted_rounded,
                                        leadingIconColor:
                                            AppColors.primaryColor,
                                        onDeleteSession: (player) async {
                                          final shouldDelete =
                                              await showDeleteDialog(context);
                                          if (shouldDelete) {
                                            await _playersService.deletePlayer(
                                                documentId: player.documentId);
                                          }
                                        },
                                        item: player,
                                        onTap: (player) {
                                          /*Navigator.of(context).pushNamed(
                                        sessionRoute,
                                        arguments: session,
                                      );*/
                                        },
                                      );
                                    } else {
                                      return const Text('');
                                    }
                                  default:
                                    return const Text('Unknown');
                                }
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
                      return const Text('No Players yet.');
                    }
                  default:
                    return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
