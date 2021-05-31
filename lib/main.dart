import 'package:flutter/material.dart';
import 'package:music_player/pattern/color.dart';
import 'package:provider/provider.dart';

import 'authentication/login_page.dart';
import 'controller/local_file.dart';
import 'model/PlayingListModel.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final path = await getDownloadPath();
  File('$path/metadata.txt').create(recursive: true)
  .then((File file) {
  file.writeAsString('{"songs":[]}');
  });
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
