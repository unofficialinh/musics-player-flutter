import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:music_player/bottom_navigation.dart';
import 'package:music_player/color.dart';
import 'package:music_player/json/songs_json.dart';
import 'package:music_player/pages/album_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;
import 'package:music_player/model/album.dart';

List<Album> parseAlbums(String responseBody) {
  final parsed = json.decode(responseBody)['albums'];
  return List<Album>.from(parsed.map((model)=> Album.fromJson(model)));
}

Future<List<Album>> fetchAlbums(path) async {
  final response =
      await http.get(Uri.http('192.168.1.6:5000', path));
  if (response.statusCode == 200) {
    return parseAlbums(response.body);
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Album>> recentlyPlayed;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    recentlyPlayed = fetchAlbums('album/by_name/a');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: getAppBar(),
      body: getBody(),
      bottomNavigationBar: BottomNavigation(
        activeTab: 0,
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
                    'Explore',
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 25,
                  right: 10,
                ),
                child: Row(
                  children: [
                    Text(
                      "Recently played",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              FutureBuilder<List<Album>>(
                future: recentlyPlayed,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var albums = snapshot.data;
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Row(
                          children: List.generate(albums.length - 5, (index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 30),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          alignment: Alignment.bottomCenter,
                                          child: AlbumPage(
                                            album: albums[index],
                                          ),
                                          type:
                                              PageTransitionType.rightToLeft));
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: 180,
                                      height: 180,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  albums[index].img),
                                              fit: BoxFit.cover),
                                          color: primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      albums[index].title,
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
                    );
                  }
                  else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return Center(
                  //     child: CircularProgressIndicator(
                  //   valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  // ));
                      child: Text("Nothing here"));
                },
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 25,
                  right: 10,
                  top: 20,
                ),
                child: Row(
                  children: [
                    Text(
                      "Newest songs",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
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
                                      album: songs[index + 5],
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
            ],
          ),
        ],
      ),
    );
  }
}
