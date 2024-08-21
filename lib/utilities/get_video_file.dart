import 'package:cricai/utilities/snackbar/error_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<XFile?> getVideoFile(ImageSource sourceImg, BuildContext context) async {
  try {
    final videoFile = await ImagePicker().pickVideo(source: sourceImg);

    if (videoFile != null) {
      return videoFile;
    }
    return null;
  } catch (e) {
    print('Error picking video: $e');
    showErrorSnackbar(
      context,
      'Error Picking Video',
    );
    return null;
  }
}

// UploadForm(
//   videoFile: File(videoFile.path),
//   videoPath: videoFile.path,
// ),