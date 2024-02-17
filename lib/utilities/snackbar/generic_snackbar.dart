import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

SnackBar showGenericSnackbar<T>({
  required String title,
  required String message,
  required ContentType contentType,
}) {
  return SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: title,
      message: message,
      contentType: contentType,
      inMaterialBanner: true,
    ),
  );
}
