import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:riviera23/utils/app_colors.dart';

void showCustomFlushbar(
  String title,
  String message,
  BuildContext context,
) {
  Flushbar(
    backgroundColor: AppColors.primaryColor,
    borderColor: Colors.grey,
    margin: const EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(10),
    flushbarPosition: FlushbarPosition.TOP,
    title: title,
    message: message,
    duration: const Duration(seconds: 3),
  ).show(context);
}
