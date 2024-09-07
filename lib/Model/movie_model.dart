class Movie {
  final int id;
  final String title;
  final String originalTitle;
  final String overview;
  final String releaseDate;
  final String backdropPath;
  final String posterPath;
  final double voteAverage;
  final int voteCount;
  final List<int> genreIds;
  final double popularity;
  final bool adult;
  final bool video;

  Movie({
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.overview,
    required this.releaseDate,
    required this.backdropPath,
    required this.posterPath,
    required this.voteAverage,
    required this.voteCount,
    required this.genreIds,
    required this.popularity,
    required this.adult,
    required this.video,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    List<int> parseGenreIds(dynamic genreIdsJson) {
      if (genreIdsJson is List) {
        return List<int>.from(genreIdsJson);
      } else if (genreIdsJson is String) {
        return genreIdsJson
            .split(',')
            .map((id) => int.tryParse(id.trim()) ?? 0)
            .toList();
      } else {
        return [];
      }
    }

    return Movie(
      id: json['id'],
      title: json['title'],
      originalTitle: json['original_title'],
      overview: json['overview'],
      releaseDate: json['release_date'],
      backdropPath: json['backdrop_path'],
      posterPath: json['poster_path'],
      voteAverage: (json['vote_average'] as num).toDouble(),
      voteCount: json['vote_count'],
      genreIds: parseGenreIds(json['genre_ids']),
      popularity: (json['popularity'] as num).toDouble(),
      adult: json['adult'] == 1,
      video: json['video'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'original_title': originalTitle,
      'overview': overview,
      'release_date': releaseDate,
      'backdrop_path': backdropPath,
      'poster_path': posterPath,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'genre_ids': genreIds.join(','), // Convert List<int> to comma-separated String
      'popularity': popularity,
      'adult': adult ? 1 : 0,
      'video': video ? 1 : 0,
    };
  }
}
