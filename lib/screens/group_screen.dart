import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:top_choir/reusable_components/common_center_text.dart';
import 'package:top_choir/screens/add_song_screen.dart';
import 'package:top_choir/repository.dart';
import 'package:top_choir/screens/view_song_screen.dart';
import 'package:top_choir/utils/my_encryption_utils.dart';
import 'package:top_choir/utils/my_navigator_utils.dart';

import '../model/group.dart';
import '../model/song.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key, required this.group, required this.isOwner});

  final Group group;
  final bool isOwner;

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  @override
  Widget build(BuildContext context) {
    final group = widget.group;
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.group.name),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        actions: [
          IconButton(
              onPressed: () {
                var groupCode = MyEncryptionUtils.createGroupCode(group.id);
                Clipboard.setData(ClipboardData(text: groupCode)).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "Group entry code copied to clipboard. Send this any one you wish to join the group")));
                });
              },
              icon: const Icon(Icons.person_add_rounded))
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Song>>(
        stream: Repository.getSongsStream(group.id),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          var documents = snapshot.data?.docs;
          if (documents == null || documents.isEmpty) {
            return const CommonCenterText(title: 'No Songs Added Yet');
          }
          return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                var song = documents[index].data();
                return Container(
                    margin: const EdgeInsets.fromLTRB(0, 16.0, 0, 0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      onTap: () {
                        MyNavUtils.navigateTo(
                            context, ViewSongScreen(song: song));
                      },
                      title: Text(song.title),
                      subtitle: Text(song.author),
                      trailing: widget.isOwner
                          ? PopupMenuButton<int>(
                              onSelected: (value) async {
                                if (value == 0) {
                                  MyNavUtils.navigateTo(
                                      context,
                                      AddSongScreen(
                                          song: song, groupId: group.id));
                                } else if (value == 1) {
                                  Repository.deleteSong(song.id, group.id);
                                }
                              },
                              itemBuilder: (BuildContext context) {
                                return <PopupMenuEntry<int>>[
                                  PopupMenuItem(value: 0, child: Text("Edit")),
                                  PopupMenuDivider(),
                                  PopupMenuItem(value: 1, child: Text("Delete"))
                                ];
                              },
                            )
                          : null,
                    ));
              });
        },
      ),
      floatingActionButton: widget.isOwner
          ? FloatingActionButton(
              onPressed: () {
                MyNavUtils.navigateTo(
                    context, AddSongScreen(groupId: widget.group.id));
              },
              tooltip: 'Add Song',
              child: const Icon(Icons.add),
            )
          : null, // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
