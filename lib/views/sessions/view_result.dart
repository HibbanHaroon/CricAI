import 'dart:io';
import 'package:cricai/constants/colors.dart';
import 'package:cricai/utilities/full_circle_painter.dart';
import 'package:cricai/utilities/generics/get_arguments.dart';
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
                  child: Column(
                    children: [
                      // Score
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(
                                    left: 8.0,
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Score : ',
                                        style: TextStyle(
                                          color: AppColors.darkTextColor,
                                          fontFamily: 'SF Pro Display',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 22,
                                        ),
                                      ),
                                      Text(
                                        '58 / 100',
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
                                const SizedBox(height: 12),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  height: 10,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 8.0,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: const LinearProgressIndicator(
                                        value: 58 / 100,
                                        backgroundColor:
                                            AppColors.lightPrimaryColor,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Padding(
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
                                  child: Row(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.5,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                5,
                                        decoration: BoxDecoration(
                                          color: AppColors
                                              .redMediumBackgroundColor,
                                          border: Border.all(
                                            color: AppColors.redColor,
                                            width: 3,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: 75,
                                                    child: Text(
                                                      'Right Shoulder',
                                                      style: TextStyle(
                                                        color: AppColors
                                                            .darkTextColor,
                                                        fontFamily:
                                                            'SF Pro Display',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16,
                                                      ),
                                                      softWrap: true,
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Deviation',
                                                        style: TextStyle(
                                                          color: AppColors
                                                              .primaryColor,
                                                          fontFamily:
                                                              'SF Pro Display',
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                      Text(
                                                        '84%',
                                                        style: TextStyle(
                                                          color: AppColors
                                                              .redColor,
                                                          fontFamily:
                                                              'SF Pro Display',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 22,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.1,
                                                child: Image.asset(
                                                  'assets/images/shoulder_right.png',
                                                  fit: BoxFit
                                                      .contain, // Adjust the fit as needed
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 20.0,
                                    left: 8.0,
                                  ),
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Overall',
                                            style: TextStyle(
                                              color: AppColors.darkTextColor,
                                              fontFamily: 'SF Pro Display',
                                              fontWeight: FontWeight.w600,
                                              fontSize: 22,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 12.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.85,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.3,
                                                  child: Stack(
                                                    children: [
                                                      // First, draw the SemiCirclePainter in the background
                                                      Positioned(
                                                        top: 56,
                                                        left: 200,
                                                        child: SizedBox(
                                                          width: 30,
                                                          height: 30,
                                                          child: CustomPaint(
                                                            painter:
                                                                FullCirclePainter(),
                                                          ),
                                                        ),
                                                      ),
                                                      // Then, place the body image on top
                                                      Positioned(
                                                        top: 0,
                                                        left: 0,
                                                        child: Container(
                                                          color: Colors
                                                              .transparent, // Make background transparent
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.85,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.3,
                                                          child: Image.asset(
                                                            'assets/images/body.png',
                                                            fit: BoxFit
                                                                .contain, // Adjust the fit as needed
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
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(
                                    top: 20.0,
                                    left: 8.0,
                                  ),
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Example Shot',
                                            style: TextStyle(
                                              color: AppColors.darkTextColor,
                                              fontFamily: 'SF Pro Display',
                                              fontWeight: FontWeight.w600,
                                              fontSize: 22,
                                            ),
                                          ),
                                          SizedBox(height: 12),
                                          VideoPlayer(
                                            id: 'i5v2YgHuTSE',
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Then Analysis
            Column(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildAnalysisView(video['compared_angles']),
                                  _buildFrameView(
                                      localFrames[currentFrame - 1]),
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
                              ["angle_difference"]
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
