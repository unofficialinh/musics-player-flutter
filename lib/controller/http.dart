import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

const String apiUrl = 'ec2-3-15-191-150.us-east-2.compute.amazonaws.com';
// TODO: do main case first (200 status code), solve alternative case later (404, 400, 500 error)
//login
Future<dynamic> login(email, password) async {
  final response = await http.post(
    Uri.http(apiUrl, 'user/login'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'email': email,
      'password': password,
    }),
  );
  if (response.statusCode != null) {
    return json.decode(response.body);
  } else {
    throw Exception('Unable to connect to REST API');
  }
}

//register
Future<dynamic> register(email, password) async {
  final response = await http.post(
    Uri.http(apiUrl, 'user/register'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'email': email,
      'password': password,
    }),
  );
  if (response.statusCode != null) {
    return response;
  } else {
    throw Exception('Unable to connect to REST API');
  }
}

//logout
Future<dynamic> logout() async {
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  final response = await http.get(Uri.http(apiUrl, 'user/logout'), headers: {
    HttpHeaders.authorizationHeader: 'Bearer ' + token,
  });
  if (response.statusCode != null) {
    return json.decode(response.body)['result'];
  } else {
    throw Exception('Unable to connect to REST API');
  }
}

// search album by name
Future<List<dynamic>> searchAlbumsByName(keyword) async {
  final response = await http.get(Uri.http(apiUrl, 'albums', {"q": keyword}));
  if (response.statusCode != null) {
    return json.decode(response.body)['albums'];
  } else {
    throw Exception('Unable to connect to REST API');
  }
}

// find album by id
Future<dynamic> searchAlbumById(albumId) async {
  final response =
      await http.get(Uri.http(apiUrl, 'album/' + albumId.toString()));
  if (response.statusCode != null) {
    return json.decode(response.body);
  } else {
    throw Exception('Unable to connect to REST API');
  }
}

// search songs by name
Future<List<dynamic>> searchSongsByName(keyword) async {
  final response = await http.get(Uri.http(apiUrl, 'songs', {"q": keyword}));
  if (response.statusCode != null) {
    return json.decode(response.body)['songs'];
  } else {
    throw Exception('Unable to connect to REST API');
  }
}

// search song by id
Future<dynamic> searchSongById(songId) async {
  final response = await http.get(Uri.http(apiUrl, songId.toString()));
  if (response.statusCode != null) {
    return json.decode(response.body);
  } else {
    throw Exception('Unable to connect to REST API');
  }
}

// search newest albums
Future<List<dynamic>> searchNewestAlbums(num) async {
  final response =
      await http.get(Uri.http(apiUrl, 'album/newest/' + num.toString()));
  if (response.statusCode != null) {
    return json.decode(response.body)['albums'];
  } else {
    throw Exception('Unable to connect to REST API');
  }
}

Future<List<dynamic>> searchRecommendedAlbums(num) async {
  final response =
      await http.get(Uri.http(apiUrl, 'album/recommend/' + num.toString()));
  if (response.statusCode != null) {
    return json.decode(response.body)['albums'];
  } else {
    throw Exception('Unable to connect to REST API');
  }
}

// search artists by name
Future<List<dynamic>> searchArtistsByName(keyword) async {
  final response =
      await http.get(Uri.http(apiUrl, 'artists', {"q": keyword}));
  if (response.statusCode != null) {
    return json.decode(response.body)['artists'];
  } else {
    throw Exception('Unable to connect to REST API');
  }
}

// search artists by id
Future<dynamic> searchArtistById(artistId) async {
  final response =
      await http.get(Uri.http(apiUrl, 'artist/' + artistId.toString()));
  if (response.statusCode != null) {
    return json.decode(response.body);
  } else {
    throw Exception('Unable to connect to REST API');
  }
}

// get user profile
Future<dynamic> getUserProfile() async {
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  final response = await http.get(Uri.http(apiUrl, 'user/profile'), headers: {
    HttpHeaders.authorizationHeader: 'Bearer ' + token,
  });
  if (response.statusCode != null) {
    return json.decode(response.body);
  } else {
    throw Exception('Unable to connect to REST API');
  }
}

// update user profile
Future<dynamic> updateUserProfile(name, age) async {
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  final response = await http.post(
    Uri.http(apiUrl, 'user/profile'),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Bearer ' + token,
    },
    body: jsonEncode(<String, dynamic>{
      'name': name,
      'age': age,
    }),
  );
  if (response.statusCode != null) {
    return json.decode(response.body)['result'];
  } else {
    throw Exception('Unable to connect to REST API');
  }
}

// update user password
Future<dynamic> updateUserPassword(_old, _new, _confirm) async {
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  final response = await http.post(
    Uri.http(apiUrl, 'user/profile/password'),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Bearer ' + token,
    },
    body: jsonEncode(
        <String, dynamic>{'old_password': _old, 'new_password': _new}),
  );
  if (response.statusCode != null) {
    return json.decode(response.body)['result'];
  } else {
    throw Exception('Unable to connect to REST API');
  }
}

// create playlist
Future<dynamic> createPlaylist(title) async {
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  final response = await http.post(
      Uri.http(apiUrl, 'playlist'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer ' + token,
      },
      body: jsonEncode(
        <String, dynamic>{'title': title}),
  );
  if (response.statusCode != null) {
    return json.decode(response.body)['result'];
  } else {
    throw Exception('Unable to connect to REST API');
  }
}

// get playlist by user
Future<List<dynamic>> getPlaylist() async {
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  final response =
      await http.get(Uri.http(apiUrl, 'playlists'), headers: {
    HttpHeaders.authorizationHeader: 'Bearer ' + token,
  });
  if (response.statusCode != null) {
    return json.decode(response.body)['playlists'];
  } else {
    throw Exception('Unable to connect to REST API');
  }
}

// get playlist by id
Future<dynamic> getPlaylistById(playlistId) async {
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  final response = await http
      .get(Uri.http(apiUrl, 'playlist/' + playlistId.toString()), headers: {
    HttpHeaders.authorizationHeader: 'Bearer ' + token,
  });
  if (response.statusCode != null) {
    return json.decode(response.body);
  } else {
    throw Exception('Unable to connect to REST API');
  }
}

// add song to playlist
Future<dynamic> addSongToPlaylist(playlistId, songId) async {
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  final response = await http.put(
      Uri.http(apiUrl, 'playlist/' + playlistId.toString() + '/song/' + songId.toString()),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer ' + token,
      });
  if (response.statusCode != null) {
    return json.decode(response.body)['result'];
  } else {
    throw Exception('Unable to connect to REST API');
  }
}

// delete song from playlist
Future<dynamic> deleteSongFromPlaylist(playlistId, songId) async {
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  final response = await http.delete(
      Uri.http(apiUrl, 'playlist/' + playlistId.toString() + '/song/' + songId.toString()),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer ' + token,
      });
  if (response.statusCode != null) {
    return json.decode(response.body)['result'];
  } else {
    throw Exception('Unable to connect to REST API');
  }
}

// delete playlist
Future<dynamic> deletePlaylist(playlistId) async {
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  final response = await http.delete(
      Uri.http(apiUrl, 'playlist/' + playlistId.toString()),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer ' + token,
      });
  if (response.statusCode != null) {
    return json.decode(response.body)['result'];
  } else {
    throw Exception('Unable to connect to REST API');
  }
}

// add song to favorite
Future<dynamic> addSongToFavorite(songId) async {
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  final response = await http.put(
      Uri.http(apiUrl, 'favorite/song/' + songId.toString()),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer ' + token,
      });
  if (response.statusCode != null) {
    return json.decode(response.body)['result'];
  } else {
    throw Exception('Unable to connect to REST API');
  }
}

// delete song from favorite
Future<dynamic> deleteSongFromFavorite(songId) async {
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  final response = await http.delete(
      Uri.http(apiUrl, 'favorite/song/' + songId.toString()),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer ' + token,
      });
  if (response.statusCode != null) {
    return json.decode(response.body)['result'];
  } else {
    throw Exception('Unable to connect to REST API');
  }
}

// get favorite songs
Future<List<dynamic>> getFavoriteSong() async {
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  final response = await http.get(Uri.http(apiUrl, 'favorite/songs'), headers: {
    HttpHeaders.authorizationHeader: 'Bearer ' + token,
  });
  if (response.statusCode != null) {
    return json.decode(response.body)['songs'];
  } else {
    throw Exception('Unable to connect to REST API');
  }
}

// get favorite albums
Future<List<dynamic>> getFavoriteAlbum() async {
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  final response =
      await http.get(Uri.http(apiUrl, 'favorite/albums'), headers: {
    HttpHeaders.authorizationHeader: 'Bearer ' + token,
  });
  if (response.statusCode != null) {
    return json.decode(response.body)['albums'];
  } else {
    throw Exception('Unable to connect to REST API');
  }
}

// get favorite artists
Future<List<dynamic>> getFavoriteArtist() async {
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  final response =
      await http.get(Uri.http(apiUrl, 'favorite/artists'), headers: {
    HttpHeaders.authorizationHeader: 'Bearer ' + token,
  });
  if (response.statusCode != null) {
    return json.decode(response.body)['artists'];
  } else {
    throw Exception('Unable to connect to REST API');
  }
}

// check song is in favorite
Future<dynamic> isFavorite(songId) async {
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  final response = await http.get(Uri.http(apiUrl, 'favorite/songs'), headers: {
    HttpHeaders.authorizationHeader: 'Bearer ' + token,
  });
  if (response.statusCode != null) {
    dynamic songs = json.decode(response.body)['songs'];
    for (int i = 0; i < songs.length; i++) {
      if (songId == songs[i]["id"]) {
        return true;
      }
    }
    // No song in favorite list match songId
    return false;
  } else {
    throw Exception('Unable to connect to REST API');
  }
}
