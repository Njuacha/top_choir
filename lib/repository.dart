import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:top_choir/utils/my_firebase_utils.dart';

import 'model/group.dart';
import 'model/song.dart';

class Repository {
  static const groupsPath = "Groups";
  static const usersPath = 'Users';

  static String groupsOwnedPath(String userId) => "$usersPath/$userId/O";

  static String groupsBelongPath(String userId) => "$usersPath/$userId/B";

  static String groupsSongsPath(String groupId) => "$groupsPath/$groupId/S";

  static FirebaseFirestore firestoreInstance() => MyFirebaseUtils.firestoreInstance;

  static Stream<QuerySnapshot<Song>> getSongsStream(String groupId) =>
      firestoreInstance()
          .collection(groupsSongsPath(groupId))
          .withConverter<Song>(
            fromFirestore: (snapshot, _) =>
                Song.fromJson(snapshot.data()!, snapshot.id),
            toFirestore: (model, _) => model.toJson(),
          )
          .snapshots();

  // TODO find a way to use the ids to get the group doc
  static Stream<QuerySnapshot<Group>> getGroupsOwnedStream(String userId) =>
      firestoreInstance()
          .collection(groupsOwnedPath(userId))
          .withConverter<Group>(
              fromFirestore: (snapshot, _) =>
                  Group.fromJson(snapshot.data()!, snapshot.id),
              toFirestore: (model, _) => model.toJson())
          .snapshots();

  static Stream<QuerySnapshot<Group>> getGroupsBelongStream(String userId) =>
      firestoreInstance()
          .collection(groupsBelongPath(userId))
          .withConverter<Group>(
              fromFirestore: (snapshot, _) =>
                  Group.fromJson(snapshot.data()!, snapshot.id),
              toFirestore: (model, _) => model.toJson())
          .snapshots();

  // TODO find a way to only save the id in groupsOwned
  static addGroup(Group group, String userId) async {
    var result = await firestoreInstance().collection(groupsPath).add(
        group.toJson());
    await firestoreInstance().collection(groupsOwnedPath(userId))
        .doc(result.id)
        .set(group.toJson());
  }

  static updateGroup(Group group, String userId) async {
    await firestoreInstance().collection(groupsPath).doc(group.id).set(group.toJson(), SetOptions(merge: true));
    await firestoreInstance().collection(groupsOwnedPath(userId)).doc(group.id).set(group.toJson());
  }

  static deleteGroup(String groupId) async {
    // delete all the songs in the group
    // TODO delete group
    // delete the group
  }

/*  static updateGroup(String groupId, Group group, String userId) async {
    await firestoreInstance().collection(groupsPath).doc(groupId).set(data)

  }*/

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

}
