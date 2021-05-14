import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music_player/pattern/bottom_navigation.dart';
import 'package:music_player/pattern/color.dart';
import 'package:music_player/controller/http.dart';
import 'package:music_player/pages/album_page.dart';
import 'package:page_transition/page_transition.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<dynamic>> recommended;
  Future<List<dynamic>> newestAlbums;
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
    recommended = searchRecommendedAlbums(5);
    newestAlbums = searchNewestAlbums(5);
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
    _checkInternetConnection();
    if (!isConnected) {
      return Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, size: 80,),
            Text('No internet', style: TextStyle(fontSize: 20),),
          ],
        ),
      );
    }
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
                      "Recommended for you",
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
              FutureBuilder<List<dynamic>>(
                future: recommended,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var albums = snapshot.data;
                    return SingleChildScrollView(
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
                      "Newest albums",
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
              FutureBuilder<List<dynamic>>(
                future: newestAlbums,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var albums = snapshot.data;
                    return SingleChildScrollView(
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
                                    Text(
                                      albums[index]['artist'],
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
                    );
                  }
                  else if (snapshot.hasError) {
                    return Text("");
                  }
                  return Center(
                      child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  ));
                },
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
