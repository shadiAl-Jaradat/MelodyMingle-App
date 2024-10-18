class Song {
  final String name;
  final String songUrl;
  final String imageUrl;
  final int duration;
  final String artist;

  Song({
    required this.name,
    required this.songUrl,
    required this.imageUrl,
    required this.duration,
    required this.artist,
  });

  factory Song.fromJson(Map<String, dynamic> json) => Song(
        name: json['name'],
        songUrl: json['preview_url'] ?? '',
        imageUrl: json['album'] != null && json['album']['images'] != null && json['album']['images'].isNotEmpty
            ? json['album']['images'][0]['url']
            : '',
        duration: json['duration_ms'],
        artist: (json['artists'] != null && json['artists'].isNotEmpty) ? json['artists'][0]['name'] : '-',
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'songUrl': songUrl,
        'imageUrl': imageUrl,
        'duration': duration,
        'artist': artist,
      };
}
