import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player/color.dart';

class LyricsPage extends StatefulWidget {
  final String lyrics;
  final String img;

  const LyricsPage({Key key, this.lyrics, this.img}) : super(key: key);

  @override
  _LyricsPageState createState() => _LyricsPageState();
}

class _LyricsPageState extends State<LyricsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body: getBody(),
    );
  }

  Widget getAppBar() {
    return AppBar(
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.pop(context);
          }),
      backgroundColor: Colors.white,
      elevation: 0,
      title: Center(
        child: Text(
          'LYRICS',
          style: TextStyle(color: Colors.grey, fontSize: 22),
        ),
      ),
      actions: [
        IconButton(
            icon: Icon(
              Icons.more_horiz,
              color: Colors.white,
            ),
            onPressed: null)
      ],
    );
  }

  Widget getBody() {
    var height = MediaQuery.of(context).size.height;
    final String lyrics = "All I know is (ooh ooh ooh)\n"
        "We could go anywhere, we could do\n"
        "Anything, girl, whatever the mood we're in\n"
        "Yeah all I know is (ooh ooh ooh)\n"
        "Getting lost late at night, under stars\n"
        "Finding love standing right where we are, your lips\n"
        "They pull me in the moment\n"
        "You and I alone and\n"
        "People may be watching, I don't mind\n\n"
        "'Cause anywhere with you feels right\n"
        "Anywhere with you feels like\n"
        "Paris in the rain\n"
        "Paris in the rain\n"
        "We don't need a fancy town\n"
        "Or bottles that we can't pronounce\n"
        "'Cause anywhere, babe\n\n"
        "Is like Paris in the rain\n"
        "When I'm with you ooh ooh ooh\n"
        "When I'm with you ooh ooh ooh\n"
        "Paris in the rain\n"
        "Paris in the rain\n\n"
        "I look at you now and I want this forever\n"
        "I might not deserve it but there's nothing better\n"
        "Don't know how I ever did it all without you\n"
        "My heart is…";
    return Stack(children: [
      Container(
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                lyrics,
                style: TextStyle(
                    fontSize: 24,
                    height: 1.8,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withOpacity(0.9)),
              ),
              SizedBox(
                height: height * 0.3,
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[primaryColor, Colors.deepPurple.shade300],
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.7),
                  blurRadius: 10,
                  spreadRadius: 5),
            ]),
      ),
      Container(
          margin: EdgeInsets.only(
              left: 20, right: 20, bottom: 20, top: height * 0.7),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Colors.transparent,
                Colors.black.withOpacity(0.5)
              ],
            ),
            borderRadius: BorderRadius.circular(10),
          ))
    ]);
  }
}
