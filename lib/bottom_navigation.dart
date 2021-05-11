import 'package:flutter/material.dart';
import 'package:music_player/color.dart';
import 'package:music_player/pages/home_page.dart';
import 'package:music_player/pages/library_page.dart';
import 'package:music_player/pages/music_detail_page.dart';
import 'package:music_player/pages/player/player.dart';
import 'package:music_player/pages/search_page.dart';
import 'package:music_player/pages/settings_page.dart';
import 'package:page_transition/page_transition.dart';

class BottomNavigation extends StatefulWidget {
  final int activeTab;

  const BottomNavigation({Key key, this.activeTab}) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  List<Widget> pages = [
    HomePage(),
    LibraryPage(),
    SearchPage(),
    Player(),
  ];

  List items = [
    Icons.home,
    Icons.library_music,
    Icons.search,
    Icons.settings,
  ];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
      height: 120,
      color: Colors.grey.withOpacity(0.05),
      child: Column(
        children: [
          Container(
            height: 1,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 2,
                  offset: Offset(0, -2)
                )
              ]
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      child: MusicDetailPage(
                        song_id: 3,
                      ),
                      type: PageTransitionType.bottomToTop));
            },
            child: Container(
              margin: EdgeInsets.only(top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/img_3.jpg"),
                            fit: BoxFit.cover),
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  Container(
                    width: (size.width - 60) * 0.7,
                    height: 50,
                    child: Row(
                      children: [
                        Text(
                          "Fellin' Good",
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    child: Icon(
                      Icons.pause,
                      color: Colors.black,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(items.length, (index) {
                return IconButton(
                    icon: Icon(
                      items[index],
                      color: widget.activeTab == index
                          ? primaryColor
                          : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        // ignore: unnecessary_statements
                        Navigator.pushReplacement(context,
                            PageTransition(child: pages[index], type: null));
                      });
                    });
              }),
            ),
          ),
        ],
      ),
    );
  }
}
