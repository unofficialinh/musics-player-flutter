import 'package:flutter/material.dart';
import 'package:music_player/color.dart';
import '../bottom_navigation.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: getAppBar(),
      body: getBody(),
      bottomNavigationBar: BottomNavigation(
        activeTab: 2,
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
                    'Search',
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
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
      child: Column(
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.15),
                borderRadius: BorderRadius.circular(25)),
            child: TextField(
              cursorColor: primaryColor,
              decoration: InputDecoration(
                hintText: "Search for songs, albums, artist and more",
                prefixIcon: Icon(
                  Icons.search,
                  color: primaryColor,
                ),
                border: InputBorder.none,
              ),
            ),
          )
        ],
      ),
    );
  }
}
