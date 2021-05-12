import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player/controller/http.dart';
import 'package:music_player/pages/music_detail_page.dart';
import 'package:page_transition/page_transition.dart';

import '../bottom_navigation.dart';
import '../color.dart';
import 'artist_page.dart';

class AlbumPage extends StatefulWidget {
  final dynamic album_id;

  const AlbumPage({Key key, this.album_id}) : super(key: key);

  @override
  _AlbumPageState createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  Future<dynamic> _album;

  @override
  void initState() {
    super.initState();
    _album = searchAlbumById(widget.album_id);
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
    var size = MediaQuery.of(context).size;
    return FutureBuilder<dynamic>(
        future: _album,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var album = snapshot.data;
            var songs = album['songs'];

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
                              image: NetworkImage(album['img']),
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
                                        'ALBUM',
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
                                        album['title'],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
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
                                left: 30, right: 30, bottom: 10),
                            child: GestureDetector(
                              onTap: () {
                                // Navigator.push(
                                //     context,
                                //     PageTransition(
                                //         alignment: Alignment.bottomCenter,
                                //         child: MusicDetailPage(
                                //           title: songs[index]['title'],
                                //           description: songs[index]['description'],
                                //           artist: songs[index]['artist'],
                                //           img: songs[index]['img'],
                                //           mp3: songs[index]['mp3'],
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
                                              songs[index]['title'],
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
                                              'duration',
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
                                            onTap: () {},
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
                                            onTap: () {},
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
                                            onTap: () {},
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
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      alignment: Alignment.bottomCenter,
                                      child: MusicDetailPage(),
                                      type: PageTransitionType.scale));
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
                                  },
                                ),
                              ),
                              PopupMenuDivider(),
                              PopupMenuItem(
                                child: ListTile(
                                  title: Text('Artist'),
                                  trailing: Icon(
                                    Icons.person,
                                    color: primaryColor,
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            alignment: Alignment.bottomCenter,
                                            child: ArtistPage(
                                              artist_id: album['artist_id'],
                                            ),
                                            type:
                                            PageTransitionType.rightToLeft));
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
          }
          else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
          ));
        });
  }
}
