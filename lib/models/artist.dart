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

  List<String> get ss => ['sssss', 'sssss', 'sssss', 'sssss', 'sssss', 'sssss', 'sssss', 'sssss', 'sssss', 'sssss', 'sssss', 'sssss', 'sssss', 'sssss',  ];
}

//followers -> int -> artist['followers']['total']
//genres => List<String> -> artist['genres']