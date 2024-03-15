import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:top_choir/utils/my_firebase_utils.dart';
import 'package:uuid/uuid.dart';

import 'model/group.dart';
import 'model/song.dart';

class Repository {
  static const groupsPath = "Groups";
  static const usersPath = 'Users';

  static String groupsOwnedPath(String userId) => "$usersPath/$userId/O";

  static String groupsBelongPath(String userId) => "$usersPath/$userId/B";

  static String groupsSongsPath(String groupId) => "$groupsPath/$groupId/S";

  static FirebaseFirestore firestoreInstance() =>
      MyFirebaseUtils.firestoreInstance;

  static FirebaseStorage firebaseStorage() => MyFirebaseUtils.storageInstance;

  static Stream<QuerySnapshot<Song>> getSongsStream(String groupId) =>
      firestoreInstance()
          .collection(groupsSongsPath(groupId))
          .withConverter<Song>(
            fromFirestore: (snapshot, _) =>
                Song.fromJson(snapshot.data()!, snapshot.id),
            toFirestore: (model, _) => model.toJson(),
          )
          .snapshots();

  static Stream<List<Group>> getGroupsOwnedStream(String userId) =>
      firestoreInstance()
          .collection(groupsOwnedPath(userId))
          .withConverter<Group>(
              fromFirestore: (snapshot, _) =>
                  Group.fromJson(snapshot.data()!, snapshot.id),
              toFirestore: (model, _) => model.toJson())
          .snapshots()
          .map((event) {
        List<Group> groups = [];
        for (var doc in event.docs) {
          groups.add(doc.data());
        }
        return groups;
      });

  static Stream<List<Group>> getGroupsBelongStream(String userId) =>
      firestoreInstance()
          .collection(groupsBelongPath(userId))
          .withConverter<Group>(
              fromFirestore: (snapshot, _) =>
                  Group.fromJson(snapshot.data()!, snapshot.id),
              toFirestore: (model, _) => model.toJson())
          .snapshots()
          .asyncMap((event) async {
        List<Group> groups = [];
        for (var doc in event.docs) {
          try {
            var group = doc.data();
            var actualGroupDoc = await firestoreInstance()
                .collection(groupsPath)
                .doc(group.id)
                .get();
            var actualGroup = Group.fromJson(actualGroupDoc.data()!, group.id);
            groups.add(actualGroup);
          } catch (e, stacktrace) {
            log('error is loading groups belong: ${stacktrace.toString()}');
          }
        }
        return groups;
      });

  static Future<String> addGroup(Group group, String userId) async {
    var result =
        await firestoreInstance().collection(groupsPath).add(group.toJson());
    await firestoreInstance()
        .collection(groupsOwnedPath(userId))
        .doc(result.id)
        .set(group.toJson());
    return result.id;
  }

  static updateGroup(Group group, String userId) async {
    await firestoreInstance()
        .collection(groupsPath)
        .doc(group.id)
        .set(group.toJson(), SetOptions(merge: true));
    await firestoreInstance()
        .collection(groupsOwnedPath(userId))
        .doc(group.id)
        .set(group.toJson(), SetOptions(merge: true));
  }

  static Future<bool> isGroupExist(String id) async {
    var doc = await firestoreInstance().collection(groupsPath).doc(id).get();
    return doc.exists;
  }

  static deleteGroup(String groupId, String userId) async {
    // delete all the songs in the group
    var querySnapshot =
        await firestoreInstance().collection(groupsSongsPath(groupId)).get();
    for (final element in querySnapshot.docs) {
      await element.reference.delete();
    }
    // delete the group
    await firestoreInstance().collection(groupsPath).doc(groupId).delete();
    // delete group at groupOwned collection
    await firestoreInstance()
        .collection(groupsOwnedPath(userId))
        .doc(groupId)
        .delete();
  }

  static addSong(Song song, String groupId) async {
    await firestoreInstance()
        .collection(groupsSongsPath(groupId))
        .add(song.toJson());
  }

  static updateSong(String id, Song song, String groupId) async {
    await firestoreInstance()
        .collection(groupsSongsPath(groupId))
        .doc(id)
        .set(song.toJson());
  }

  static deleteSong(String id, String groupId) {
    firestoreInstance().collection(groupsSongsPath(groupId)).doc(id).delete();
  }

  static void addToGroup(String groupId) {
    final userId = MyFirebaseUtils.userId;
    if (userId != null) {
      firestoreInstance()
          .collection(groupsBelongPath(userId))
          .doc(groupId)
          .set({});
    }
  }

  static Future<String> uploadGroupPic(File file, String picturePath) async {
    var storageRef = firebaseStorage().ref();

    var uniquePath = const Uuid().v4();
    Reference groupPicRef;
    if (picturePath.isEmpty) {
      groupPicRef = storageRef.child("GroupPics/$uniquePath");
    } else {
      groupPicRef = firebaseStorage().refFromURL(picturePath);
    }
    await groupPicRef.putFile(file);
    return groupPicRef.getDownloadURL();
  }
}
