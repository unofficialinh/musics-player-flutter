import 'package:flutter/material.dart';

import '../bottom_navigation.dart';
import '../color.dart';

class LibraryPage extends StatefulWidget {
  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: getAppBar(),
      body: getBody(),
      bottomNavigationBar: BottomNavigation(
        activeTab: 1,
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
        ));
  }

  Widget getBody() {
    List items = ["Song", "Album", "Playlist", "Artist", "Downloaded"];

    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(items.length, (index) {
          return Column(
            children: [
              GestureDetector(
                onTap: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      items[index],
                      style: TextStyle(
                        fontSize: 24,
                        color: primaryColor,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.grey,
                      size: 20,
                    )
                  ],
                ),
              ),
              Divider(
                thickness: 1,
              )
            ],
          );
        }),
      ),
    );
  }
}
