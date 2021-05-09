import 'package:flutter/material.dart';
import 'package:music_player/controller/http.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  Future<List<dynamic>> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = searchAlbumsByName('album/by_name/a');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: FutureBuilder<List<dynamic>>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data[0]['img'].toString());
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          )
      ),
    );
  }
}
