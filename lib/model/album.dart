import 'package:music_player/model/song.dart';

class Album {
  int id;
  String title;
  String img;
  String artist;
  int artist_id;
  List<Song> songs;

  Album(
      {this.id, this.title, this.img, this.artist, this.artist_id, this.songs});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
        id: json['id'],
        title: json['title'],
        img: json['img'],
        artist: json['artist'],
        artist_id: json['artist_id'],
        songs: List<Song>.from(
            json['songs'].map((model) => Song.fromJson(model))));
  }
}
