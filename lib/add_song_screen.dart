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
  final titleController = TextEditingController();
  final authorController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    controller: titleController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Enter the song title")),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    controller: authorController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Enter the author")),
              ),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                Song song = Song(
                    title: titleController.text,
                    author: authorController.text,
                    dateCreated: DateTime.now());
                await FirebaseFirestore.instance
                    .collection('Songs')
                    .add(song.toJson());
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Processing Data')),
                );

                Navigator.pop(context);
              }
            },
            child: const Text("Create"))
      ],
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    authorController.dispose();
    super.dispose();
  }
}
