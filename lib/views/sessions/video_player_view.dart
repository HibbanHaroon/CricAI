import 'package:cricai/constants/colors.dart';
import 'package:cricai/utilities/generics/get_arguments.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerView extends StatefulWidget {
  const VideoPlayerView({super.key});

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  late FlickManager flickManager;
  @override
  void initState() {
    super.initState();
    // flickManager = FlickManager(
    //   videoPlayerController:
    //       VideoPlayerController.networkUrl(Uri.parse(widget.uri)),
    // );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  Future<String?> getUri(BuildContext context) async {
    final widgetVideo = context.getArgument<String>();
    return widgetVideo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Video Player',
          style: TextStyle(
            color: AppColors.darkTextColor,
            fontFamily: 'SF Pro Display',
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder(
            future: getUri(context),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    String videoUri = snapshot.data as String;
                    flickManager = FlickManager(
                      videoPlayerController:
                          VideoPlayerController.networkUrl(Uri.parse(videoUri)),
                    );
                    return FlickVideoPlayer(
                      flickManager: flickManager,
                    );
                  } else {
                    return const Text('No video found');
                  }
                default:
                  return const CircularProgressIndicator();
              }
            },
          ),
        ],
      ),
    );
  }
}
