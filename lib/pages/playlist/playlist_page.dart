import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player/controller/http.dart';
import 'package:music_player/model/PlayingListModel.dart';
import 'package:music_player/pages/player/music_detail_page.dart';
import 'package:music_player/pattern/snackbar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../pattern/bottom_navigation.dart';
import '../../pattern/color.dart';
import '../download_page.dart';

class PlaylistPage extends StatefulWidget {
  final dynamic playlist_id;

  const PlaylistPage({Key key, this.playlist_id}) : super(key: key);

  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  Future<dynamic> _playlist;
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
    _playlist = getPlaylistById(widget.playlist_id);
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
    return FutureBuilder<dynamic>(
        future: _playlist,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var playlist = snapshot.data;
            var songs = playlist['songs'];

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
                              image: NetworkImage(playlistImg),
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
                                        'PLAYLIST',
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
                                      Flexible(
                                        child: Text(
                                          playlist['title'],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                          ),
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
                              'All songs',
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
                                left: 30, right: 30, bottom: 5),
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
                                    child: Row(
                                      children: [
                                        Text(
                                          (index + 1).toString(),
                                          style: TextStyle(
                                            color: primaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
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
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Flexible(
                                          child: Row(
                                            children: [
                                              Text(
                                                songs[index]['artist'],
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    color: Colors.grey),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ],
                                          ),
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
                                            title: Text(
                                                'Remove'),
                                            trailing: Icon(
                                              Icons.delete_outline,
                                              color: primaryColor,
                                            ),
                                            onTap: () {
                                              Navigator.pop(context);
                                              deleteSongFromPlaylist(widget.playlist_id, songs[index]['id']).then((value) {
                                                snackBar(context, value);
                                                setState(() {});
                                              });
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
                                                      DownloadPage(uri: songs[index]['img']))
                                                  .then((_) =>
                                                  showDialog(
                                                      context: context,
                                                      builder: (_) =>
                                                          DownloadPage(uri: songs[index]['mp3']))
                                              )
                                               ;
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
                          child: PopupMenuButton(
                            icon: Icon(
                              Icons.more_vert,
                              color: Colors.white,
                            ),
                            offset: Offset(0, 7),
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
                                    String msg =
                                        'Playlist added to playing list!';
                                    for (int i = 0; i < songs.length; i++) {
                                      Provider.of<PlayingListModel>(context,
                                              listen: false)
                                          .addBack(songs[i]);
                                    }
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
                                  title: Text('Delete'),
                                  trailing: Icon(
                                    Icons.delete_outline,
                                    color: primaryColor,
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                    deletePlaylist(widget.playlist_id).then((value) {
                                      snackBar(context, value);
                                      Navigator.pop(context);
                                    });
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
                                  },
                                ),
                              ),
                            ],
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
