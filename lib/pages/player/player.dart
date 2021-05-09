import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/bottom_navigation.dart';
import 'package:music_player/pages/player/control_buttons.dart';
import 'package:music_player/pages/player/seek_bar.dart';
import 'package:page_transition/page_transition.dart';

import '../../color.dart';
import '../album_page.dart';
import '../artist_page.dart';

class Player extends StatefulWidget {
  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  AudioPlayer audioPlayer;
  List<dynamic> songs = [
    {
      "album": "To the moon",
      "album_id": 1,
      "artist": "Hooligan",
      "artist_id": 1,
      "id": 1,
      "img": "http://10.0.2.2:5000/img/to-the-moon.jpg",
      "title": "To the moon",
      "mp3": "http://10.0.2.2:5000/mp3/to-the-moon.mp3",
    },
    {
      "album": "I met you when I was 18.",
      "album_id": 2,
      "artist": "Lauv",
      "artist_id": 2,
      "id": 2,
      "img": "http://10.0.2.2:5000/img/paris-in-the-rain.jpg",
      "title": "Paris in the rain",
      "mp3": "http://10.0.2.2:5000/mp3/paris-in-the-rain.mp3",
    },
    {
      "album": "I met you when I was 18.",
      "album_id": 2,
      "artist": "Lauv",
      "artist_id": 2,
      "id": 3,
      "img": "http://10.0.2.2:5000/img/i-like-me-better.jpg",
      "title": "I like me better",
      "mp3": "http://10.0.2.2:5000/mp3/i-like-me-better.mp3",
    },
    {
      "album": "I met you when I was 18.",
      "album_id": 2,
      "artist": "Lauv",
      "artist_id": 2,
      "id": 4,
      "img": "http://10.0.2.2:5000/img/paranoid.jpg",
      "title": "Paranoid",
      "mp3": "http://10.0.2.2:5000/mp3/paranoid.mp3",
    },
  ];

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioPlayer.setAudioSource(ConcatenatingAudioSource(
        children: List.generate(songs.length, (index) {
          return AudioSource.uri(Uri.parse(songs[index]['mp3']));
          }
        )
    )
    );
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body: getBody(),
      bottomNavigationBar: BottomNavigation(),
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
        PopupMenuButton(
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
                onTap: () {},
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
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          StreamBuilder(
              stream: audioPlayer.currentIndexStream,
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
                                      songs[audioPlayer.currentIndex]['img'])),
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
                  ],
                );
              }),
          SeekBar(audioPlayer),
          ControlButtons(audioPlayer),
        ],
      ),
    );
  }
}
