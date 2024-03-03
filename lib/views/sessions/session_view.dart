import 'package:cricai/constants/colors.dart';
import 'package:cricai/services/auth/auth_service.dart';
import 'package:cricai/services/auth/auth_user.dart';
import 'package:cricai/services/cloud/firebase_cloud_storage.dart';
import 'package:cricai/services/cloud/sessions/cloud_sessions.dart';
import 'package:cricai/views/components/video_card.dart';
import 'package:cricai/utilities/generics/get_arguments.dart';
import 'package:flutter/material.dart';

class SessionView extends StatefulWidget {
  const SessionView({super.key});

  @override
  State<SessionView> createState() => _SessionViewState();
}

Future<CloudSession> getSession(BuildContext context) async {
  return context.getArgument<CloudSession>()!;
}

Future<List<dynamic>> getVideos(BuildContext context) async {
  CloudSession session = await getSession(context);

  return session.videos;
}

class _SessionViewState extends State<SessionView> {
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 12.0,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  FutureBuilder(
                    future: getSession(context),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.done:
                          final session = snapshot.data as CloudSession;
                          return Text(
                            session.name,
                            style: const TextStyle(
                              color: AppColors.darkTextColor,
                              fontFamily: 'SF Pro Display',
                              fontWeight: FontWeight.w600,
                              fontSize: 22,
                            ),
                          );
                        default:
                          return const Text('');
                      }
                    },
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Row(
                  children: [
                    Text(
                      'Videos',
                      style: TextStyle(
                        color: AppColors.darkTextColor,
                        fontFamily: 'SF Pro Display',
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              StreamBuilder(
                stream: getVideos(context),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        final sessions = snapshot.data as List<CloudSession>;

                        return SizedBox(
                          height: (screenHeight / 4) * 3,
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 0,
                              mainAxisExtent: 190,
                            ),
                            itemCount: sessions.videos.length,
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
                      } else {
                        //return const CircularProgressIndicator();
                        // print(snapshot.data);
                        return const Text('No Videos yet.');
                      }
                    default:
                      return const CircularProgressIndicator();
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: SizedBox(
                  height: 545.0,
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 0,
                        mainAxisExtent: 190,
                      ),
                      itemCount: 5,
                      itemBuilder: (BuildContext context, int index) {
                        return const VideoCard();
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 12.0),
                child: ElevatedButton(
                  onPressed: () async {},
                  style: TextButton.styleFrom(
                    fixedSize: const Size(398.0, 60.0),
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text(
                    'Generate Analysis',
                    style: TextStyle(
                      fontFamily: 'SF Pro Display',
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w700,
                      fontSize: 18.0,
                      color: AppColors.lightTextColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
