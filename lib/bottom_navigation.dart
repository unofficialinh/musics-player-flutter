import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/color.dart';
import 'package:music_player/pages/home_page.dart';
import 'package:music_player/pages/library_page.dart';
import 'package:music_player/pages/player/music_detail_page.dart';
import 'package:music_player/pages/search_page.dart';
import 'package:music_player/pages/settings_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'model/PlayingListModel.dart';

class BottomNavigation extends StatefulWidget {
  final int activeTab;

  const BottomNavigation({Key key, this.activeTab}) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  List<Widget> pages = [
    HomePage(),
    LibraryPage(),
    SearchPage(),
    SettingsPage(),
  ];

  List items = [
    Icons.home,
    Icons.library_music,
    Icons.search,
    Icons.settings,
  ];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Consumer<PlayingListModel>(builder: (context, appState, child) {
      List<dynamic> songs = appState.songs;
      return Container(
        height: appState.audioSource.length == 0 ? 55 : 120,
        color: Colors.grey.withOpacity(0.05),
        child: Column(
          children: [
            Container(
              height: 1,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 2,
                    offset: Offset(0, -2))
              ]),
            ),
            appState.audioSource.length == 0
                ? Container(
                    height: 6,
                  )
                : Column(
                    children: [
                      GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: MusicDetailPage(),
                                    type: PageTransitionType.bottomToTop));
                          },
                          child: StreamBuilder(
                            stream: appState.audioPlayer.sequenceStateStream,
                            builder: (context, snapshot) {
                              final audioPlayer = appState.audioPlayer;
                              return Container(
                                height: 50,
                                margin: EdgeInsets.only(top: 5, right: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(songs[
                                                      audioPlayer.currentIndex]
                                                  ['img']),
                                              fit: BoxFit.cover),
                                          color: primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                    ),
                                    Container(
                                      width: (size.width - 60) * 0.7,
                                      height: 50,
                                      child: Row(
                                        children: [
                                          Text(
                                            songs[appState.audioPlayer
                                                .currentIndex]['title'],
                                            maxLines: 1,
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 50,
                                      height: 50,
                                      alignment: Alignment.center,
                                      child: StreamBuilder<PlayerState>(
                                        stream: appState
                                            .audioPlayer.playerStateStream,
                                        builder: (_, snapshot) {
                                          final audioPlayer = appState.audioPlayer;
                                          final processingState = snapshot.data?.processingState;
                                          if (processingState == ProcessingState.loading ||
                                              processingState == ProcessingState.buffering) {
                                            return Container();
                                          } else if (audioPlayer.playing != true) {
                                            return IconButton(
                                                iconSize: 45,
                                                icon: Icon(
                                                  Icons.play_arrow_rounded,
                                                  color: Colors.black,
                                                ),
                                                onPressed: audioPlayer.play);
                                          } else if (processingState != ProcessingState.completed) {
                                            return IconButton(
                                                iconSize: 40,
                                                icon: Icon(
                                                  Icons.pause,
                                                  color: Colors.black,
                                                ),
                                                onPressed: audioPlayer.pause);
                                          } else {
                                            return IconButton(
                                              iconSize: 45,
                                              icon: Icon(
                                                Icons.play_arrow_rounded,
                                                color: Colors.black,
                                              ),
                                              onPressed: () => audioPlayer.seek(
                                                  Duration.zero,
                                                  index: audioPlayer.effectiveIndices.first),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )),
                      Divider(
                        thickness: 1,
                      ),
                    ],
                  ),
            Container(
              height: 30,
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(items.length, (index) {
                  return IconButton(
                      icon: Icon(
                        items[index],
                        color: widget.activeTab == index
                            ? primaryColor
                            : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          // ignore: unnecessary_statements
                          Navigator.pushReplacement(context,
                              PageTransition(child: pages[index], type: null));
                        });
                      });
                }),
              ),
            ),
          ],
        ),
      );
    });
  }
}
