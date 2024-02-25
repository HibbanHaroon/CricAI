import 'package:flutter/material.dart';
import 'package:cricai/utilities/snackbar/generic_snackbar.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

void showWarningSnackbar(
  BuildContext context,
  String text,
) {
  final snackBar = showGenericSnackbar(
    title: 'Warning!',
    message: text,
    contentType: ContentType.warning,
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
