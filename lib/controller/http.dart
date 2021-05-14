import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const String apiUrl = '3.141.168.131:5000';

// search album by name
Future<List<dynamic>> searchAlbumsByName(keyword) async {
  final response = await http.get(Uri.http(apiUrl, 'album/by_name/' + keyword));
  if (response.statusCode == 200) {
    return json.decode(response.body)['albums'];
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}

// find album by id
Future<dynamic> searchAlbumById(albumId) async {
  final response = await http.get(Uri.http(apiUrl, 'album/' + albumId.toString()));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}

// search songs by name
Future<List<dynamic>> searchSongsByName(keyword) async {
  final response = await http.get(Uri.http(apiUrl, 'song/by_name/' + keyword));
  if (response.statusCode == 200) {
    return json.decode(response.body)['songs'];
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}

// search song by id
Future<dynamic> searchSongById(songId) async {
  final response = await http.get(Uri.http(apiUrl, songId.toString()));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}

// search newest albums
Future<List<dynamic>> searchNewestAlbums(num) async {
  final response = await http.get(Uri.http(apiUrl, 'album/newest/' + num.toString()));
  if (response.statusCode == 200) {
    return json.decode(response.body)['albums'];
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}

Future<List<dynamic>> searchRecommendedAlbums(num) async {
  final response = await http.get(Uri.http(apiUrl, 'album/recommend/' + num.toString()));
  if (response.statusCode == 200) {
    return json.decode(response.body)['albums'];
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}

// search artists by name
Future<List<dynamic>> searchArtistsByName(keyword) async {
  final response = await http.get(Uri.http(apiUrl, 'artist/by_name/' + keyword));
  if (response.statusCode == 200) {
    return json.decode(response.body)['artists'];
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}

// search artists by id
Future<dynamic> searchArtistById(artistId) async {
  final response = await http.get(Uri.http(apiUrl, 'artist/' + artistId.toString()));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}



