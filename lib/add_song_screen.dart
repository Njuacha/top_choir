import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'model/song.dart';

class AddSongScreen extends StatefulWidget {
  const AddSongScreen({super.key, this.song});

  final Song? song;

  @override
  State<AddSongScreen> createState() => _AddSongScreenState();
}

class _AddSongScreenState extends State<AddSongScreen> {
  final keyController = TextEditingController();
  final titleController = TextEditingController();
  final authorController = TextEditingController();
  final versesSolfaController = TextEditingController();
  final versesLyricsController = TextEditingController();
  final chorusSolfaController = TextEditingController();
  final chorusLyricsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var oldSong = widget.song;

    if (oldSong != null) {
      keyController.text = oldSong.key;
      titleController.text = oldSong.title;
      authorController.text = oldSong.author;
      versesLyricsController.text = oldSong.verseLyrics;
      versesSolfaController.text = oldSong.verseSolfas;
      chorusLyricsController.text = oldSong.chorusLyrics;
      chorusSolfaController.text = oldSong.chorusSolfas;
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
              const SizedBox(width: double.infinity, child: Text("Verses", textAlign: TextAlign.center)),
              CommonInputField(
                  textController: versesSolfaController,
                  label: "Enter the Solfas"),
              CommonInputField(
                  textController: versesLyricsController,
                  label:
                      "Enter the verses separating each verse by a paragraph"),
              const SizedBox(height: 24.0),
              const SizedBox(width: double.infinity, child: Text("Chorus", textAlign: TextAlign.center)),
              CommonInputField(
                  textController: chorusSolfaController,
                  label: "Enter the Solfas"),
              CommonInputField(
                  textController: chorusLyricsController,
                  label: "Enter the lyrics")
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  Song song = Song(
                      key: keyController.text,
                      title: titleController.text,
                      author: authorController.text,
                      verseSolfas: versesSolfaController.text,
                      verseLyrics: versesLyricsController.text,
                      chorusSolfas: chorusSolfaController.text,
                      chorusLyrics: chorusLyricsController.text,
                      dateCreated: DateTime.now());
                  if (oldSong == null) {
                    await FirebaseFirestore.instance
                        .collection('Songs')
                        .add(song.toJson());
                  } else {
                    // TODO edit old song
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );

                  Navigator.pop(context);
                }
              },
              child: const Text("Create")),
        ),
      ],
    );
  }

  @override
  void dispose() {
    keyController.dispose();
    titleController.dispose();
    authorController.dispose();
    versesSolfaController.dispose();
    versesLyricsController.dispose();
    chorusSolfaController.dispose();
    chorusLyricsController.dispose();
    super.dispose();
  }
}

class CommonInputField extends StatelessWidget {
  const CommonInputField({
    super.key,
    required this.textController,
    required this.label, this.text,
  });

  final TextEditingController textController;
  final String label;
  final String? text;
  // Only a Sinner
  // James M.Gray
  // s: s-,s/s.s:-d | d:d-,d/d:- | t:t-,d/r.r:-t | t:t-,s/s:-d':s-,s/d'.d:- | l:r-,r/l:-.l | s:r-, t/d'.m | f:r/m:-
  // Naught have I gotten, but what I received. Grace hath bestowed it since I have believed. Boasting excluded, Pride I abase. I am ony a Sinner saved by grace.
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: text,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          },
          controller: textController,
          decoration: InputDecoration(
              border: const UnderlineInputBorder(), labelText: label)),
    );
  }
}
