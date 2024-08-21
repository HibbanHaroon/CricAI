import 'package:flutter/material.dart';
import 'package:cricai/utilities/snackbar/generic_snackbar.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

void showHelpSnackbar(
  BuildContext context,
  String text,
) {
  final snackBar = showGenericSnackbar(
    title: 'Hi There!',
    message: text,
    contentType: ContentType.help,
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
