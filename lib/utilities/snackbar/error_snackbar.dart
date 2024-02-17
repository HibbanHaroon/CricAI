import 'package:flutter/material.dart';
import 'package:cricai/utilities/snackbar/generic_snackbar.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

void showErrorSnackbar(
  BuildContext context,
  String text,
) {
  final snackBar = showGenericSnackbar(
    title: 'Oh Snap!',
    message: text,
    contentType: ContentType.failure,
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
