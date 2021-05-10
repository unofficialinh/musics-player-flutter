import 'package:flutter/material.dart';
import 'package:music_player/pages/home_page.dart';

import 'home_page.dart';

class RootApp extends StatefulWidget {
  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // bottomNavigationBar: BottomNavigation(),
      body: HomePage(),
    );
  // }
  //
  // Widget getBody() {
  //   return IndexedStack(
  //     children: [
  //       HomePage(),
  //       LibraryPage(),
  //       Center(
  //           child: Text("Search", style: TextStyle(
  //             fontSize: 40,
  //             color: Colors.black,
  //             fontWeight: FontWeight.bold,
  //           ))
  //       ),
  //       Center(
  //           child: Text("Settings", style: TextStyle(
  //             fontSize: 40,
  //             color: Colors.black,
  //             fontWeight: FontWeight.bold,
  //           ))
  //       ),
  //     ],
  //   );
  // }
  //
  // Widget getFooter() {
  //   List items = [
  //     Icons.home,
  //     Icons.library_music,
  //     Icons.search,
  //     Icons.settings,
  //   ];
  //
  //   return Container(
  //     height: 50,
  //     decoration: BoxDecoration(color: Colors.white),
  //     child: Padding(
  //       padding: const EdgeInsets.only(left: 20, right: 20),
  //       child: Row(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: List.generate(items.length, (index) {
  //           return IconButton(
  //               icon: Icon(
  //                 items[index],
  //                 color: activeTab == index ? primaryColor : Colors.grey,
  //               ),
  //               onPressed: () {
  //                 setState(() {
  //                   activeTab = index;
  //                 });
  //               });
  //         }),
  //       ),
  //     ),
  //   );
  }
}
