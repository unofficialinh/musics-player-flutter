import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_config/flutter_config.dart';

// final String domain = FlutterConfig.get('API_URL');
final String domain = '192.168.1.6:5000';

// return List<Album>
Future<List<dynamic>> fetchAlbums(path) async {
  final response = await http.get(Uri.http('192.168.1.6:5000', path));
  if (response.statusCode == 200) {
    return json.decode(response.body)['albums'];
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}

// return Album
Future<dynamic> fetchAlbum(path) async {
  final response = await http.get(Uri.http('192.168.1.6:5000', path));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}

// return List<Song>
Future<List<dynamic>> fetchSongs(path) async {
  final response = await http.get(Uri.http('192.168.1.6:5000', path));
  if (response.statusCode == 200) {
    return json.decode(response.body)['songs'];
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}

// return Song
Future<dynamic> fetchSong(path) async {
  final response = await http.get(Uri.http('192.168.1.6:5000', path));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}

Future<List<dynamic>> fetchArtists(path) async {
  final response = await http.get(Uri.http('192.168.1.6:5000', path));
  if (response.statusCode == 200) {
    return json.decode(response.body)['artists'];
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}

// return Artist
Future<dynamic> fetchArtist(path) async {
  final response = await http.get(Uri.http('192.168.1.6:5000', path));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}



