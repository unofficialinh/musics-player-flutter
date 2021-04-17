import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player/json/songs_json.dart';

import '../color.dart';

class AlbumPage extends StatefulWidget {
  final dynamic song;

  const AlbumPage({Key key, this.song}) : super(key: key);

  @override
  _AlbumPageState createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: getBody(),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    List songAlbums = widget.song['songs'];
    return SingleChildScrollView(
      child: Stack(
        children: [
          Column(children: [
            Container(
              width: size.width,
              height: size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(widget.song['img']), fit: BoxFit.cover),
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
                              widget.song['title'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    ])
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    'All songs',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 50, bottom: 50),
                  child: IconButton(
                      icon: Icon(
                        Icons.play_circle_fill,
                        color: primaryColor,
                        size: 80,
                      ),
                      onPressed: null),
                )
              ],
            ),
            Column(
              children: List.generate(songAlbums.length, (index) {
                return Padding(
                  padding:
                      const EdgeInsets.only(left: 30, right: 30, bottom: 10),
                  child: GestureDetector(
                    onTap: () {},
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
                                    songAlbums[index]['title'],
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black
                                    ),
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  Text(
                                    songAlbums[index]['duration'],
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.grey
                                    ),
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
            )
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
