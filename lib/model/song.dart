
import 'package:cloud_firestore/cloud_firestore.dart';

class Song {
  String title;
  String author;
  DateTime dateCreated;

  Song({required this.title, required this.author, required this.dateCreated});

  Song.fromJson(Map<String, Object?> json)
      : this(
            title: json['title']! as String,
            author: json['author']! as String,
            dateCreated: (json['dateCreated']! as Timestamp).toDate());

  Map<String, Object?> toJson() {
    return {'title': title, 'author': author, 'dateCreated': dateCreated};
  }


}


