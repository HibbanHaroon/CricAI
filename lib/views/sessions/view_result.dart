import 'dart:io';
import 'package:cricai/constants/colors.dart';
import 'package:cricai/utilities/generics/get_arguments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ResultView extends StatefulWidget {
  const ResultView({super.key});

  @override
  _ResultViewState createState() => _ResultViewState();
}

Future<dynamic> getVideo(BuildContext context) async {
  return context.getArgument<dynamic>()!;
}

class _ResultViewState extends State<ResultView> {
  late dynamic video;
  late List<String> angleNames = [
    'Right Shoulder',
    'Left Shoulder',
    'Right Hip',
    'Left Hip',
    'Right Knee',
    'Left Knee',
    'Right Elbow',
    'Left Elbow',
    'Right Wrist',
    'Left Wrist',
    'Right Ankle',
    'Left Ankle'
  ];
  final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
  late int totalFrames;
  late int currentFrame;

  @override
  void initState() {
    totalFrames = 0;
    currentFrame = 1;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _deleteVideoAndFrames();
  }

  Future<void> _downloadVideo() async {
    final response = await http.get(Uri.parse(video['analysis_video_url']));
    String directory = (await getApplicationDocumentsDirectory()).path;
    File file = File('$directory/analysis_video.mp4');
    await file.writeAsBytes(response.bodyBytes);
    String filePath = file.path;
    totalFrames = await _extractFrames(filePath);
  }

  Future<int> _extractFrames(String videoPath) async {
    String directory = (await getApplicationDocumentsDirectory()).path;
    final outputDir = '$directory/output_frames';

    // Ensure the output directory exists
    Directory(outputDir).createSync(recursive: true);

    final arguments = '-i $videoPath $outputDir/frame_%04d.png';
    await _flutterFFmpeg.execute(arguments);

    List<FileSystemEntity> files = Directory(outputDir).listSync();

    setState(() {
      totalFrames = files.length;
    });

    return totalFrames;
  }

  Future<List<File>> _getLocalFrames() async {
    String directory = (await getApplicationDocumentsDirectory()).path;
    final outputDir = '$directory/output_frames';

    // Check if the frames directory doesn't exist
    if (!Directory(outputDir).existsSync()) {
      await _downloadVideo();
    }

    List<FileSystemEntity> files = Directory(outputDir).listSync();
    List<File> localFrames = files.map((e) => File(e.path)).toList();

    return localFrames;
  }

  Future<void> _deleteVideoAndFrames() async {
    String directory = (await getApplicationDocumentsDirectory()).path;
    final outputDir = '$directory/output_frames';
    final videoPath = '$directory/analysis_video.mp4';

    File videoFile = File(videoPath);
    if (await videoFile.exists()) {
      await videoFile.delete();
    }

    Directory(outputDir).delete(recursive: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'View Result',
          style: TextStyle(
            color: AppColors.darkTextColor,
            fontFamily: 'SF Pro Display',
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: FutureBuilder(
                  future: getVideo(context),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.done:
                        video = snapshot.data as dynamic;
                      default:
                        const CircularProgressIndicator();
                    }
                    return FutureBuilder<List<File>>(
                      future: _getLocalFrames(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Text('No frames available');
                        } else {
                          List<File> localFrames = snapshot.data!;
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildAnalysisView(video['compared_angles']),
                              _buildFrameView(localFrames[currentFrame - 1]),
                              Column(
                                children: [
                                  _buildFrameScrollBar(localFrames),
                                  _buildFrameCounter(),
                                ],
                              ),
                            ],
                          );
                        }
                      },
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisView(anglesArray) {
    if (anglesArray == null ||
        anglesArray[(currentFrame - 1).toString()] == null) {
      return const SizedBox();
    }
    return Container(
      height: 100,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            anglesArray[(currentFrame - 1).toString()].length,
            (index) {
              if (anglesArray[(currentFrame - 1).toString()][index] != null) {
                return Container(
                  margin: EdgeInsets.all(5),
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.lightPrimaryColor,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(angleNames[index]),
                      Text(anglesArray[(currentFrame - 1).toString()][index]
                          .toStringAsFixed(3)),
                    ],
                  ),
                );
              } else {
                return SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFrameView(File frame) {
    return Image.file(
      frame,
      fit: BoxFit.contain,
    );
  }

  Widget _buildFrameScrollBar(List<File> localFrames) {
    return Container(
      height: 100,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(localFrames.length, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  currentFrame = index + 1;
                });
              },
              child: Container(
                margin: EdgeInsets.all(5),
                width: 100,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: currentFrame == index + 1
                        ? AppColors.lightPrimaryColor
                        : AppColors.darkTextColor,
                    width: 2,
                  ),
                ),
                child: Image.file(
                  localFrames[currentFrame - 1],
                  fit: BoxFit.cover,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildFrameCounter() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.lightPrimaryColor,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '$currentFrame / $totalFrames',
            style: const TextStyle(
              color: AppColors.darkTextColor,
              fontFamily: 'SF Pro Display',
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
