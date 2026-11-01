class Photo {
  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  const Photo({
    required this.albumId,
    required this.id,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      albumId: json['albumId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'albumId': albumId,
    'id': id,
    'title': title,
    'url': url,
    'thumbnailUrl': thumbnailUrl,
  };

  Photo copyWith({
    int? albumId,
    int? id,
    String? title,
    String? url,
    String? thumbnailUrl,
  }) {
    return Photo(
      albumId: albumId ?? this.albumId,
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Photo &&
          albumId == other.albumId &&
          id == other.id &&
          title == other.title &&
          url == other.url &&
          thumbnailUrl == other.thumbnailUrl;

  @override
  int get hashCode => Object.hash(albumId, id, title, url, thumbnailUrl);

  @override
  String toString() => 'Photo(id: $id, albumId: $albumId, title: $title)';
}
