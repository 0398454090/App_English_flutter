class Topic {
  final String id;
  final List<dynamic> wordId;
  final String name;
  final String folderId;
  final bool isPublic;

  Topic({
    required this.id,
    required this.wordId,
    required this.name,
    required this.folderId,
    required this.isPublic,
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'],
      wordId: json['wordId'],
      name: json['name'],
      folderId: json['folderId'],
      isPublic: json['public'],
    );
  }
}
