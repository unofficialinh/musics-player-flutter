import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String> getDownloadPath() async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> getMetadataFile() async {
  final path = await getDownloadPath();
  final file = File('$path/metadata.txt');
  return file;
}
Future<List<dynamic>> getDownloadedSong() async {
  final file = await getMetadataFile();

  // Read the file
  final String contents = await file.readAsString();
  // print(contents);
  return jsonDecode(contents)['songs'];
}

Future<File> addDownloadedSong(dynamic newSong) async {
  final file = await getMetadataFile();

  final String contents = await file.readAsString();
  print("The file content is: " + contents);
  // Map<String, dynamic> songMap = jsonDecode(contents);
  // songMap['songs'].add(newSong);
  //
  // // Write the file
  // return file.writeAsString(jsonEncode(songMap));
  return file.writeAsString(contents);
}
