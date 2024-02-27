import 'package:flutter/material.dart';
import 'package:top_choir/repository.dart';

import '../model/song.dart';
import '../reusable_components/common_input_field.dart';

class AddSongScreen extends StatefulWidget {
  const AddSongScreen({super.key, this.song, required this.groupId});

  final Song? song;
  final String groupId;

  @override
  State<AddSongScreen> createState() => _AddSongScreenState();
}

class _AddSongScreenState extends State<AddSongScreen> {
  final keyController = TextEditingController();
  final titleController = TextEditingController();
  final authorController = TextEditingController();
  final versesController = TextEditingController();
  final chorusController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var oldSong = widget.song;
    var buttonTitle = 'Create';

    if (oldSong != null) {
      keyController.text = oldSong.key;
      titleController.text = oldSong.title;
      authorController.text = oldSong.author;
      versesController.text = oldSong.verse;
      chorusController.text = oldSong.chorus;
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
                      verse: versesController.text,
                      chorus: chorusController.text,
                      dateCreated: DateTime.now());
                  if (oldSong == null) {
                    await Repository.addSong(song, widget.groupId);
                  } else {
                    await Repository.updateSong(oldSong.id, song, widget.groupId);
                  }
                  Navigator.pop(context);
                }
              },
              child: Text(buttonTitle)),
        ),
      ],
    );
  }

  @override
  void dispose() {
    keyController.dispose();
    titleController.dispose();
    authorController.dispose();
    versesController.dispose();
    chorusController.dispose();
    super.dispose();
  }
}