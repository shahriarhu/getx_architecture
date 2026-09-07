import 'package:flutter/foundation.dart';

/// Demo domain model.
///
/// Hand-written `fromJson` keeps the starter free of a code-generation step.
/// If a project grows past a handful of models, adding `json_serializable` is
/// a drop-in change — the call sites do not move.
@immutable
class Article {
  const Article({
    required this.id,
    required this.title,
    required this.body,
    this.authorId,
  });

  factory Article.fromJson(Map<String, dynamic> json) => Article(
    id: '${json['id'] ?? ''}',
    title: (json['title'] ?? '') as String,
    body: (json['body'] ?? '') as String,
    authorId: json['userId'] == null ? null : '${json['userId']}',
  );

  final String id;
  final String title;
  final String body;
  final String? authorId;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'userId': authorId,
  };

  bool matches(String query) {
    final needle = query.toLowerCase();
    return title.toLowerCase().contains(needle) ||
        body.toLowerCase().contains(needle);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Article && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
