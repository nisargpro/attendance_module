import 'package:flutter/material.dart';

void showSnackBar(final BuildContext context, final String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.black,
      content: Text(msg),
      duration: Duration(seconds: 4),
    ),
  );
}

int getCurrentTimeStamp() => DateTime.now().millisecondsSinceEpoch;

int getMilliSecFromHours(final int hours) => hours * 60 * 60 * 1000;

int getMilliSecFromDays(final int days) => days * 24 * 60 * 60 * 1000;
