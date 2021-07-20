import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String> getDownloadPath() async {
  final Directory directory = await getApplicationDocumentsDirectory();
  // print(directory.path);
  return directory.path;
}

Future<File> getMetadataFile() async {
  final path = await getDownloadPath();
  final file = await File('$path/metadata.txt').create(recursive: true);

  // Check if file is empty => create file
  final String contents = await file.readAsString();
  if (contents == '') {
    file.writeAsString('{"songs":[]}');
  }

  return file;
}

Future<List<dynamic>> getDownloadedSong() async {
  final file = await getMetadataFile();

  // Read the file
  final String contents = await file.readAsString();
  // print(contents);
  return jsonDecode(contents)['songs'];
}

// return false if song has downloaded before
// return true for downloaded succesfully
Future<bool> addDownloadedSong(dynamic _newSong) async {
  dynamic newSong = Map<String, dynamic>.from(_newSong);

  final file = await getMetadataFile();

  final String contents = await file.readAsString();
  Map<String, dynamic> songMap = jsonDecode(contents);
  // check if song is in metadata.txt aka have downloaded?
  for (var i = 0; i < songMap["songs"].length; i++) {
    if (songMap["songs"][i]["id"] == newSong["id"]) return false;
  }
  // convert to local uri
  String dir = await getDownloadPath();
  newSong['img'] =
      '${dir}/${newSong['img'].substring(newSong['img'].lastIndexOf("/") + 1)}';
  newSong['mp3'] =
      '${dir}/${newSong['mp3'].substring(newSong['mp3'].lastIndexOf("/") + 1)}';
  songMap['songs'].add(newSong);
  // Write the file
  file.writeAsString(jsonEncode(songMap));
  return true;
}
