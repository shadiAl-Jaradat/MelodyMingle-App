class Artist {
  Artist({
    required this.name,
    required this.id,
    required this.imageUrl,
    required this.genres,
    required this.followers,
  });

  final int followers;
  final List<String> genres;
  final String name;
  final String id;
  final String imageUrl;

  factory Artist.fromJson(Map<String, dynamic> json) => Artist(
        name: json['name'],
        id: json['id'],
        imageUrl: json['images'] != null && json['images'].isNotEmpty ? json['images'][0]['url'] : '',
        genres: List<String>.from(json['genres'] ?? []),
        followers: json['followers'] != null ? json['followers']['total'] : 0,
      );
}
