import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const String apiUrl = '3.141.168.131:5000';

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
  if (response.statusCode == 200) {
    return json.decode(response.body)['token'];
  } else {
    throw Exception('Unable to fetch products from the REST API');
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
  if (response.statusCode == 200) {
    return json.decode(response.body)['result'];
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}

//logout
Future<dynamic> logout() async {
  final response =
  await http.get(Uri.http(apiUrl, 'user/logout'));
  if (response.statusCode == 200) {
    return json.decode(response.body)['result'];
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}

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
  final response =
      await http.get(Uri.http(apiUrl, 'album/' + albumId.toString()));
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
  final response =
      await http.get(Uri.http(apiUrl, 'album/newest/' + num.toString()));
  if (response.statusCode == 200) {
    return json.decode(response.body)['albums'];
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}

Future<List<dynamic>> searchRecommendedAlbums(num) async {
  final response =
      await http.get(Uri.http(apiUrl, 'album/recommend/' + num.toString()));
  if (response.statusCode == 200) {
    return json.decode(response.body)['albums'];
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}

// search artists by name
Future<List<dynamic>> searchArtistsByName(keyword) async {
  final response =
      await http.get(Uri.http(apiUrl, 'artist/by_name/' + keyword));
  if (response.statusCode == 200) {
    return json.decode(response.body)['artists'];
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}

// search artists by id
Future<dynamic> searchArtistById(artistId) async {
  final response =
      await http.get(Uri.http(apiUrl, 'artist/' + artistId.toString()));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}

// get user profile
Future<dynamic> getUserProfile() async {
  final response = await http.get(Uri.http(apiUrl, 'user/profile'));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}

// update user profile
Future<dynamic> updateUserProfile(name, age) async {
  final response = await http.post(
    Uri.http(apiUrl, 'user/profile'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'name': name,
      'age': age,
    }),
  );
  if (response.statusCode == 200) {
    return json.decode(response.body)['result'];
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}

// update user password
Future<dynamic> updateUserPassword(_old, _new, _confirm) async {
  final response = await http.post(
    Uri.http(apiUrl, 'user/change_password'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(
        <String, dynamic>{'old': _old, 'new': _new, 'confirm': _confirm}),
  );
  if (response.statusCode == 200) {
    return json.decode(response.body)['result'];
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}

// create playlist
Future<dynamic> createPlaylist(title) async {
  final response = await http
      .get(Uri.http(apiUrl, 'playlist/create', {'title': title.toString()}));
  if (response.statusCode == 200) {
    print(json.decode(response.body));
    return json.decode(response.body)['result'];
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}

// get playlist by user
Future<List<dynamic>> getPlaylist() async {
  final response = await http.get(Uri.http(apiUrl, 'playlist/get_by_user'));
  if (response.statusCode == 200) {
    return json.decode(response.body)['playlists'];
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}

// get playlist by id
Future<dynamic> getPlaylistById(playlistId) async {
  final response =
      await http.get(Uri.http(apiUrl, 'playlist/' + playlistId.toString()));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}

// add song to playlist
Future<dynamic> addSongToPlaylist(playlistId, songId) async {
  final response = await http.get(Uri.http(
      apiUrl,
      'playlist/' + playlistId.toString() + '/add_song',
      {'song_id': songId.toString()}));
  if (response.statusCode == 200) {
    return json.decode(response.body)['result'];
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}

// delete song from playlist
Future<dynamic> deleteSongFromPlaylist(playlistId, songId) async {
  final response = await http.get(Uri.http(
      apiUrl,
      'playlist/' + playlistId.toString() + '/delete_song',
      {'song_id': songId.toString()}));
  if (response.statusCode == 200) {
    return json.decode(response.body)['result'];
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}

// delete playlist
Future<dynamic> deletePlaylist(playlistId) async {
  final response = await http
      .get(Uri.http(apiUrl, 'playlist/' + playlistId.toString() + '/delete'));
  if (response.statusCode == 200) {
    return json.decode(response.body)['result'];
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}

// add song to favorite
Future<dynamic> addSongToFavorite(songId) async {
  final response = await http
      .get(Uri.http(apiUrl, 'favorite/add_song', {'song_id': songId.toString()}));
  if (response.statusCode == 200) {
    return json.decode(response.body)['result'];
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}

// delete song from favorite
Future<dynamic> deleteSongFromFavorite(songId) async {
  final response = await http.get(
      Uri.http(apiUrl, 'favorite/delete_song', {'song_id': songId.toString()}));
  if (response.statusCode == 200) {
    return json.decode(response.body)['result'];
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}

// get favorite songs
Future<List<dynamic>> getFavoriteSong() async {
  final response = await http.get(Uri.http(apiUrl, 'favorite/songs'));
  if (response.statusCode == 200) {
    return json.decode(response.body)['songs'];
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}

// get favorite albums
Future<List<dynamic>> getFavoriteAlbum() async {
  final response = await http.get(Uri.http(apiUrl, 'favorite/albums'));
  if (response.statusCode == 200) {
    return json.decode(response.body)['albums'];
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}

// get favorite artists
Future<List<dynamic>> getFavoriteArtist() async {
  final response = await http.get(Uri.http(apiUrl, 'favorite/artists'));
  if (response.statusCode == 200) {
    return json.decode(response.body)['artists'];
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}

// check song is in favorite
// TODO: add to API
Future<dynamic> isFavorite(songId) async {
  return true;
}
