import 'dart:io';
import 'package:cricai/constants/colors.dart';
import 'package:cricai/services/cloud/sessions/shot_video_ids.dart';
import 'package:cricai/utilities/calculate_score.dart';
import 'package:cricai/utilities/full_circle_painter.dart';
import 'package:cricai/utilities/generics/get_arguments.dart';
import 'package:cricai/views/components/deviation_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:cricai/views/components/video_player.dart';

class ResultView extends StatefulWidget {
  const ResultView({super.key});

  @override
  _ResultViewState createState() => _ResultViewState();
}

Future<dynamic> getVideoAndShotType(BuildContext context) async {
  return context.getArgument<Map<String, dynamic>>()!;
}

class _ResultViewState extends State<ResultView> {
  late dynamic video;
  late String shotType;
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
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    totalFrames = 0;
    currentFrame = 1;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
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

  void _scrollToIndex(int index) {
    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = 110; // 100 (item width) + 10 (margin)
    double scrollPosition =
        (index * itemWidth) - (screenWidth / 2) + (itemWidth / 2);

    if (scrollPosition < 0) {
      scrollPosition = 0;
    }

    if (scrollPosition > _scrollController.position.maxScrollExtent) {
      scrollPosition = _scrollController.position.maxScrollExtent;
    }

    _scrollController.animateTo(
      scrollPosition,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.feedback),
                    SizedBox(width: 5),
                    Text("Feedback"),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.analytics),
                    SizedBox(width: 5),
                    Text("Analysis"),
                  ],
                ),
              ),
            ],
          ),
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
        body: TabBarView(
          children: [
            // Firstly Feedback
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 14.0, left: 14.0, right: 14.0, bottom: 28.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  // Future Builder here
                  child: FutureBuilder(
                      future: getVideoAndShotType(context),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.done:
                            video = snapshot.data['video'] as dynamic;
                            shotType = snapshot.data['shotType'] as String;
                            Map<String, dynamic> feedback = video['feedback'];
                            return Column(
                              children: [
                                // Score
                                _buildScoreView(feedback),
                                _buildAreasOfDeviationView(feedback),
                                _buildOverallFeedbackView(feedback),
                                _buildExampleShotView(shotType),
                              ],
                            );
                          default:
                            return const CircularProgressIndicator();
                        }
                      }),
                ),
              ),
            ),
            // Then Analysis
            Column(
              children: [
                Expanded(
                  child: Center(
                    child: FutureBuilder(
                      future: getVideoAndShotType(context),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.done:
                            video = snapshot.data['video'] as dynamic;
                            shotType = snapshot.data['shotType'] as String;
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildAnalysisView(video['compared_angles']),
                                  _buildFrameView(localFrames),
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
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Feedback Widgets start from here.
  Widget _buildScoreView(Map<String, dynamic> feedback) {
    Map<String, int> scores = calculateScore(feedback);
    final score = scores['score'] ?? 0;
    final maxScore = scores['maxScore'] ?? 100;
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Score : ',
                      style: TextStyle(
                        color: AppColors.darkTextColor,
                        fontFamily: 'SF Pro Display',
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                      ),
                    ),
                    Text(
                      '$score / $maxScore',
                      style: const TextStyle(
                        color: AppColors.darkTextColor,
                        fontFamily: 'SF Pro Display',
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 10,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: score / maxScore,
                      backgroundColor: AppColors.lightPrimaryColor,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildAreasOfDeviationView(Map<String, dynamic> feedback) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
        left: 8.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Areas of Deviation',
            style: TextStyle(
              color: AppColors.darkTextColor,
              fontFamily: 'SF Pro Display',
              fontWeight: FontWeight.w600,
              fontSize: 22,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  feedback.length,
                  (index) {
                    String angleName = feedback.keys.elementAt(index);
                    int count = feedback[angleName]['count']!;
                    int total = feedback[angleName]['total']!;
                    int deviation = ((count / total) * 100).toInt();

                    return DeviationCard(
                      angleName: angleName,
                      deviation: deviation,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverallFeedbackView(Map<String, dynamic> feedback) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
        left: 8.0,
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Overall Feedback',
                style: TextStyle(
                  color: AppColors.darkTextColor,
                  fontFamily: 'SF Pro Display',
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Stack(
                        children: [
                          // First, draw the SemiCirclePainter in the background
                          // Right Shoulder
                          _buildCircleDeviation(
                            61,
                            205,
                            feedback["Right Shoulder"]["count"],
                            feedback["Right Shoulder"]["total"],
                            "right",
                          ),
                          // Left Shoulder
                          _buildCircleDeviation(
                            61,
                            108,
                            feedback["Left Shoulder"]["count"],
                            feedback["Left Shoulder"]["total"],
                            "left",
                          ),
                          // Right Elbow
                          _buildCircleDeviation(
                            95,
                            215,
                            feedback["Right Elbow"]["count"],
                            feedback["Right Elbow"]["total"],
                            "right",
                          ),
                          // Left Elbow
                          _buildCircleDeviation(
                            95,
                            99,
                            feedback["Left Elbow"]["count"],
                            feedback["Left Elbow"]["total"],
                            "left",
                          ),
                          // Right Wrist
                          _buildCircleDeviation(
                            126,
                            222,
                            feedback["Right Wrist"]["count"],
                            feedback["Right Wrist"]["total"],
                            "right",
                          ),
                          // Left Wrist
                          _buildCircleDeviation(
                            124,
                            91,
                            feedback["Left Wrist"]["count"],
                            feedback["Left Wrist"]["total"],
                            "left",
                          ),
                          // Right Hip
                          _buildCircleDeviation(
                            140,
                            183,
                            feedback["Right Hip"]["count"],
                            feedback["Right Hip"]["total"],
                            "rightDown",
                          ),
                          // Left Hip
                          _buildCircleDeviation(
                            140,
                            129,
                            feedback["Left Hip"]["count"],
                            feedback["Left Hip"]["total"],
                            "leftDown",
                          ),
                          // Right Knee
                          _buildCircleDeviation(
                            183,
                            185,
                            feedback["Right Knee"]["count"],
                            feedback["Right Knee"]["total"],
                            "right",
                          ),
                          // Left Knee
                          _buildCircleDeviation(
                            183,
                            128,
                            feedback["Left Knee"]["count"],
                            feedback["Left Knee"]["total"],
                            "left",
                          ),
                          // Right Ankle
                          _buildCircleDeviation(
                            228,
                            184,
                            feedback["Right Ankle"]["count"],
                            feedback["Right Ankle"]["total"],
                            "right",
                          ),
                          // Left Ankle
                          _buildCircleDeviation(
                            228,
                            128,
                            feedback["Left Ankle"]["count"],
                            feedback["Left Ankle"]["total"],
                            "left",
                          ),
                          // Then, place the body image on top
                          Positioned(
                            top: 0,
                            left: 0,
                            child: Container(
                              color: Colors
                                  .transparent, // Make background transparent
                              width: MediaQuery.of(context).size.width * 0.85,
                              height: MediaQuery.of(context).size.height * 0.3,
                              child: Image.asset(
                                'assets/images/body.png',
                                fit: BoxFit.contain, // Adjust the fit as needed
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCircleDeviation(
      double top, double left, int count, int total, String textSide) {
    int deviation = ((count / total) * 100).toInt();
    Color textColor = deviation > 70 && deviation <= 100
        ? AppColors.redColor
        : AppColors.darkTextColor;
    return Stack(
      children: [
        if (textSide == 'rightDown' || textSide == 'right')
          Positioned(
            top: textSide == 'rightDown' ? top + 21 : top,
            left: textSide == 'rightDown' ? left + 25 : left + 28,
            child: Text(
              '$deviation%',
              style: TextStyle(
                color: textColor,
                fontFamily: 'SF Pro Display',
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        Positioned(
          top: top,
          left: left,
          child: SizedBox(
            width: 20,
            height: 20,
            child: CustomPaint(
              painter: FullCirclePainter(),
            ),
          ),
        ),
        if (textSide == 'leftDown' || textSide == 'left')
          Positioned(
            top: textSide == 'leftDown' ? top + 21 : top,
            left: textSide == 'leftDown' ? left - 22 : left - 35,
            child: Text(
              '$deviation%',
              style: TextStyle(
                color: textColor,
                fontFamily: 'SF Pro Display',
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
      ],
    );
  }

  // Build function for Example Shot
  Widget _buildExampleShotView(String shotType) {
    String videoID = shotVideoIDs[shotType]!;
    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
        left: 8.0,
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Example Shot : ',
                    style: TextStyle(
                      color: AppColors.darkTextColor,
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                    ),
                  ),
                  Text(
                    shotType,
                    style: const TextStyle(
                      color: AppColors.darkTextColor,
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              VideoPlayer(
                id: videoID,
              ),
            ],
          )
        ],
      ),
    );
  }

  // Analysis Widgets start from here.
  Widget _buildAnalysisView(anglesArray) {
    if (anglesArray == null ||
        anglesArray[(currentFrame - 1).toString()] == null) {
      return const SizedBox();
    }
    return SizedBox(
      height: 100,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            anglesArray[(currentFrame - 1).toString()].length,
            (index) {
              if (anglesArray[(currentFrame - 1).toString()][index] != null) {
                return Container(
                  margin: const EdgeInsets.all(5),
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: anglesArray[(currentFrame - 1).toString()][index]
                                  ["is_deviation"] ==
                              'OK'
                          ? AppColors.lightPrimaryColor
                          : AppColors.redLightColor,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(angleNames[index]),
                      Text(anglesArray[(currentFrame - 1).toString()][index]
                              ["angle_difference"]
                          .toStringAsFixed(3)),
                    ],
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFrameView(List<File> frames) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2.7,
      child: PageView.builder(
        itemCount: frames.length,
        controller: PageController(initialPage: currentFrame - 1),
        onPageChanged: (index) {
          setState(() {
            currentFrame = index + 1;
          });
          _scrollToIndex(index);
        },
        itemBuilder: (context, index) {
          return Image.file(
            frames[index],
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }

  Widget _buildFrameScrollBar(List<File> localFrames) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToIndex(currentFrame - 1);
    });

    return SizedBox(
      height: 100,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: localFrames.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                currentFrame = index + 1;
              });
              _scrollToIndex(index);
            },
            child: Container(
              margin: const EdgeInsets.all(5),
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
                localFrames[
                    index], // Use the current index to display the thumbnail
                fit: BoxFit.cover,
              ),
            ),
          );
        },
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
