import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:top_choir/repository.dart';
import 'package:top_choir/reusable_components/common_input_field.dart';
import 'package:top_choir/utils/my_firebase_utils.dart';

import '../model/group.dart';

class AddGroupScreen extends StatefulWidget {
  const AddGroupScreen({super.key, this.group});

  final Group? group;

  @override
  State<AddGroupScreen> createState() => _AddGroupScreenState();
}

class _AddGroupScreenState extends State<AddGroupScreen> {
  final groupNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? _pickedImage;
  ImageProvider? oldBackgroundImage;
  var buttonTitle = 'Create';

  @override
  void initState() {
    var oldGroup = widget.group;
    if (oldGroup != null) {
      groupNameController.text = oldGroup.name;
      buttonTitle = 'Save Changes';
    }
    var picturePath = oldGroup?.picturePath??'';
    oldBackgroundImage = picturePath.isEmpty? null: NetworkImage(picturePath);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var oldGroup = widget.group;

    var newBackgroundImage = _pickedImage == null? oldBackgroundImage: FileImage(_pickedImage!);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new group'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          CircleAvatar(
            backgroundImage: newBackgroundImage,
            backgroundColor: Colors.grey,
            radius: 60,
            child: Stack(
              clipBehavior: Clip.none,
              fit: StackFit.expand,
              children: [
                if (newBackgroundImage == null)
                  const Align(child: Icon(Icons.group, size: 60)),
                Positioned(
                  bottom: -5,
                  right: -10,
                  child: IconButton(
                    onPressed: _pickImage,
                    icon: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.camera_alt_outlined,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 20),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CommonInputField(
                    textController: groupNameController,
                    label: 'Enter a name for the group'),
                const SizedBox(height: 52),
                FilledButton(
                    onPressed: () async {
                      final userId = MyFirebaseUtils.userId;
                      var group = Group(
                          name: groupNameController.text,
                          picturePath:
                              oldGroup == null ? '' : oldGroup.picturePath);
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );

                        if (_pickedImage != null) {
                          group.picturePath = await Repository.uploadGroupPic(
                              _pickedImage!, group.picturePath);
                        }
                        if (userId != null) {
                          if (oldGroup == null) {
                            await Repository.addGroup(group, userId);
                          } else {
                            group.id = oldGroup.id;
                            await Repository.updateGroup(group, userId);
                          }
                        }
                        Navigator.pop(context);
                      }
                    },
                    child: Text(buttonTitle))
              ],
            ),
          )
        ]),
      ),
    );
  }

  void _pickImage() {
    showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text('Choose image source'),
        actions: [
          ElevatedButton(
            child: Text('Camera'),
            onPressed: () => Navigator.pop(context, ImageSource.camera),
          ),
          ElevatedButton(
            child: Text('Gallery'),
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
          ),
        ],
      ),
    ).then((ImageSource? source) async {
      if (source == null) return;

      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile == null) return;

      setState(() => _pickedImage = File(pickedFile.path));
    });
  }

  @override
  void dispose() {
    groupNameController.dispose();
    super.dispose();
  }
}
