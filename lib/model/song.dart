import 'package:cloud_firestore/cloud_firestore.dart';

class Song {
  String id = '';
  String key;
  String title;
  String author;
  String verseSolfas;
  String verseLyrics;
  String chorusSolfas;
  String chorusLyrics;
  DateTime dateCreated;

  static const String idField = 'id';
  static const String keyField = 'key';
  static const String titleField = 'title';
  static const String authorField = 'author';
  static const String verseSolfasField = 'verseSolfas';
  static const String verseLyricsField = 'verseLyrics';
  static const String chorusSolfasField = 'chorusSolfas';
  static const String chorusLyricsField = 'chorusLyrics';
  static const String dateCreatedField = 'dateCreated';

  Song(
      {this.id = "",
      required this.key,
      required this.title,
      required this.author,
      required this.verseSolfas,
      required this.verseLyrics,
      required this.chorusSolfas,
      required this.chorusLyrics,
      required this.dateCreated});

  Song.fromJson(Map<String, Object?> json, String id)
      : this(
            id: id,
            key: json[keyField]! as String,
            title: json[titleField]! as String,
            author: json[authorField]! as String,
            verseSolfas: json[verseSolfasField]! as String,
            verseLyrics: json[verseLyricsField]! as String,
            chorusLyrics: json[chorusSolfasField]! as String,
            chorusSolfas: json[chorusLyricsField]! as String,
            dateCreated: (json[dateCreatedField]! as Timestamp).toDate());

  Map<String, Object?> toJson() {
    return {
      keyField: key,
      titleField: title,
      authorField: author,
      verseSolfasField: verseSolfas,
      verseLyricsField: verseLyrics,
      chorusSolfasField: chorusSolfas,
      chorusLyricsField: chorusLyrics,
      dateCreatedField: dateCreated
    };
  }
}
