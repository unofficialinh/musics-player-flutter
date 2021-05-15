import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music_player/controller/http.dart';
import 'package:music_player/pattern/bottom_navigation.dart';
import 'package:music_player/pattern/color.dart';

import 'new_playlist.dart';

class AddToPlaylist extends StatefulWidget {
  @override
  _AddToPlaylistState createState() => _AddToPlaylistState();
}

class _AddToPlaylistState extends State<AddToPlaylist> {
  Future<List<dynamic>> _playlists;
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
    _playlists = searchAlbumsByName('love');
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
      toolbarHeight: 60,
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.pop(context);
          }),
      backgroundColor: Colors.white,
      elevation: 0,
      title: Center(
        child: Text(
          'PLAYLIST',
          style: TextStyle(color: Colors.grey, fontSize: 22),
        ),
      ),
      actions: [
        IconButton(
            icon: Icon(
              Icons.more_horiz,
              color: Colors.white,
            ),
            onPressed: null)
      ],
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => NewPlaylist(),
              );
              setState(() {
                
              });
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
                    width: size.width - 150,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "Create new playlist...",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(0.6)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(playlists.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          //TODO: add selected song(s) to chosen playlist
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
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            playlists[index]['img']),
                                        fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(10),
                                    color: primaryColor),
                                ),
                              Container(
                                width: size.width - 150,
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  playlists[index]['title'],
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
                  );
                } else if (snapshot.hasError) {
                  return Text("");
                }
                return Center(
                    child: CircularProgressIndicator(
                      valueColor:
                      AlwaysStoppedAnimation<Color>(primaryColor),
                    ));
              }),
        ],
      ),
    );
  }
}
