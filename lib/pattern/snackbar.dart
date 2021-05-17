import 'package:flutter/material.dart';

import 'color.dart';

snackBar(context, value) {
  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    content: Text(
      value,
      style: TextStyle(fontFamily: 'Poppins'),
    ),
    backgroundColor: primaryColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

