import 'package:flutter/material.dart';
import 'package:top_choir/model/song.dart';
import 'package:top_choir/utils/song_screen_utils.dart';

class ViewSongScreen extends StatefulWidget {
  const ViewSongScreen({super.key, required this.song});

  final Song song;

  @override
  State<ViewSongScreen> createState() => _ViewSongScreenState();
}

class _ViewSongScreenState extends State<ViewSongScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabSelection);
    super.initState();
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

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
                  Text(widget.song.title, style: headerThemes),
                  Text(
                    widget.song.key,
                    style: headerThemes,
                  ),
                ],
              ),
              Text(
                widget.song.author,
                style: headerThemes,
              )
            ],
          )),
          const SizedBox(height: 24.0),
          SongPartsTabBar(tabController: _tabController),
          getPart(_tabController.index),
        ],
      ),
    );
  }

  ViewPart getPart(int index) {
    var song = widget.song;
    var list = [
      ViewPart(verse: song.sVerse, chorus: song.sChorus),
      ViewPart(verse: song.aVerse, chorus: song.aChorus),
      ViewPart(verse: song.tVerse, chorus: song.tChorus),
      ViewPart(verse: song.bVerse, chorus: song.bChorus),
    ];
    return list[index];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class ViewPart extends StatelessWidget {
  const ViewPart({
    super.key,
    required this.verse,
    required this.chorus,
  });

  final String verse;
  final String chorus;

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
    return Column(
      children: [
        const SizedBox(height: 24.0),
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
              child: Text(verse, style: bodyTheme)),
        ),
        const SizedBox(height: 24.0),
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
              child: Text(chorus, style: bodyTheme)),
        ),
      ],
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
