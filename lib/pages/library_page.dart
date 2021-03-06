import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player/controller/http.dart';
import 'package:music_player/controller/local_file.dart';
import 'package:music_player/model/PlayingListModel.dart';
import 'package:music_player/pages/artist_page.dart';
import 'package:music_player/pages/playlist/add_song_playlist.dart';
import 'package:music_player/pages/playlist/new_playlist.dart';
import 'package:music_player/pages/playlist/playlist_page.dart';
import 'package:music_player/pattern/snackbar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../pattern/bottom_navigation.dart';
import '../pattern/color.dart';
import 'album_page.dart';
import 'download_page.dart';
import 'player/music_detail_page.dart';

class LibraryPage extends StatefulWidget {
  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final List<Tab> tabs = <Tab>[
    Tab(text: "Song"),
    Tab(text: "Album"),
    Tab(text: "Playlist"),
    Tab(text: "Artist"),
    Tab(text: "Downloaded")
  ];
  int activeMenu = 0;
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

  Future<List<dynamic>> _songs;
  Future<List<dynamic>> _albums;
  Future<List<dynamic>> _playlists;
  Future<List<dynamic>> _artists;
  Future<List<dynamic>> _downloaded;

  @override
  void initState() {
    super.initState();
    _songs = getFavoriteSong();
    _albums = getFavoriteAlbum();
    _artists = getFavoriteArtist();
    _downloaded = getDownloadedSong();
    _checkInternetConnection();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: getAppBar(),
        body: getBody(),
        bottomNavigationBar: BottomNavigation(
          activeTab: 1,
        ),
      ),
    );
  }

  Widget getAppBar() {
    return AppBar(
      toolbarHeight: 140,
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
                  'Library',
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
      ),
      bottom: TabBar(
        tabs: tabs,
        labelColor: primaryColor,
        unselectedLabelColor: Colors.grey,
        isScrollable: true,
        indicatorColor: primaryColor,
        labelStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.normal,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    _playlists = getPlaylist();
    return TabBarView(children: [
      //Song
      !isConnected
          ? Container(
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
            )
          : FutureBuilder(
              future: _songs,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var songs = snapshot.data;
                  return SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(songs.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 20, top: 15),
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
                                      child: MusicDetailPage(),
                                      type: PageTransitionType.bottomToTop));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image:
                                              NetworkImage(songs[index]['img']),
                                          fit: BoxFit.cover),
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(5)),
                                ),
                                Container(
                                  width: (size.width - 60) * 0.7,
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
                                          title: Text('Remove'),
                                          trailing: Icon(
                                            Icons.delete_outline,
                                            color: primaryColor,
                                          ),
                                          onTap: () {
                                            Navigator.pop(context);
                                            deleteSongFromFavorite(
                                                    songs[index]['id'])
                                                .then((value) {
                                              snackBar(context, value);
                                              setState(() {
                                                _songs = getFavoriteSong();
                                                _albums = getFavoriteAlbum();
                                                _artists = getFavoriteArtist();
                                              });
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
                                                    builder: (_) =>
                                                        DownloadPage(song: songs[index]))
                                                .then((value) => setState(() {
                                                      _downloaded = getDownloadedSong();
                                                    }));
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
                  );
                } else if (snapshot.hasError) {
                  return Text("");
                }
                return Center(
                    child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                ));
              }),

      //Album
      !isConnected
          ? Container(
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
            )
          : FutureBuilder(
              future: _albums,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var albums = snapshot.data;
                  return GridView.count(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.only(
                        top: 20, bottom: 10, left: 10, right: 10),
                    crossAxisCount: 2,
                    childAspectRatio: 4 / 5,
                    children: List.generate(albums.length, (index) {
                      return GestureDetector(
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
                        child: Column(
                          children: [
                            Container(
                              width: size.width * 0.4,
                              height: size.width * 0.4,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(albums[index]['img']),
                                      fit: BoxFit.cover),
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              albums[index]['title'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              albums[index]['artist'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  );
                } else if (snapshot.hasError) {
                  return Text("");
                }
                return Center(
                    child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                ));
              }),

      //Playlist
      !isConnected
          ? Container(
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
            )
          : SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => NewPlaylist(),
                      );
                    },
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 25, right: 25, top: 15),
                      child: Row(
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: primaryColor),
                            child: Icon(
                              Icons.add_rounded,
                              size: 80,
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            width: size.width - 150,
                            child: Text(
                              "Create new playlist...",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black.withOpacity(0.6)),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  FutureBuilder(
                    future: _playlists,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var playlists = snapshot.data;
                        return GridView.count(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.only(
                              top: 20, bottom: 10, left: 10, right: 10),
                          crossAxisCount: 2,
                          childAspectRatio: 4 / 4.5,
                          children: List.generate(playlists.length, (index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                        context,
                                        PageTransition(
                                            alignment: Alignment.bottomCenter,
                                            child: PlaylistPage(
                                              playlist_id: playlists[index]
                                                  ['id'],
                                            ),
                                            type:
                                                PageTransitionType.rightToLeft))
                                    .then((value) => setState(() {}));
                              },
                              child: Column(
                                children: [
                                  Container(
                                    width: size.width * 0.4,
                                    height: size.width * 0.4,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(playlistImg),
                                            fit: BoxFit.cover),
                                        color: primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    playlists[index]['title'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        );
                      } else if (snapshot.hasError) {
                        return Text("");
                      }
                      return Center(
                          child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                      ));
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),

      //Artist
      !isConnected
          ? Container(
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
            )
          : FutureBuilder(
              future: _artists,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var artists = snapshot.data;
                  return GridView.count(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.only(
                        top: 20, bottom: 10, left: 10, right: 10),
                    crossAxisCount: 2,
                    childAspectRatio: 4 / 4.5,
                    children: List.generate(artists.length, (index) {
                      return GestureDetector(
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
                        child: Column(
                          children: [
                            Container(
                              width: size.width * 0.4,
                              height: size.width * 0.4,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: NetworkImage(artists[index]['img']),
                                    fit: BoxFit.cover),
                                color: primaryColor,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              artists[index]['name'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  );
                } else if (snapshot.hasError) {
                  return Text("");
                }
                return Center(
                    child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                ));
              }),

      //Downloaded
      FutureBuilder(
          future: _downloaded,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var downloaded = snapshot.data;
              return SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(downloaded.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 20, top: 15),
                      child: GestureDetector(
                        onTap: () {
                          Provider.of<PlayingListModel>(context, listen: false)
                              .setPlaylist(downloaded, index);
                          Provider.of<PlayingListModel>(context, listen: false)
                              .audioPlayer
                              .play();
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: MusicDetailPage(),
                                  type: PageTransitionType.bottomToTop));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: FileImage(
                                          File((downloaded[index]['img']))),
                                      fit: BoxFit.cover),
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                            Container(
                              width: (size.width - 60) * 0.7,
                              height: 60,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          downloaded[index]['title'],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          downloaded[index]['artist'],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.grey),
                                        ),
                                      ),
                                    ],
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
                                    borderRadius: BorderRadius.circular(10)),
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
                                            .addBack(downloaded[index]))
                                          msg = 'Song added to playing list!';
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
                                                  song_id: downloaded[index]
                                                      ['id'],
                                                ),
                                                type: PageTransitionType
                                                    .bottomToTop));
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
              );
            } else if (snapshot.hasError) {
              return Text("");
            }
            return Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ));
          }),
    ]);
  }
}
