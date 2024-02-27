import 'package:cloud_firestore/cloud_firestore.dart';

class Song {
  String id = '';
  String key;
  String title;
  String author;
  String verse;
  String chorus;
  DateTime dateCreated;

  static const String idField = 'id';
  static const String keyField = 'key';
  static const String titleField = 'title';
  static const String authorField = 'author';
  static const String verseField = 'verse';
  static const String chorusField = 'chorus';
  static const String dateCreatedField = 'dateCreated';

  Song(
      {this.id = "",
      required this.key,
      required this.title,
      required this.author,
      required this.verse,
      required this.chorus,
      required this.dateCreated});

  Song.fromJson(Map<String, Object?> json, String id)
      : this(
            id: id,
            key: json[keyField]! as String,
            title: json[titleField]! as String,
            author: json[authorField]! as String,
            verse: json[verseField]! as String,
            chorus: json[chorusField]! as String,
            dateCreated: (json[dateCreatedField]! as Timestamp).toDate());

  Map<String, Object?> toJson() {
    return {
      keyField: key,
      titleField: title,
      authorField: author,
      verseField: verse,
      chorusField: chorus,
      dateCreatedField: dateCreated
    };
  }
}
