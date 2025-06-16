import 'package:flutter/material.dart';
import 'package:quickhire/constants/colors.dart';
import 'package:quickhire/constants/variables.dart';

AppBar myCustomAppBar(String title) {
  return AppBar(
    centerTitle: true,
    title: Text(title),
    titleTextStyle: const TextStyle(
      color: primaryText,
      fontSize: largeFontSize,
      fontWeight: poppinsSemiBold,
    ),
  );
}
