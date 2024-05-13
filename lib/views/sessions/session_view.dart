import 'dart:convert';

import 'package:cricai/constants/colors.dart';
import 'package:cricai/constants/routes.dart';
import 'package:cricai/services/cloud/firebase_cloud_storage.dart';
import 'package:cricai/services/cloud/sessions/cloud_session.dart';
import 'package:cricai/views/components/video_card.dart';
import 'package:cricai/utilities/generics/get_arguments.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SessionView extends StatefulWidget {
  const SessionView({super.key});

  @override
  State<SessionView> createState() => _SessionViewState();
}

// Using ValueNotifier, so that when the videos are retrieved using the getVideos function,
// before drawing the Elevated button, isGenerationNeeded function will be called and
// the state of the button will be decided
final sessionVideos = ValueNotifier<List<dynamic>>([]);

Future<CloudSession> getSession(BuildContext context) async {
  return context.getArgument<CloudSession>()!;
}

Future<List<dynamic>> getVideos(BuildContext context) async {
  CloudSession session = await getSession(context);
  sessionVideos.value = session.videos;
  return session.videos;
}

class _SessionViewState extends State<SessionView> {
  late final FirebaseCloudStorage _sessionsService;
  late bool _isGenerationDisabled;
  late List<dynamic> videos;
  late CloudSession session;

  @override
  void initState() {
    _sessionsService = FirebaseCloudStorage();
    _isGenerationDisabled = true;

    videos = [];

    super.initState();
  }

  // if any analysis video url is empty then that means analysis will be generated for the videos having empty analysis video url
  // This function is helpful in determining the state of the isGenerationDisabled
  void isGenerationNeeded(List<dynamic> videos) {
    bool isAnalysisVideoUrlEmpty = false;
    for (var i = 0; i < videos.length; i++) {
      var video = videos.elementAt(i);
      if (video['analysis_video_url'] == '') {
        isAnalysisVideoUrlEmpty = true;
      }
    }

    // isAnalysisVideoUrlEmpty = false, it means that all videos have analysis generated... hence isGenerationDisabled should be true
    if (isAnalysisVideoUrlEmpty == false) {
      _isGenerationDisabled = true;
    } else {
      _isGenerationDisabled = false;
    }
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
                          session = snapshot.data as CloudSession;
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
              FutureBuilder(
                future: getVideos(context),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.done:
                      if (snapshot.hasData) {
                        videos = snapshot.data as List<dynamic>;

                        return SizedBox(
                          height: (screenHeight / 6) * 4,
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 0,
                              mainAxisExtent: 190,
                            ),
                            itemCount: videos.length,
                            itemBuilder: (context, index) {
                              final video = videos.elementAt(index);
                              return VideoCard(
                                name: video['name'],
                                // onDeleteSession: (session) async {
                                //   await _sessionsService.deleteSession(
                                //     session.documentId);
                                //   );
                                // },
                                item: video,
                                onTap: (video) {
                                  Navigator.of(context).pushNamed(
                                    viewResultRoute,
                                    arguments: video,
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
                padding: const EdgeInsets.only(top: 20.0, bottom: 12.0),
                child: ValueListenableBuilder<List<dynamic>>(
                    valueListenable: sessionVideos,
                    builder: (context, videos, child) {
                      isGenerationNeeded(videos);
                      return ElevatedButton(
                        onPressed: _isGenerationDisabled
                            ? null
                            : () async {
                                if (_isGenerationDisabled == false) {
                                  for (var i = 0; i < videos.length; i++) {
                                    var sessionId = session.documentId;
                                    var shotType = session.shotType;
                                    var videoName = videos[i]['name'];
                                    var rawVideoUrl =
                                        videos[i]['raw_video_url'];

                                    var apiUrl =
                                        'http://192.168.18.232:8000/?url=$rawVideoUrl&sessionId=$sessionId&videoName=$videoName&shotType=$shotType';
                                    apiUrl = Uri.encodeFull(apiUrl);

                                    var response =
                                        await http.get(Uri.parse(apiUrl));
                                    // print('Response: ${response.body}');

                                    var jsonResponse =
                                        jsonDecode(response.body);

                                    var comparedAngles =
                                        jsonResponse['compared_angles'];
                                    var analysisVideoUrl =
                                        jsonResponse['analysis_video_url'];

                                    print(comparedAngles);
                                    print(analysisVideoUrl);

                                    videos[i]['compared_angles'] =
                                        comparedAngles;
                                    videos[i]['analysis_video_url'] =
                                        analysisVideoUrl;
                                  }

                                  // Updating the session with video urls stored in the firebase storage.
                                  await _sessionsService.updateSession(
                                    documentId: session.documentId,
                                    name: session.name,
                                    shotType: session.shotType,
                                    videos: videos,
                                  );
                                }
                              },
                        style: TextButton.styleFrom(
                          fixedSize: const Size(398.0, 60.0),
                          backgroundColor: _isGenerationDisabled
                              ? AppColors.greyColor
                              : AppColors.primaryColor,
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
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
