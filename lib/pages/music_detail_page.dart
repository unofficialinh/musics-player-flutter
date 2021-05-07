import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:music_player/pages/artist_page.dart';
import 'package:music_player/pages/playing_list_page.dart';
import 'package:page_transition/page_transition.dart';

import '../color.dart';

class MusicDetailPage extends StatefulWidget {
  final String title;
  final String artist;
  final String description;
  final String img;
  final String mp3;

  const MusicDetailPage(
      {Key key,
      this.title,
      this.artist,
      this.description,
      this.img,
      this.mp3})
      : super(key: key);

  @override
  _MusicDetailPageState createState() => _MusicDetailPageState();
}

class _MusicDetailPageState extends State<MusicDetailPage> {
  double _currentSliderValue = 20;

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
      leading: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.grey,
            size: 35,
          ),
          onPressed: () {
            Navigator.pop(context);
          }),
      backgroundColor: Colors.white,
      elevation: 0,
      title: Center(
        child: Text(
          'NOW PLAYING',
          style: TextStyle(color: Colors.grey, fontSize: 20),
        ),
      ),
      actions: [PopupMenuButton(
        icon: Icon(
          Icons.more_vert,
          color: Colors.grey,
        ),
        offset: Offset(0, 15),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
          PopupMenuItem(
            child: ListTile(
              title: Text('Play next'),
              trailing: Icon(
                Icons.playlist_add_rounded,
                color: primaryColor,
              ),
              onTap: () {},
            ),
          ),
          PopupMenuDivider(),
          PopupMenuItem(
            child: ListTile(
              title: Text('Add to playlist'),
              trailing: Icon(
                Icons.add_rounded,
                color: primaryColor,
              ),
              onTap: () {},
            ),
          ),
          PopupMenuDivider(),
          PopupMenuItem(
            child: ListTile(
              title: Text('Album'),
              trailing: Icon(
                Icons.library_music,
                color: primaryColor,
              ),
              onTap: () {},
            ),
          ),
        ],
      ),],
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Stack(
            children: [
              Center(
                child: Container(
                  width: size.width * 0.8,
                  height: size.width * 0.8,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage(widget.img)),
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 5,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    widget.title,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, PageTransition(alignment: Alignment.bottomCenter,
                        child: ArtistPage(
                          artist: widget.artist,
                        ),
                        type: PageTransitionType.rightToLeft));
                  },
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    // controller: ,
                    child: Text(
                      widget.artist,
                      style: TextStyle(
                        fontSize: 18,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "0:38",
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 3,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5),
                  ),
                  child: Container(
                    width: size.width * 0.75,
                    child: Slider(
                        value: _currentSliderValue,
                        min: 0,
                        max: 200,
                        activeColor: primaryColor,
                        inactiveColor: primaryColor.withOpacity(0.3),
                        onChanged: (value) {
                          setState(() {
                            _currentSliderValue = value;
                          });
                        }),
                  ),
                ),
                Text(
                  "3:04",
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    iconSize: 25,
                    icon: Icon(
                      Icons.replay_30_rounded,
                      color: Colors.black,
                    ),
                    onPressed: null),
                IconButton(
                    iconSize: 40,
                    icon: Icon(
                      Icons.skip_previous_rounded,
                      color: Colors.black,
                    ),
                    onPressed: null),
                IconButton(
                    iconSize: 80,
                    icon: Icon(
                      Icons.play_circle_fill_rounded,
                      color: primaryColor,
                    ),
                    onPressed: null),
                IconButton(
                    iconSize: 40,
                    icon: Icon(
                      Icons.skip_next_rounded,
                      color: Colors.black,
                    ),
                    onPressed: null),
                IconButton(
                    iconSize: 25,
                    icon: Icon(
                      Icons.forward_30_rounded,
                      color: Colors.black,
                    ),
                    onPressed: null),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    iconSize: 25,
                    icon: Icon(
                      Icons.favorite,
                      color: primaryColor,
                    ),
                    onPressed: null),
                IconButton(
                    iconSize: 25,
                    icon: Icon(
                      Icons.shuffle,
                      color: Colors.grey,
                    ),
                    onPressed: null),
                IconButton(
                    iconSize: 25,
                    icon: Icon(
                      Icons.repeat_rounded,
                      color: Colors.grey,
                    ),
                    onPressed: null),
                IconButton(
                    iconSize: 25,
                    icon: Icon(
                      Icons.queue_music,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      Navigator.push(context, PageTransition(
                        alignment: Alignment.bottomCenter,
                        child: PlayingList(),
                        type: PageTransitionType.rightToLeft,
                      ));
                    }),
              ],
            ),
          ),
        ],
      );
  }
}
