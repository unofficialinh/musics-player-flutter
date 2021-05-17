import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music_player/pages/download_page.dart';
import 'package:music_player/pages/playlist/add_song_playlist.dart';
import 'package:music_player/pattern/color.dart';
import 'package:music_player/controller/http.dart';
import 'package:music_player/model/PlayingListModel.dart';
import 'package:music_player/pages/artist_page.dart';
import 'package:music_player/pages/player/music_detail_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../pattern/bottom_navigation.dart';
import 'album_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();
  String _search = '';
  Future<List<dynamic>> _songs;
  Future<List<dynamic>> _artists;
  Future<List<dynamic>> _albums;
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
    // TODO: implement initState
    super.initState();
    _checkInternetConnection();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: getAppBar(),
      body: getBody(),
      bottomNavigationBar: BottomNavigation(
        activeTab: 2,
      ),
    );
  }

  Widget getAppBar() {
    return AppBar(
        toolbarHeight: 100,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 10, top: 15),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Search',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
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

    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(25)),
              child: TextField(
                controller: _controller,
                cursorColor: primaryColor,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: "Search for songs, albums, artist and more",
                  prefixIcon: Icon(
                    Icons.search,
                    color: primaryColor,
                  ),
                  border: InputBorder.none,
                ),
                onSubmitted: (String value) {
                  setState(() {
                    _search = _controller.text.toLowerCase();
                  });
                },
              ),
            ),
            getResult(),
          ],
        ),
      ),
    );
  }

  Widget getResult() {
    var size = MediaQuery.of(context).size;
    if (_search != '') {
      _songs = searchSongsByName(_search);
      _artists = searchArtistsByName(_search);
      _albums = searchAlbumsByName(_search);
      return SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                children: [
                  Text(
                    'Songs',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  )
                ],
              ),
            ),
            FutureBuilder(
                future: _songs,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var songs = snapshot.data;
                    return Consumer<PlayingListModel>(
                        builder: (context, appState, child) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                            songs.length > 3 ? 3 : songs.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: GestureDetector(
                              onTap: () {
                                appState.setPlaylist([songs[index]], 0);
                                appState.audioPlayer.play();
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        child: MusicDetailPage(),
                                        type: PageTransitionType.bottomToTop));
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                songs[index]['img']),
                                            fit: BoxFit.cover),
                                        color: primaryColor,
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                  Container(
                                    width: (size.width - 60) * 0.65,
                                    height: 60,
                                    child: Column(
                                      children: [
                                        Flexible(
                                          child: Row(
                                            children: [
                                              Text(
                                                songs[index]['title'],
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          child: Row(
                                            children: [
                                              Text(
                                                songs[index]['artist'],
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 50,
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
                                                if (appState
                                                    .addBack(songs[index]))
                                                  msg =
                                                      'Song added to playing list!';
                                                else
                                                  msg =
                                                      'Song already in your playing list!';
                                                final snackBar = SnackBar(
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  content: Text(
                                                    msg,
                                                    style: TextStyle(
                                                        fontFamily: 'Poppins'),
                                                  ),
                                                  backgroundColor: primaryColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                );
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                              }),
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
                                                      child: AddToPlaylist(song_id: songs[index]['id'],),
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
                                                  builder: (_) =>
                                                      DownloadPage());
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
                      );
                    });
                  }
                  if (snapshot.hasError) {
                    return Text("");
                  }
                  return Center(
                      child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  ));
                }),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  Text(
                    'Albums',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  )
                ],
              ),
            ),
            FutureBuilder(
                future: _albums,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var albums = snapshot.data;
                    return Column(
                      children: List.generate(
                          albums.length > 3 ? 3 : albums.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      alignment: Alignment.bottomCenter,
                                      child: AlbumPage(
                                        album_id: albums[index]['id'],
                                      ),
                                      type: PageTransitionType.rightToLeft));
                            },
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              albums[index]['img']),
                                          fit: BoxFit.cover),
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(5)),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 15),
                                  width: (size.width - 60) * 0.8,
                                  height: 60,
                                  child: Column(
                                    children: [
                                      Flexible(
                                        child: Row(
                                          children: [
                                            Text(
                                              albums[index]['title'],
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Flexible(
                                        child: Row(
                                          children: [
                                            Text(
                                              albums[index]['artist'],
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey),
                                            ),
                                          ],
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
                    );
                  }
                  if (snapshot.hasError) {
                    return Text("");
                  }
                  return Center(
                      child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  ));
                }),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  Text(
                    'Artists',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  )
                ],
              ),
            ),
            FutureBuilder(
                future: _artists,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var artists = snapshot.data;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                          artists.length > 3 ? 3 : artists.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      alignment: Alignment.bottomCenter,
                                      child: ArtistPage(
                                        artist_id: artists[index]['id'],
                                      ),
                                      type: PageTransitionType.rightToLeft));
                            },
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              artists[index]['img']),
                                          fit: BoxFit.cover),
                                      color: primaryColor,
                                      shape: BoxShape.circle),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 15),
                                  width: (size.width - 60) * 0.8,
                                  height: 60,
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          artists[index]['name'],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black),
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
                    );
                  }
                  if (snapshot.hasError) {
                    return Text("");
                  }
                  return Center(
                      child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  ));
                }),
          ],
        ),
      );
    } else
      return Container();
  }
}
