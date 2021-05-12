import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';

class PlayingListModel extends ChangeNotifier {
  List<dynamic> _songs;
  AudioPlayer audioPlayer;
  ConcatenatingAudioSource audioSource;
  PlayingListModel() {
     // TODO: add some sample songs, delete later
    _songs = [
      {
        "id": 1,
        "title": "To the moon",
        "img": "http://10.0.2.2:5000/img/to-the-moon.jpg",
        "mp3": "http://10.0.2.2:5000/mp3/to-the-moon.mp3",
        "artist_id": 1,
        "artist": "Hooligan",
        "album_id": 1,
        "album": "To the moon",
        "lyrics": "Lyric ne"
      },
      {
        "album": "I met you when I was 18.",
        "album_id": 2,
        "artist": "Lauv",
        "artist_id": 2,
        "id": 2,
        "img": "http://10.0.2.2:5000/img/paris-in-the-rain.jpg",
        "lyrics": "Lyric ne",
        "mp3": "http://10.0.2.2:5000/mp3/paris-in-the-rain.mp3",
        "title": "Paris in the rain"
      },
    ];
    audioSource = ConcatenatingAudioSource(
        children: List.generate(_songs.length, (index) => AudioSource.uri(Uri.parse(_songs[index]['mp3'])))
    );
    // end TODO

    audioPlayer = new AudioPlayer();
    audioPlayer.setAudioSource(audioSource);
    notifyListeners();
  }

  // p.songs to get
  List<dynamic> get songs {
    return _songs;
  }

  // p.songs = ... to set
  set songs(List<dynamic> songs) {
    this._songs = songs;
    notifyListeners();
  }

  // Check a song exist in the playing list by checking "id"
  bool exist(dynamic song) {
    dynamic result = this._songs.firstWhere((element) => element["id"] == song["id"], orElse: () => null);
    return (result != null);
  }

  // Return false if song exist, true if add success
  bool addBack(dynamic newSong) {
    if (!exist(newSong)) {
      _songs.add(newSong);
      audioSource.add(AudioSource.uri(Uri.parse(newSong['mp3'])));
      notifyListeners();
      return true;
    }
    else return false;
  }

  // Remove _songs[index]
  void removeAt(int index) {
    _songs.removeAt(index);
    audioSource.removeAt(index);
    notifyListeners();
  }
}
