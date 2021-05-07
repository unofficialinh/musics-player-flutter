class Song {
  int id;
  String title;
  String img;
  String artist;
  int artist_id;
  String album;
  int album_id;

  Song(
      {this.id,
      this.title,
      this.img,
      this.artist,
      this.artist_id,
      this.album,
      this.album_id});

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
        id: json['id'],
        title: json['title'],
        img: json['img'],
        artist: json['artist'],
        artist_id: json['artist_id'],
        album: json['album'],
        album_id: json['album_id']
    );
  }
}
