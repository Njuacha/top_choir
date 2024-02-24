import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:top_choir/model/song.dart';



class ViewSongScreen extends StatelessWidget {
  const ViewSongScreen({super.key, required this.song});

  final Song song;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Read Song"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(song.key),
                Text(song.title),
                Text(song.author)
              ],
            ),
            const SizedBox(height: 24.0),
            const Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Verses")
              ],
            ),
            const SizedBox(height: 8.0),
            SizedBox(width: double.infinity,
                child: Text(song.verseSolfas)),
            const SizedBox(height: 8.0),
            SizedBox(width: double.infinity,
                child: Text(song.verseLyrics)),
            const SizedBox(height: 24.0),
            const Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Chorus")
              ],
            ),
            SizedBox(height: 8.0),
            SizedBox(width: double.infinity,
                child: Text(song.chorusSolfas)),
            SizedBox(height: 8.0),
            SizedBox(width: double.infinity,
                child: Text(song.chorusLyrics)),

          ],
        ),
      ),
    );
  }
}
