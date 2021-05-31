import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:music_player/pages/playlist/add_song_playlist.dart';
import 'package:music_player/pattern/bottom_navigation.dart';
import 'package:music_player/controller/http.dart';
import 'package:music_player/model/PlayingListModel.dart';
import 'package:music_player/pattern/snackbar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../pattern/color.dart';
import 'album_page.dart';
import 'download_page.dart';
import 'player/music_detail_page.dart';

class ArtistPage extends StatefulWidget {
  final dynamic artist_id;

  const ArtistPage({Key key, this.artist_id}) : super(key: key);

  @override
  _ArtistPageState createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage> {
  Future<dynamic> _artist;
  bool isConnected = true;

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
    _artist = searchArtistById(widget.artist_id);
    _checkInternetConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: getBody(),
      bottomNavigationBar: BottomNavigation(),
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

    var size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: _artist,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var artist = snapshot.data;
            var songs = artist['popular_songs'];
            var albums = artist['new_albums'];

            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Stack(
                children: [
                  Stack(children: [
                    Column(children: [
                      Container(
                        width: size.width,
                        height: size.width,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(artist["img"]),
                              fit: BoxFit.cover),
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
                                  padding:
                                      const EdgeInsets.only(left: 15, top: 65),
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
                                        artist['name'],
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
                            padding:
                                EdgeInsets.only(left: 25, top: 25, bottom: 25),
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
                        children: List.generate(songs.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 30, right: 30, bottom: 10),
                            child: GestureDetector(
                              onTap: () {
                                Provider.of<PlayingListModel>(context,
                                        listen: false)
                                    .setPlaylist(songs, index);
                                Provider.of<PlayingListModel>(context,
                                        listen: false)
                                    .audioPlayer
                                    .play();
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        alignment: Alignment.bottomCenter,
                                        child: MusicDetailPage(),
                                        type: PageTransitionType.bottomToTop));
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
                                            Flexible(
                                              child: Text(
                                                songs[index]['title'],
                                                style: TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              // cai nay de la so luot nghe nhin dep hon
                                              (1 + new Random().nextDouble() * 2)
                                                      .toStringAsFixed(2) +
                                                  'M plays',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: (size.width - 60) * 0.1,
                                    height: 50,
                                    child: PopupMenuButton(
                                      icon: Icon(
                                        Icons.more_vert,
                                      ),
                                      offset: Offset(0, 10),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry>[
                                        PopupMenuItem(
                                          child: ListTile(
                                            title: Text('Play next'),
                                            trailing: Icon(
                                              Icons.playlist_add_rounded,
                                              color: primaryColor,
                                            ),
                                            onTap: () {
                                              Navigator.pop(context);
                                              String msg;
                                              if (Provider.of<PlayingListModel>(
                                                      context,
                                                      listen: false)
                                                  .addBack(songs[index]))
                                                msg =
                                                    'Song added to playing list!';
                                              else
                                                msg =
                                                    'Song already in your playing list!';
                                              snackBar(context, msg);
                                            },
                                          ),
                                        ),
                                        PopupMenuDivider(),
                                        PopupMenuItem(
                                          child: ListTile(
                                            title: Text('Favorite'),
                                            trailing: Icon(
                                              Icons.favorite_border,
                                              color: primaryColor,
                                            ),
                                            onTap: () {
                                              Navigator.pop(context);
                                              addSongToFavorite(songs[index]['id']).then((value) {
                                                snackBar(context, value);
                                              });
                                            },
                                          ),
                                        ),
                                        PopupMenuDivider(),
                                        PopupMenuItem(
                                          child: ListTile(
                                            title: Text('Add to playlist'),
                                            trailing: Icon(
                                              Icons.add_rounded,
                                              color: primaryColor,
                                            ),
                                            onTap: () {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                  context,
                                                  PageTransition(
                                                      child: AddToPlaylist(
                                                        song_id: songs[index]
                                                            ['id'],
                                                      ),
                                                      type: PageTransitionType
                                                          .bottomToTop));
                                            },
                                          ),
                                        ),
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
                                              showDialog(
                                                  context: context,
                                                  builder: (_) => DownloadPage(song: songs[index]));
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
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
                            padding:
                                EdgeInsets.only(left: 25, top: 25, bottom: 25),
                            child: Text(
                              'New Albums',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Row(
                            children: List.generate(albums.length, (index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 30),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            alignment: Alignment.bottomCenter,
                                            child: AlbumPage(
                                              album_id: albums[index]['id'],
                                            ),
                                            type: PageTransitionType
                                                .rightToLeft));
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 180,
                                        height: 180,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    albums[index]['img']),
                                                fit: BoxFit.cover),
                                            color: primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        albums[index]['title'],
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
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
                      SizedBox(
                        height: 20,
                      )
                    ]),
                    Container(
                      height: 80,
                      width: 80,
                      margin: EdgeInsets.only(
                          top: size.width - 47, left: size.width - 100),
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
                              Provider.of<PlayingListModel>(context,
                                      listen: false)
                                  .setPlaylist(songs, 0);
                              Provider.of<PlayingListModel>(context,
                                      listen: false)
                                  .audioPlayer
                                  .play();
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      alignment: Alignment.bottomCenter,
                                      child: MusicDetailPage(),
                                      type: PageTransitionType.bottomToTop));
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
                          child: Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
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
