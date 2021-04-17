import 'package:flutter/material.dart';
import 'package:music_player/color.dart';
import 'package:music_player/json/songs_json.dart';
import 'package:music_player/pages/album_page.dart';
import 'package:page_transition/page_transition.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0), // here the desired height
          child: getAppBar()
      ),
      body: getBody(),
    );
  }

  Widget getAppBar() {
    return AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(left:10, top: 15),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Explore',
                    style: TextStyle(
                      color: primaryColor,
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
                                      song: songs[index],
                                    ),
                                    type: PageTransitionType.scale));
                          },
                          child: Column(
                            children: [
                              Container(
                                width: 180,
                                height: 180,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(songs[index]['img']),
                                        fit: BoxFit.cover),
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                songs[index]['title'],
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
                                      song: songs[index+5],
                                    ),
                                    type: PageTransitionType.scale));
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
