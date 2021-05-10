import 'package:music_player/model/PlayingListModel.dart';
import 'package:test/test.dart';
void main() {
  test('Check exist function', () {
    PlayingListModel p = PlayingListModel();
    dynamic newSong = {
      "album": "I met you when I was 18.",
      "album_id": 2,
      "artist": "Lauv",
      "artist_id": 2,
      "id": 5,
      "img": "http://10.0.2.2:5000/img/paris-in-the-rain.jpg",
      "lyrics": "Lyric ne",
      "mp3": "http://10.0.2.2:5000/mp3/paris-in-the-rain.mp3",
      "title": "Paris in the rain"
    };
    dynamic oldSong = {
      "album": "I met you when I was 18.",
      "album_id": 2,
      "artist": "Lauv",
      "artist_id": 2,
      "id": 2,
      "img": "http://10.0.2.2:5000/img/paris-in-the-rain.jpg",
      "lyrics": "Lyric ne",
      "mp3": "http://10.0.2.2:5000/mp3/paris-in-the-rain.mp3",
      "title": "Paris in the rain"
    };
    expect(p.exist(newSong), false);
    expect(p.exist(oldSong), true);
  });
}