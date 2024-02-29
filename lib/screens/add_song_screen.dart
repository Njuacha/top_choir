import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:top_choir/repository.dart';

import '../model/song.dart';
import '../reusable_components/common_input_field.dart';
import '../utils/song_screen_utils.dart';

class AddSongScreen extends StatefulWidget {
  const AddSongScreen({super.key, this.song, required this.groupId});

  final Song? song;
  final String groupId;

  @override
  State<AddSongScreen> createState() => _AddSongScreenState();
}

class _AddSongScreenState extends State<AddSongScreen>
    with SingleTickerProviderStateMixin {
  final keyController = TextEditingController();
  final titleController = TextEditingController();
  final authorController = TextEditingController();
  final sVersesController = TextEditingController();
  final sChorusController = TextEditingController();
  final aVersesController = TextEditingController();
  final aChorusController = TextEditingController();
  final tVersesController = TextEditingController();
  final tChorusController = TextEditingController();
  final bVersesController = TextEditingController();
  final bChorusController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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
    var oldSong = widget.song;
    var buttonTitle = 'Create';

    if (oldSong != null) {
      keyController.text = oldSong.key;
      titleController.text = oldSong.title;
      authorController.text = oldSong.author;
      sVersesController.text = oldSong.sVerse;
      sChorusController.text = oldSong.sChorus;
      aVersesController.text = oldSong.aVerse;
      aChorusController.text = oldSong.aChorus;
      tVersesController.text = oldSong.tVerse;
      tChorusController.text = oldSong.tChorus;
      bVersesController.text = oldSong.bVerse;
      bChorusController.text = oldSong.bChorus;
      buttonTitle = 'Save Changes';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a New Song"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CommonInputField(
                  textController: keyController, label: "Enter the Key"),
              CommonInputField(
                  textController: titleController, label: "Enter the title"),
              CommonInputField(
                  textController: authorController, label: "Enter the author"),
              const SizedBox(height: 24.0),
              SongPartsTabBar(tabController: _tabController),
              Center(
                child: getSelectedTab(_tabController.index),
              )
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        SizedBox(
          width: double.infinity,
          child: FilledButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                  Song song = Song(
                      key: keyController.text,
                      title: titleController.text,
                      author: authorController.text,
                      sVerse: sVersesController.text,
                      sChorus: sChorusController.text,
                      aVerse: aVersesController.text,
                      aChorus: aChorusController.text,
                      tVerse: tVersesController.text,
                      tChorus: tChorusController.text,
                      bVerse: bVersesController.text,
                      bChorus: bChorusController.text,
                      dateCreated: DateTime.now());
                  if (oldSong == null) {
                    await Repository.addSong(song, widget.groupId);
                  } else {
                    await Repository.updateSong(
                        oldSong.id, song, widget.groupId);
                  }
                  Navigator.pop(context);
                }
              },
              child: Text(buttonTitle)),
        ),
      ],
    );
  }

  Part getSelectedTab(int index) {
    var list = [
      Part(
          versesController: sVersesController,
          chorusController: sChorusController),
      Part(
          versesController: aVersesController,
          chorusController: aChorusController),
      Part(
          versesController: tVersesController,
          chorusController: tChorusController),
      Part(
          versesController: bVersesController,
          chorusController: bChorusController)
    ];
    return list[index];
  }

  @override
  void dispose() {
    keyController.dispose();
    titleController.dispose();
    authorController.dispose();
    sVersesController.dispose();
    sChorusController.dispose();
    aVersesController.dispose();
    aChorusController.dispose();
    tVersesController.dispose();
    tChorusController.dispose();
    bVersesController.dispose();
    bChorusController.dispose();
    _tabController.dispose();
    super.dispose();
  }
}

class Part extends StatelessWidget {
  const Part({
    super.key,
    required this.versesController,
    required this.chorusController,
  });

  final TextEditingController versesController;
  final TextEditingController chorusController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 24.0),
        const SizedBox(
            width: double.infinity,
            child: Text("Verses", textAlign: TextAlign.center)),
        CommonInputField(
            textController: versesController,
            label: "Type Verses and Solfas underneath each line"),
        const SizedBox(height: 24.0),
        const SizedBox(
            width: double.infinity,
            child: Text("Chorus", textAlign: TextAlign.center)),
        CommonInputField(
            textController: chorusController,
            label: "Type the Chorus and Sofas underneath each line"),
      ],
    );
  }
}
