import 'package:flutter/material.dart';
import 'package:cricai/utilities/snackbar/generic_snackbar.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

void showSuccessSnackbar(
  BuildContext context,
  String text,
) {
  final snackBar = showGenericSnackbar(
    title: 'Congratulations!',
    message: text,
    contentType: ContentType.success,
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
