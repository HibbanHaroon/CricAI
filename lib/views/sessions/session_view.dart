import 'package:cricai/constants/colors.dart';
import 'package:cricai/services/cloud/sessions/cloud_sessions.dart';
import 'package:cricai/views/components/video_card.dart';
import 'package:cricai/utilities/generics/get_arguments.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  late bool _isGenerationDisabled;
  late List<dynamic> videos;
  late CloudSession session;

  @override
  void initState() {
    _isGenerationDisabled = false;
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
    setState(() {
      _isGenerationDisabled = !isAnalysisVideoUrlEmpty;
    });
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
                            // shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final video = videos.elementAt(index);
                              return VideoCard();
                              // return VideoCard(
                              //   title: session.name,
                              //   leadingIcon: Icons.format_list_bulleted_rounded,
                              //   leadingIconColor: AppColors.primaryColor,
                              //   // onDeleteSession: (session) async {
                              //   //   await _sessionsService.deleteSession(
                              //   //     session.documentId);
                              //   //   );
                              //   // },
                              //   item: session,
                              //   onTap: (session) {
                              //     Navigator.of(context).pushNamed(
                              //       sessionRoute,
                              //       arguments: session,
                              //     );
                              //   },
                              // );
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
                child: ElevatedButton(
                  onPressed: _isGenerationDisabled
                      ? null
                      : () async {
                          if (_isGenerationDisabled == false) {
                            // var sessionId = session.documentId;
                            // var videoName = videos[0]['name'];
                            // var raw_video_url = videos[0]['raw_video_url'];
                            // raw_video_url = Uri.parse(raw_video_url);

                            var apiUrl =
                                'http://10.1.111.123:8000/?url=https%3A%2F%2Ffirebasestorage.googleapis.com%2Fv0%2Fb%2Fcricai-001.appspot.com%2Fo%2Fideal_videos%252Fideal.mp4%3Falt%3Dmedia%26token%3De19e9ea3-cc1d-4db5-a7b3-8147ec25680e&sessionId=4PVCA5wMnxtkpqSt3cDS&videoName=VID-20240302-WA0040.mp4';

                            var response = await http.get(Uri.parse(apiUrl));

                            print('Response: ${response.body}');
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
