import 'package:flutter/material.dart';
import 'package:music_player/pages/root_app.dart';
import 'package:provider/provider.dart';

import 'model/PlayingListModel.dart';

void main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PlayingListModel()),
      ],
      child: MaterialApp(
        theme: ThemeData(fontFamily: 'Poppins'),
        debugShowCheckedModeBanner: false,
        home: RootApp(),
      ),
    ),
  );
}
