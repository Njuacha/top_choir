import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:top_choir/model/song.dart';



class ViewSongScreen extends StatelessWidget {
  const ViewSongScreen({super.key, required this.song});

  final Song song;


  @override
  Widget build(BuildContext context) {
    var headerThemes = Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black87);
    var bodyTheme = Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black87);
    return Scaffold(
      appBar: AppBar(
          title: const Text("Read Song"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 16.0, 0, 0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.white
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(song.title, style: headerThemes),
                  Text(song.key, style: headerThemes,), 
                ],
              ),
              Text(song.author, style: headerThemes,)
            ],),
          ),
          const SizedBox(height: 24.0),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Verses", style: headerThemes?.copyWith(color: Colors.black54),)
            ],
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 8.0, 0, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.white
            ),
            padding: const EdgeInsets.all(16.0),
            //color: Colors.white,
            child: SizedBox(
                width: double.infinity,
                child: Text(song.verseSolfas, style: bodyTheme)),
          ),

          const SizedBox(height: 24.0),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Chorus", style: headerThemes?.copyWith(color: Colors.black54),)
            ],
          ),
          Container( // TODO resuse this as widget
            margin: const EdgeInsets.fromLTRB(0, 8.0, 0, 0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.white
            ),
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(width: double.infinity,
                child: Text(song.chorusLyrics)),
          ),

        ],
      ),
    );
  }
}
