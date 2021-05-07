import 'package:flutter/material.dart';
import 'package:music_player/json/songs_json.dart';

import '../color.dart';

class PlayingList extends StatefulWidget {
  @override
  _PlayingListState createState() => _PlayingListState();
}

class _PlayingListState extends State<PlayingList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: getAppBar(),
      body: getBody(),
    );
  }

  Widget getAppBar() {
    return AppBar(
      toolbarHeight: 100,
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
          'NEXT',
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
    List next = songs;
    return SingleChildScrollView(
      child: Column(
        children: List.generate(next.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(left: 30, right: 15, bottom: 15),
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
                            image: AssetImage(next[index]['img']),
                            fit: BoxFit.cover),
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 12),
                    width: (size.width - 60) * 0.7,
                    height: 60,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              next[index]['title'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style:
                                  TextStyle(fontSize: 22, color: Colors.black),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              next[index]['artist'],
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
    );
  }
}
