import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:music_player_app/models/artist.dart';
import 'package:music_player_app/models/song.dart';
import 'package:music_player_app/utils/constants.dart';

class SpotifyService {
  final Dio dio;
  final String clientId = '51f431f488704d3fb2ad68e1d9a3e72d';
  final String clientSecret = '4e0a42a85ae04a7181c11566635b8ff2';

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

  Future<List<Song>> getRecommendations() async {
    String accessToken = await _getAccessToken();

    var response = await dio.get(
      'https://api.spotify.com/v1/recommendations',
      queryParameters: {
        'seed_genres': genres,
        'limit': 100,
      },
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );

    List<Song> recommendations = [];

    for (var track in response.data['tracks']) {
      final previewUrl = track['preview_url'];
      if (previewUrl != null) {
        recommendations.add(Song(
            name: track['name'],
            songUrl: track['preview_url'],
            imageUrl: track['album']['images'][0]['url'],
            duration: track['duration_ms'],
            artist: track['artists'][0]['name'] ?? '-'));
      }
    }

    return recommendations;
  }

  Future<List<Song>> searchMusic(String query) async {
    String accessToken = await _getAccessToken();
    var response = await dio.get(
      'https://api.spotify.com/v1/search',
      queryParameters: {'q': query, 'type': 'track'},
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );

    List<Song> recommendations = [];

    if (response.data['tracks'] == null) return recommendations;

    Map<String, dynamic> tracksMap = response.data['tracks'];
    List<dynamic> tracks = tracksMap['items'];

    for (var track in tracks) {
      final previewUrl = track['preview_url'];
      if (previewUrl != null) {
        recommendations.add(Song(
            name: track['name'],
            songUrl: track['preview_url'],
            imageUrl: track['album']['images'][0]['url'],
            duration: track['duration_ms'],
            artist: track['artists'][0]['name'] ?? '-'));
      }
    }

    return recommendations;
  }

  Future<List<Song>> getPodcastRecommendations() async {
    String accessToken = await _getAccessToken();
    var response = await dio.get(
      'https://api.spotify.com/v1/episodes/512ojhOuo1ktJprKbVcKyQ', // Adjusted for podcasts
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );

    List<Song> podcastRecommendations = [];

    if (response.data['playlists'] == null) return podcastRecommendations;

    List<dynamic> playlists = response.data['playlists']['items'];
    for (var playlist in playlists) {
      // Assuming you want to collect a list of podcasts from the recommended playlists
      var playlistDetailResponse = await dio.get(
        'https://api.spotify.com/v1/playlists/${playlist['id']}/tracks',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      List<dynamic> playlistTracks = playlistDetailResponse.data['items'];
      for (var track in playlistTracks) {
        var podcastEpisode = track['track']; // Each 'track' should represent a podcast episode
        if (podcastEpisode != null) {
          podcastRecommendations.add(
            Song(
                name: podcastEpisode['name'],
                songUrl: podcastEpisode['external_urls']['spotify'],
                imageUrl: podcastEpisode['images'][0]['url'],
                // Assuming the first image is the main one for the podcast
                duration: podcastEpisode['duration_ms'],
                artist: track['artists'][0]['name'] ?? '-' // Assuming the first artist is the main one for the podcast
            ),
          );
        }
      }
    }

    return podcastRecommendations;
  }

  Future<List<Artist>> getAllArtists() async {
    List<Artist> artistsRes = [];
    String accessToken = await _getAccessToken();

    var response = await dio.get(
      'https://api.spotify.com/v1/artists',
      queryParameters: {
        'ids': artists.join(',').toString(),
      },
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );

    int index = 0;
    for (var artist in response.data['artists']) {
      artistsRes.add(
          Artist(
              id: artists[index],
              name: artist['name'],
              imageUrl: artist['images'][0]['url']
          )
      );
      index++;
    }

    return artistsRes;
  }

}