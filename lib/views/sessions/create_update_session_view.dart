import 'dart:io';

import 'package:cricai/constants/colors.dart';
import 'package:cricai/constants/routes.dart';
import 'package:cricai/enums/menu_action.dart';
import 'package:cricai/services/auth/auth_service.dart';
import 'package:cricai/services/cloud/firebase_cloud_storage.dart';
import 'package:cricai/services/cloud/sessions/cloud_session.dart';
import 'package:cricai/services/cloud/sessions/shot_types.dart';
import 'package:cricai/utilities/generics/get_arguments.dart';
import 'package:cricai/utilities/get_video_file.dart';
import 'package:cricai/utilities/snackbar/success_snackbar.dart';
import 'package:cricai/views/components/dropdown_menu.dart';
import 'package:cricai/views/components/list_tile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class CreateUpdateSessionView extends StatefulWidget {
  const CreateUpdateSessionView({super.key});

  @override
  State<CreateUpdateSessionView> createState() =>
      _CreateUpdateSessionViewState();
}

class _CreateUpdateSessionViewState extends State<CreateUpdateSessionView> {
  CloudSession? _session;
  late final FirebaseCloudStorage _sessionsService;
  late final TextEditingController _sessionName;
  late List<dynamic> _videoArray;
  late bool _isLoading;
  late String _shotType;

  @override
  void initState() {
    _session = null;
    _sessionsService = FirebaseCloudStorage();
    _sessionName = TextEditingController();
    _videoArray = [];
    _shotType = shotTypes.first;
    _isLoading = false;
    super.initState();
  }

  @override
  void dispose() {
    _sessionName.dispose();
    super.dispose();
  }

  Future<void> getExistingSession(BuildContext context) async {
    final widgetSession = context.getArgument<CloudSession>();
    //user can come to this method either by clicking on the session or simply clicking on the plus icon
    //in the latter case the widgetSession will be null.

    //If the session exists, and _session var is null so that we are fetching the session for the first time.
    if (widgetSession != null && _session == null) {
      _session = widgetSession;
      _sessionName.text = widgetSession.name;
      _videoArray = widgetSession.videos;
      _shotType = widgetSession.shotType;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    getExistingSession(context);
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
              Row(
                children: [
                  Text(
                    _session == null ? 'New Session' : 'Update Session',
                    style: const TextStyle(
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
                    const SizedBox(
                      height: 10.0,
                    ),
                    const Row(
                      children: [
                        Text(
                          'Shot Type',
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
                        top: 14.0,
                      ),
                      child: CustomDropdownMenu(
                        width: screenWidth - ((9 * screenWidth) / 70),
                        initialSelection: _shotType,
                        label: "Shot Type",
                        onSelected: (String? value) {
                          setState(() {
                            _shotType = value!;
                          });
                        },
                        types: shotTypes,
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
                        height: 130.0,
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
                                onDelete: (video) {
                                  setState(() {
                                    for (int i = 0;
                                        i < _videoArray.length;
                                        i++) {
                                      if (_videoArray[i]['raw_video_url'] ==
                                          video.path) {
                                        _videoArray.removeAt(i);
                                        break;
                                      }
                                    }
                                  });
                                },
                                onEdit: null,
                                actions: const [MenuAction.delete],
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

                          print(name);

                          final currentUser =
                              AuthService.firebase().currentUser!;
                          final userId = currentUser.id;

                          if (_session == null) {
                            // Creating a dummy session so that I can get the document id for that session.
                            var documentId =
                                await _sessionsService.createSession(
                              ownerUserId: userId,
                              name: name,
                              shotType: _shotType,
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
                              shotType: _shotType,
                              videos: _videoArray,
                            );

                            showSuccessSnackbar(
                              context,
                              'Session Created Successfully.',
                            );
                            CloudSession session =
                                await _sessionsService.getSession(
                                    ownerUserId: userId,
                                    documentId: documentId);

                            Navigator.of(context).pushReplacementNamed(
                              sessionRoute,
                              arguments: session,
                            );
                          } else {
                            // There are still some videos that are not uploaded to the firebase storage.
                            for (var i = 0; i < _videoArray.length; i++) {
                              // Upload the videos which are new to the firebase storage.
                              if (!_videoArray[i]['raw_video_url'].contains(
                                  'https://firebasestorage.googleapis.com/')) {
                                String downloadUrl =
                                    await _sessionsService.uploadVideo(
                                  _videoArray[i]['name']!,
                                  _videoArray[i]['raw_video_url']!,
                                  _session!.documentId,
                                );

                                _videoArray[i]['raw_video_url'] = downloadUrl;
                              }
                            }

                            await _sessionsService.updateSession(
                              documentId: _session!.documentId,
                              name: name,
                              shotType: _shotType,
                              videos: _videoArray,
                            );

                            showSuccessSnackbar(
                              context,
                              'Session Updated Successfully.',
                            );

                            CloudSession session =
                                await _sessionsService.getSession(
                                    ownerUserId: userId,
                                    documentId: _session!.documentId);

                            Navigator.of(context).pushReplacementNamed(
                              sessionRoute,
                              arguments: session,
                            );
                          }
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
                            : _session == null
                                ? const FaIcon(
                                    FontAwesomeIcons.plus,
                                    size: 24,
                                    color: AppColors.lightTextColor,
                                  )
                                : const FaIcon(
                                    FontAwesomeIcons.pen,
                                    size: 20,
                                    color: AppColors.lightTextColor,
                                  ),
                        label: _isLoading
                            ? _session == null
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
                                    'Updating...',
                                    style: TextStyle(
                                      fontFamily: 'SF Pro Display',
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18.0,
                                      color: AppColors.lightTextColor,
                                    ),
                                  )
                            : _session == null
                                ? const Text(
                                    'Create Session',
                                    style: TextStyle(
                                      fontFamily: 'SF Pro Display',
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18.0,
                                      color: AppColors.lightTextColor,
                                    ),
                                  )
                                : const Text(
                                    'Update Session',
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
