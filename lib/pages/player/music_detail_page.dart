import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/model/PlayingListModel.dart';
import 'package:music_player/pages/album_page.dart';
import 'package:music_player/pages/artist_page.dart';
import 'package:music_player/pages/player/control_buttons.dart';
import 'package:music_player/pages/player/lyrics_page.dart';
import 'package:music_player/pages/player/seek_bar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../pattern/color.dart';

class MusicDetailPage extends StatefulWidget {
  @override
  _MusicDetailPageState createState() => _MusicDetailPageState();
}

class _MusicDetailPageState extends State<MusicDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: getAppBar(),
      body: getBody(),
    );
  }

  Widget getAppBar() {
    return AppBar(
      leading: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.grey,
            size: 35,
          ),
          onPressed: () {
            Navigator.pop(context);
          }),
      backgroundColor: Colors.white,
      elevation: 0,
      title: Center(
        child: Text(
          'NOW PLAYING',
          style: TextStyle(color: Colors.grey, fontSize: 20),
        ),
      ),
      actions: [
        Consumer<PlayingListModel>(builder: (context, appState, child) {
          List<dynamic> songs = appState.songs;
          AudioPlayer audioPlayer = appState.audioPlayer;
          return PopupMenuButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.grey,
            ),
            offset: Offset(0, 15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                child: ListTile(
                  title: Text('Add to playlist'),
                  trailing: Icon(
                    Icons.add_rounded,
                    color: primaryColor,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ),
              PopupMenuDivider(),
              PopupMenuItem(
                  child: ListTile(
                    title: Text('Album'),
                    trailing: Icon(
                      Icons.library_music,
                      color: primaryColor,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          PageTransition(
                              alignment: Alignment.bottomCenter,
                              child: AlbumPage(
                                album_id: songs[audioPlayer.currentIndex]
                                    ['album_id'],
                              ),
                              type: PageTransitionType.rightToLeft));
                },
              )),
              PopupMenuDivider(),
              PopupMenuItem(
                child: ListTile(
                  title: Text('Download'),
                  trailing: Icon(
                    Icons.download_sharp,
                    color: primaryColor,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              PopupMenuDivider(),
              PopupMenuItem(
                child: ListTile(
                  title: Text('Lyrics'),
                  trailing: Icon(
                    Icons.textsms_outlined,
                    color: primaryColor,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        PageTransition(
                            child: LyricsPage(
                                lyrics: songs[audioPlayer.currentIndex]
                                    ['lyrics']),
                            type: PageTransitionType.rightToLeft));
                  },
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return Consumer<PlayingListModel>(builder: (context, appState, child) {
      List<dynamic> songs = appState.songs;
      AudioPlayer audioPlayer = appState.audioPlayer;
      ConcatenatingAudioSource audioSource = appState.audioSource;
      if (audioSource.length == 0) {
        return Center(
          child: Column(children: [
            SizedBox(
              height: 20,
            ),
            Icon(
              Icons.error_outline_rounded,
              size: 100,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Playing list is empty!',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Add new song to play.',
              style: TextStyle(fontSize: 20),
            ),
          ]),
        );
      } else
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            StreamBuilder(
                stream: audioPlayer.sequenceStateStream,
                builder: (context, snapshot) {
                  return Column(
                    children: [
                      Stack(
                        children: [
                          Center(
                            child: Container(
                              width: size.width * 0.8,
                              height: size.width * 0.8,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        songs[audioPlayer.currentIndex]
                                            ['img'])),
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    spreadRadius: 5,
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 15),
                        child: Column(
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                songs[audioPlayer.currentIndex]['title'],
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        alignment: Alignment.bottomCenter,
                                        child: ArtistPage(
                                          artist_id:
                                              songs[audioPlayer.currentIndex]
                                                  ['artist_id'],
                                        ),
                                        type: PageTransitionType.rightToLeft));
                              },
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                // controller: ,
                                child: Text(
                                  songs[audioPlayer.currentIndex]['artist'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SeekBar(audioPlayer),
                      ControlButtons(audioPlayer),
                    ],
                  );
                }),
          ],
        );
    });
  }
}
