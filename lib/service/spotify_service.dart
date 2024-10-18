import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:music_player_app/service/models/artist.dart';
import 'package:music_player_app/service/models/song.dart';
import 'package:music_player_app/utils/constants.dart';

class SpotifyService {
  final Dio dio;

  SpotifyService(this.dio);

  Future<String> _getAccessToken() async {
    final String credentials = base64Encode(utf8.encode('$clientId:$clientSecret'));
    final response = await dio.post(
      'https://accounts.spotify.com/api/token',
      data: 'grant_type=client_credentials',
      options: Options(headers: {'Authorization': 'Basic $credentials', 'Content-Type': 'application/x-www-form-urlencoded'}),
    );
    return response.data['access_token'];
  }

  Future<List<Song>> getRecommendations({required List<String> genres, int limit = 100}) async {
    String accessToken = await _getAccessToken();

    final response = await dio.get(
      'https://api.spotify.com/v1/recommendations',
      queryParameters: {
        'seed_genres': genres,
        'limit': limit,
      },
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );

    return (response.data['tracks'] as List).where((track) => track['preview_url'] != null).map((track) => Song.fromJson(track)).toList();
  }

  Future<List<Song>> searchMusic(String query) async {
    String accessToken = await _getAccessToken();
    final response = await dio.get(
      'https://api.spotify.com/v1/search',
      queryParameters: {'q': query, 'type': 'track'},
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );

    if (response.data['tracks'] == null) return [];

    return (response.data['tracks']['items'] as List)
        .where((track) => track['preview_url'] != null)
        .map((track) => Song.fromJson(track))
        .toList();
  }

  Future<List<Artist>> getAllArtists(List<String> artistIds) async {
    if (artistIds.isEmpty) return [];
    String accessToken = await _getAccessToken();

    final response = await dio.get(
      'https://api.spotify.com/v1/artists',
      queryParameters: {
        'ids': artistIds.join(','),
      },
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );

    return (response.data['artists'] as List).map((artistJson) => Artist.fromJson(artistJson)).toList();
  }
}
