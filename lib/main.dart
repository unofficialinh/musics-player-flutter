import 'package:flutter/material.dart';
import 'package:music_player/authentication/login_page.dart';
import 'package:music_player/pages/root_app.dart';
import 'package:music_player/pattern/color.dart';
import 'package:provider/provider.dart';

import 'model/PlayingListModel.dart';

void main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PlayingListModel()),
      ],
      child: MaterialApp(
        theme: ThemeData(
            primaryColor: primaryColor,
            fontFamily: 'Poppins',
            textSelectionTheme: TextSelectionThemeData(
                cursorColor: primaryColor,
                selectionColor: primaryColor.withOpacity(0.2),
                selectionHandleColor: primaryColor)),
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
      ),
    ),
  );
}
