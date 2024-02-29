import 'package:flutter/material.dart';
import 'package:top_choir/model/song.dart';

class ViewSongScreen extends StatelessWidget {
  const ViewSongScreen({super.key, required this.song});

  final Song song;

  @override
  Widget build(BuildContext context) {
    var headerThemes = Theme.of(context)
        .textTheme
        .titleMedium
        ?.copyWith(color: Colors.black87);
    var bodyTheme = Theme.of(context)
        .textTheme
        .titleMedium
        ?.copyWith(color: Colors.black87);
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
          CommonContainer(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(song.title, style: headerThemes),
                  Text(
                    song.key,
                    style: headerThemes,
                  ),
                ],
              ),
              Text(
                song.author,
                style: headerThemes,
              )
            ],
          )),
          const SizedBox(height: 32.0),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Verses",
                style: headerThemes?.copyWith(color: Colors.black54),
              )
            ],
          ),
          CommonContainer(
            child: SizedBox(
                width: double.infinity,
                child: Text(song.verse, style: bodyTheme)),
          ),
          const SizedBox(height: 32.0),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Chorus",
                style: headerThemes?.copyWith(color: Colors.black54),
              )
            ],
          ),
          CommonContainer(
            child: SizedBox(
                width: double.infinity,
                child: Text(song.chorus, style: bodyTheme)),
          ),
        ],
      ),
    );
  }
}

class CommonContainer extends StatelessWidget {
  const CommonContainer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 16.0, 0, 0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4), color: Colors.white),
      padding: const EdgeInsets.all(16.0),
      child: child,
    );
  }
}
