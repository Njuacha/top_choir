import 'package:cloud_firestore/cloud_firestore.dart';

class Song {
  String id = '';
  String key;
  String title;
  String author;
  String sVerse;
  String sChorus;
  String aVerse;
  String aChorus;
  String tVerse;
  String tChorus;
  String bVerse;
  String bChorus;
  DateTime dateCreated;

  static const String idField = 'id';
  static const String keyField = 'key';
  static const String titleField = 'title';
  static const String authorField = 'author';
  static const String sVerseField = 'sVerse';
  static const String sChorusField = 'sChorus';
  static const String aVerseField = 'aVerse';
  static const String aChorusField = 'aChorus';
  static const String tVerseField = 'tVerse';
  static const String tChorusField = 'tChorus';
  static const String bVerseField = 'bVerse';
  static const String bChorusField = 'bChorus';
  static const String dateCreatedField = 'dateCreated';

  Song(
      {this.id = "",
      required this.key,
      required this.title,
      required this.author,
      required this.sVerse,
      required this.sChorus,
      required this.aVerse,
      required this.aChorus,
      required this.tVerse,
      required this.tChorus,
      required this.bVerse,
      required this.bChorus,
      required this.dateCreated});

  Song.fromJson(Map<String, Object?> json, String id)
      : this(
            id: id,
            key: json[keyField]! as String,
            title: json[titleField]! as String,
            author: json[authorField]! as String,
            sVerse: json[sVerseField]! as String,
            sChorus: json[sChorusField]! as String,
            aVerse: json[aVerseField]! as String,
            aChorus: json[aChorusField]! as String,
            tVerse: json[tVerseField]! as String,
            tChorus: json[tChorusField]! as String,
            bVerse: json[bVerseField]! as String,
            bChorus: json[bChorusField]! as String,
            dateCreated: (json[dateCreatedField]! as Timestamp).toDate());

  Map<String, Object?> toJson() {
    return {
      keyField: key,
      titleField: title,
      authorField: author,
      sVerseField: sVerse,
      sChorusField: sChorus,
      aVerseField: aVerse,
      aChorusField: aChorus,
      tVerseField: tVerse,
      tChorusField: tChorus,
      bVerseField: bVerse,
      bChorusField: bChorus,
      dateCreatedField: dateCreated
    };
  }
}
