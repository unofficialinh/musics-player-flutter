import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';

class PlayingListModel extends ChangeNotifier {
  List<dynamic> _songs;
  AudioPlayer audioPlayer;
  ConcatenatingAudioSource audioSource;

  PlayingListModel() {
    _songs = [];
    audioPlayer = new AudioPlayer();
  }

  // p.songs to get
  List<dynamic> get songs {
    return _songs;
  }

  void setPlaylist(List<dynamic> songs, int currentIndex) {
    this._songs = songs;
    audioSource = ConcatenatingAudioSource(
        children: List.generate(_songs.length, (index) => AudioSource.uri(Uri.parse(_songs[index]['mp3'])))
    );
    audioPlayer.setAudioSource(audioSource, initialIndex: currentIndex);
    notifyListeners();
  }

  // Check a song exist in the playing list by checking "id"
  bool exist(dynamic song) {
    dynamic result = this._songs.firstWhere((element) => element["id"] == song["id"], orElse: () => null);
    return (result != null);
  }

  // Return false if song exist, true if add success
  bool addBack(dynamic newSong) {
    if (_songs.length == 0) {
      audioSource = ConcatenatingAudioSource(
          children: List.generate(_songs.length, (index) => AudioSource.uri(Uri.parse(_songs[index]['mp3'])))
      );
      audioPlayer.setAudioSource(audioSource);
    }
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

  void reset() {
    _songs = [];
    audioPlayer = new AudioPlayer();
  }
}
