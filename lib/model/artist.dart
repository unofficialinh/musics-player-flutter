class Artist {
  int id;
  String name;
  String img;
  String new_albums;
  String popular_songs;

  Artist(
      {this.id,
        this.name,
        this.img,
        this.new_albums,
        this.popular_songs});

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
        id: json['id'],
        name: json['name'],
        img: json['img'],
        new_albums: json['new_albums'],
        popular_songs: json['popular_songs'],
    );
  }
}
