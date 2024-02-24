import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:top_choir/add_song_screen.dart';
import 'package:top_choir/view_song_screen.dart';

import 'model/song.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute<ProfileScreen>(
                        builder: (context) => ProfileScreen(
                              actions: [
                                SignedOutAction((context) {
                                  Navigator.of(context).pop();
                                })
                              ],
                            )));
              },
              icon: const Icon(Icons.person)),
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Song>>(
        stream: FirebaseFirestore.instance
            .collection('Songs')
            .withConverter<Song>(
              fromFirestore: (snapshot, _) => Song.fromJson(snapshot.data()!),
              toFirestore: (model, _) => model.toJson(),
            )
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          var documents = snapshot.data?.docs;
          if (documents == null || documents.isEmpty) {
            return const Center(
              child: Text('No Songs Added Yet'),
            );
          }
          return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                var song = documents[index].data();
                return Column(
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ViewSongScreen(song: song)));
                      },
                        title: Text(song.title), subtitle: Text(song.author),
                    trailing: PopupMenuButton<int>(
                      onSelected: (value) {
                        if(value == 0) {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AddSongScreen(song: song)));
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return <PopupMenuEntry<int>>[
                          PopupMenuItem(value: 0, child: Text("Edit")),
                          PopupMenuDivider(),
                          PopupMenuItem(value: 1, child: Text("Delete"))
                        ];
                      },
                    ),),
                    const Divider(),
                  ],
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddSongScreen()));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
