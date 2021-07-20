import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/controller/http.dart';
import 'package:music_player/pattern/color.dart';
import 'package:flutter_lyric/lyric_controller.dart';
import 'package:flutter_lyric/lyric_util.dart';
import 'package:flutter_lyric/lyric_widget.dart';

class LyricsPage extends StatefulWidget {
  final AudioPlayer audioPlayer;
  final String lyricsUri;

  const LyricsPage(this.audioPlayer, {Key key, this.lyricsUri}) : super(key: key);

  @override
  _LyricsPageState createState() => _LyricsPageState();
}

class _LyricsPageState extends State<LyricsPage> with TickerProviderStateMixin {
  Future<String> _lyrics;
  bool isConnected = true;
  LyricController controller;

  Future<void> _checkInternetConnection() async {
    try {
      final response = await InternetAddress.lookup('www.google.com');
      if (response.isNotEmpty) {
        setState(() {
          isConnected = true;
        });
      }
    } on SocketException catch (err) {
      setState(() {
        isConnected = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _lyrics = getLyrics(widget.lyricsUri);
    controller = LyricController(vsync: this);
    _checkInternetConnection();
  }


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
    if (!isConnected) {
      return Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off,
              size: 80,
            ),
            Text(
              'No internet',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      );
    }

    var height = MediaQuery.of(context).size.height;

    return FutureBuilder<dynamic>(
        future: _lyrics,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var songLyc = snapshot.data;
            var lyrics = LyricUtil.formatLyric(songLyc);

            return Stack(children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: StreamBuilder(
                  stream: widget.audioPlayer.positionStream,
                  builder: (context, snapshot) {
                    controller.progress = widget.audioPlayer.position;
                    return LyricWidget(
                      lyricGap: 15,
                      lyricMaxWidth: MediaQuery.of(context).size.width - 100,
                      size: Size(double.infinity, double.infinity),
                      lyrics: lyrics,
                      controller: controller,
                      lyricStyle: TextStyle(
                        fontSize: 20,
                        height: 1.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withOpacity(0.6),
                        fontFamily: 'Poppins'
                      ),
                      currLyricStyle: TextStyle(
                        fontSize: 20,
                        height: 1.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Poppins'
                      ),
                      draggingLyricStyle: TextStyle(
                        fontSize: 20,
                        height: 1.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent.shade100,
                        fontFamily: 'Poppins'
                      ),
                    );
                  },
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
                  )),
            ]);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              ));
        });
  }
}