import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player/controller/http.dart';
import 'package:music_player/pages/artist_page.dart';
import 'package:page_transition/page_transition.dart';

import '../bottom_navigation.dart';
import '../color.dart';
import 'album_page.dart';

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

  Future<List<dynamic>> _songs;
  Future<List<dynamic>> _albums;
  Future<List<dynamic>> _playlists;
  Future<List<dynamic>> _artists;
  Future<List<dynamic>> _downloaded;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _songs = fetchSongs('song/by_name/a');
    _albums = fetchAlbums('album/by_name/a');
    _playlists = fetchAlbums('album/by_name/a');
    _artists = fetchArtists('artist/by_name/a');
    _downloaded = fetchSongs('song/by_name/a');
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
    return TabBarView(children: [
      //Song
      FutureBuilder(
          future: _songs,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var songs = snapshot.data;
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(songs.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 20, top: 15),
                      child: GestureDetector(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(songs[index]['img']),
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
                                      Text(
                                        songs[index]['title'],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        songs[index]['artist'],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.grey),
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
                ),
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ));
          }),

      //Album
      FutureBuilder(
          future: _albums,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var albums = snapshot.data;
              return GridView.count(
                padding:
                    EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 10),
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
                          'artist',
                          // albums[index]['artist'],
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
              return Text("${snapshot.error}");
            }
            return Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ));
          }),

      //Playlist
      FutureBuilder(
          future: _playlists,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var playlists = snapshot.data;
              return GridView.count(
                padding:
                    EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 10),
                crossAxisCount: 2,
                childAspectRatio: 4 / 4.5,
                children: List.generate(playlists.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              alignment: Alignment.bottomCenter,
                              child: AlbumPage(
                                album_id: playlists[index]['id'],
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
                                  image: NetworkImage(playlists[index]['img']),
                                  fit: BoxFit.cover),
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(10)),
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
              return Text("${snapshot.error}");
            }
            return Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ));
          }),

      //Artist
      FutureBuilder(
          future: _artists,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var artists = snapshot.data;
              return GridView.count(
                padding:
                    EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 10),
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
              return Text("${snapshot.error}");
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(downloaded.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 20, top: 15),
                      child: GestureDetector(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          downloaded[index]['img']),
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
                                      Text(
                                        downloaded[index]['title'],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        downloaded[index]['artist'],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.grey),
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
                ),
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ));
          }),
    ]);
  }
}
