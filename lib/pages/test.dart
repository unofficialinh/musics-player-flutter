import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:music_player/model/album.dart';
import 'package:http/http.dart' as http;

List<Album> parseAlbums(String responseBody) {
  final parsed = json.decode(responseBody)['albums'];
  return List<Album>.from(parsed.map((model)=> Album.fromJson(model)));
}

Future<Album> fetchAlbums() async {
  final response =
  await http.get(Uri.http('192.168.1.6:5000', 'album/3'));
  if (response.statusCode == 200) {
    return Album.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  Future<Album> futureAlbum;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureAlbum = fetchAlbums();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: FutureBuilder<Album>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.songs.toString());
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
