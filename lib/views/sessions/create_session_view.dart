import 'dart:io';

import 'package:cricai/constants/colors.dart';
import 'package:cricai/constants/routes.dart';
import 'package:cricai/services/auth/auth_service.dart';
import 'package:cricai/services/cloud/firebase_cloud_storage.dart';
import 'package:cricai/services/cloud/sessions/cloud_sessions.dart';
import 'package:cricai/utilities/get_video_file.dart';
import 'package:cricai/utilities/snackbar/success_snackbar.dart';
import 'package:cricai/views/components/list_tile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class CreateSessionView extends StatefulWidget {
  const CreateSessionView({super.key});

  @override
  State<CreateSessionView> createState() => _CreateSessionViewState();
}

class _CreateSessionViewState extends State<CreateSessionView> {
  late final FirebaseCloudStorage _sessionsService;
  late final TextEditingController _sessionName;
  late List<dynamic> _videoArray;
  late bool _isLoading;

  @override
  void initState() {
    _sessionsService = FirebaseCloudStorage();
    _sessionName = TextEditingController();
    _videoArray = [];
    _isLoading = false;
    super.initState();
  }

  @override
  void dispose() {
    _sessionName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            children: [
              const Row(
                children: [
                  Text(
                    'New Session',
                    style: TextStyle(
                      color: AppColors.darkTextColor,
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Text(
                          'Session Name',
                          style: TextStyle(
                            color: AppColors.darkTextColor,
                            fontFamily: 'SF Pro Display',
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10.0,
                      ),
                      child: TextField(
                        controller: _sessionName,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'Session Name',
                          hintStyle: const TextStyle(
                            color: AppColors.placeholderColor,
                          ),
                          contentPadding:
                              const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: AppColors.placeholderColor, width: 1.0),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        style: const TextStyle(
                          fontFamily: 'SF Pro Display',
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                          fontSize: 18.0,
                          height: 1.0,
                          color: AppColors.darkTextColor,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 15.0),
                      child: Row(
                        children: [
                          Text(
                            'Upload / Record Videos',
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
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        children: [
                          OutlinedButton(
                            onPressed: () async {
                              XFile? videoFile = await getVideoFile(
                                ImageSource.gallery,
                                context,
                              ) as XFile;

                              setState(() {
                                _videoArray.add({
                                  'name': videoFile.name,
                                  'raw_video_url': videoFile.path,
                                  'analysis_video_url': '',
                                  'compared_angles': ''
                                });
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: const Color(0xFFB6E0FF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: const BorderSide(
                                color: Color(0xFF3289F2),
                              ),
                              minimumSize: const Size(138, 138),
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/icons/upload_icon.png',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          OutlinedButton(
                            onPressed: () async {
                              XFile? videoFile = await getVideoFile(
                                ImageSource.camera,
                                context,
                              ) as XFile;

                              setState(() {
                                _videoArray.add({
                                  'name': videoFile.name,
                                  'raw_video_url': videoFile.path,
                                  'analysis_video_url': '',
                                  'compared_angles': ''
                                });
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: const Color(0xFFFBE7E3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: const BorderSide(
                                color: Color(0xFFFC573B),
                              ),
                              minimumSize: const Size(138, 138),
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/icons/record_icon.png',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
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
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: SizedBox(
                        height: 255.0,
                        child: Scrollbar(
                          thumbVisibility: true,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _videoArray.length,
                            itemBuilder: (context, index) {
                              final video =
                                  File(_videoArray[index]['raw_video_url']!);
                              return CustomListTile<File>(
                                title: _videoArray[index]['name']!,
                                leadingIcon: Icons.video_file_outlined,
                                leadingIconColor: const Color(0xFFFA5F3B),
                                item: video,
                                onTap: (video) {
                                  // New Page to display the video
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 12.0),
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;
                          });

                          final name = _sessionName.text.trim();

                          final currentUser =
                              AuthService.firebase().currentUser!;
                          final userId = currentUser.id;

                          // Creating a dummy session so that I can get the document id for that session.
                          var documentId = await _sessionsService.createSession(
                            ownerUserId: userId,
                            name: name,
                            videos: [],
                          );

                          // Passing the document id of the session, so the videos of the session are stored in the folder named with the document id.
                          for (var i = 0; i < _videoArray.length; i++) {
                            String downloadUrl =
                                await _sessionsService.uploadVideo(
                              _videoArray[i]['name']!,
                              _videoArray[i]['raw_video_url']!,
                              documentId,
                            );

                            _videoArray[i]['raw_video_url'] = downloadUrl;
                          }

                          // Updating the session with video urls stored in the firebase storage.
                          await _sessionsService.updateSession(
                            documentId: documentId,
                            name: name,
                            videos: _videoArray,
                          );

                          showSuccessSnackbar(
                            context,
                            'Session Created Successfully.',
                          );

                          CloudSession session =
                              await _sessionsService.getSession(
                                  ownerUserId: userId, documentId: documentId);

                          Navigator.of(context).pushReplacementNamed(
                            sessionRoute,
                            arguments: session,
                          );
                        },
                        style: TextButton.styleFrom(
                          fixedSize: const Size(398.0, 60.0),
                          backgroundColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        icon: _isLoading
                            ? Container(
                                width: 24,
                                height: 24,
                                padding: const EdgeInsets.all(2.0),
                                child: const CircularProgressIndicator(
                                  color: AppColors.lightTextColor,
                                  strokeWidth: 3,
                                ),
                              )
                            : const FaIcon(
                                FontAwesomeIcons.plus,
                                size: 24,
                                color: AppColors.lightTextColor,
                              ),
                        label: _isLoading
                            ? const Text(
                                'Creating...',
                                style: TextStyle(
                                  fontFamily: 'SF Pro Display',
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18.0,
                                  color: AppColors.lightTextColor,
                                ),
                              )
                            : const Text(
                                'Create Session',
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
            ],
          ),
        ),
      ),
    );
  }
}
