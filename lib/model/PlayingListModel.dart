import 'package:flutter/cupertino.dart';

class PlayingListModel extends ChangeNotifier {
  List<dynamic> _songs;
  PlayingListModel();
  PlayingListModel.fromList(List<dynamic> songs) {
    _songs = songs;
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

}
