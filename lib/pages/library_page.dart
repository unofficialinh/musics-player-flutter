import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player/json/songs_json.dart';
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
    List song = songs;
    return TabBarView(children: [
      //Song
      SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(song.length, (index) {
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
                              image: AssetImage(song[index]['img']),
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
                                song[index]['title'],
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
                                song[index]['artist'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      child: Icon(Icons.more_vert),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),

      //Album
      GridView.count(
        padding: EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 10),
        crossAxisCount: 2,
        childAspectRatio: 4 / 5,
        children: List.generate(song.length, (index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      alignment: Alignment.bottomCenter,
                      child: AlbumPage(
                        album: song[index],
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
                          image: AssetImage(song[index]['img']),
                          fit: BoxFit.cover),
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(10)),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  songs[index]['title'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  songs[index]['artist'],
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
      ),

      //Playlist
      GridView.count(
        padding: EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 10),
        crossAxisCount: 2,
        childAspectRatio: 4 / 4.5,
        children: List.generate(song.length, (index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      alignment: Alignment.bottomCenter,
                      child: AlbumPage(
                        album: song[index],
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
                          image: AssetImage(song[index]['img']),
                          fit: BoxFit.cover),
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(10)),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  songs[index]['title'],
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
      ),

      //Artist
      GridView.count(
        padding: EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 10),
        crossAxisCount: 2,
        childAspectRatio: 4 / 4.5,
        children: List.generate(song.length, (index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      alignment: Alignment.bottomCenter,
                      child: AlbumPage(
                        album: song[index],
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
                          image: AssetImage(song[index]['img']),
                          fit: BoxFit.cover),
                      color: primaryColor,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  songs[index]['artist'],
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
      ),

      //Downloaded
      SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(song.length, (index) {
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
                              image: AssetImage(song[index]['img']),
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
                                song[index]['title'],
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
                                song[index]['artist'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      child: Icon(Icons.more_vert),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    ]);
    // return Padding(
    //   padding: const EdgeInsets.only(left: 25, right: 40, top: 20),
    //   child: SingleChildScrollView(
    //     scrollDirection: Axis.vertical,
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         SingleChildScrollView(
    //           scrollDirection: Axis.horizontal,
    //           child: Row(
    //             children: List.generate(tabs.length, (index) {
    //               return Padding(
    //                 padding: const EdgeInsets.only(right: 15),
    //                 child: GestureDetector(
    //                   onTap: () {
    //                     setState(() {
    //                       activeMenu = index;
    //                     });
    //                   },
    //                   child: Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       Text(
    //                         tabs[index],
    //                         style: TextStyle(
    //                           fontSize: 22,
    //                           fontWeight: activeMenu == index
    //                               ? FontWeight.bold
    //                               : FontWeight.normal,
    //                           color:
    //                           activeMenu == index ? primaryColor : Colors.grey,
    //                         ),
    //                       ),
    //                       SizedBox(
    //                         height: 3,
    //                       ),
    //                       activeMenu == index
    //                           ? Container(
    //                               width: 40,
    //                               height: 3,
    //                               decoration: BoxDecoration(
    //                                 color: primaryColor,
    //                                 borderRadius: BorderRadius.circular(5),
    //                               ),
    //                             )
    //                           : Container(),
    //                     ],
    //                   ),
    //                 ),
    //               );
    //             }),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
