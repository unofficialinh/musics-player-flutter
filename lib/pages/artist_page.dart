import 'package:flutter/material.dart';
import 'package:music_player/bottom_navigation.dart';
import 'package:music_player/json/songs_json.dart';
import 'package:page_transition/page_transition.dart';

import '../color.dart';
import 'album_page.dart';

class ArtistPage extends StatefulWidget {
  final dynamic artist;

  const ArtistPage({Key key, this.artist}) : super(key: key);

  @override
  _ArtistPageState createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: getBody(),
      bottomNavigationBar: BottomNavigation(),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    List song = artist[0]['songs'];
    List album = songs;
    return SingleChildScrollView(
      child: Stack(
        children: [
          Stack(children: [
            Column(children: [
              Container(
                width: size.width,
                height: size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(artist[0]["img"]), fit: BoxFit.cover),
                ),
                child: Container(
                  margin: EdgeInsets.only(top: size.width - 150),
                  child: Stack(
                    children: [
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.6),
                              Colors.transparent
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                      Column(children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15, top: 65),
                          child: Row(
                            children: [
                              Text(
                                'ARTIST',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Row(
                            children: [
                              Text(
                                widget.artist,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ])
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 25, top: 25, bottom: 25),
                    child: Text(
                      'Popular songs',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: List.generate(5, (index) {
                  return Padding(
                    padding:
                    const EdgeInsets.only(left: 30, right: 30, bottom: 10),
                    child: GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     PageTransition(
                        //         alignment: Alignment.bottomCenter,
                        //         child: MusicDetailPage(
                        //           title: widget.song['title'],
                        //           description: widget.song['description'],
                        //           artist: widget.song['artist'],
                        //           img: widget.song['img'],
                        //           songUrl: widget.song['song_url'],
                        //         ),
                        //         type: PageTransitionType.scale));
                      },
                      child: Row(
                        children: [
                          Container(
                            width: (size.width - 60) * 0.1,
                            height: 50,
                            child: Text(
                              (index + 1).toString(),
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Container(
                            width: (size.width - 60) * 0.8,
                            height: 60,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      song[index]['title'],
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      song[index]['duration'],
                                      style: TextStyle(
                                          fontSize: 17, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: (size.width - 60) * 0.1,
                            height: 50,
                            child: Icon(Icons.more_vert),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 25, top: 25, bottom: 25),
                    child: Text(
                      'Albums',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Row(
                    children: List.generate(songs.length - 5, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 30),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    alignment: Alignment.bottomCenter,
                                    child: AlbumPage(
                                      album: album[index],
                                    ),
                                    type: PageTransitionType.rightToLeft));
                          },
                          child: Column(
                            children: [
                              Container(
                                width: 180,
                                height: 180,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image:
                                        AssetImage(songs[index + 5]['img']),
                                        fit: BoxFit.cover),
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                songs[index + 5]['title'],
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                songs[index + 5]['artist'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ]),
            Container(
              height: 80,
              width: 80,
              margin:
              EdgeInsets.only(top: size.width - 47, left: size.width - 100),
              child: Stack(children: [
                IconButton(
                    iconSize: 80,
                    icon: Icon(
                      Icons.circle,
                      color: Colors.white,
                    ),
                    onPressed: null),
                IconButton(
                    iconSize: 80,
                    icon: Icon(
                      Icons.play_circle_filled_rounded,
                      color: primaryColor,
                    ),
                    onPressed: () {
                      // Navigator.push(
                      //     context,
                      //     PageTransition(
                      //         alignment: Alignment.bottomCenter,
                      //         child: MusicDetailPage(
                      //           title: widget.song['title'],
                      //           description: widget.song['description'],
                      //           artist: widget.song['artist'],
                      //           img: widget.song['img'],
                      //           songUrl: widget.song['song_url'],
                      //         ),
                      //         type: PageTransitionType.scale));
                    }),
              ]),
            ),
          ]),
          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  margin: EdgeInsets.only(left: 10, top: 10),
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.1),
                      shape: BoxShape.circle),
                  child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
                Container(
                  height: 40,
                  width: 40,
                  margin: EdgeInsets.only(right: 10, top: 10),
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.1),
                      shape: BoxShape.circle),
                  child: IconButton(
                      icon: Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
