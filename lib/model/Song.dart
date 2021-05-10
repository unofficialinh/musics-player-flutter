class Song {
  int _id;
  String _title;
  String _img;
  String _artist;
  int _artistId;
  String _album;
  int _albumId;
  String _mp3;
  String _lyrics;

  Song(this._id, this._title, this._img, this._artist, this._artistId,
      this._album, this._albumId, this._mp3, this._lyrics);

  int get id => _id;

  String get title => _title;

  String get lyrics => _lyrics;

  String get mp3 => _mp3;

  int get albumId => _albumId;

  String get album => _album;

  int get artistId => _artistId;

  String get artist => _artist;

  String get img => _img;

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(json['id'], json['title'], json['img'], json['artist'], json['artist_id'], json['album'], json['album_id'], json['mp3'], json['lyrics']);
  }
}
