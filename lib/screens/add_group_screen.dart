import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    var oldGroup = widget.group;
    var buttonTitle = 'Create';
    if (oldGroup != null) {
      groupNameController.text = oldGroup.name;
      buttonTitle = 'Save Changes';
    }
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CommonInputField(
                  textController: groupNameController,
                  label: 'Enter a name for the group'),
              const SizedBox(height: 32),
              FilledButton(
                  onPressed: () async {
                    final userId = MyFirebaseUtils.userId;
                    var group =
                        Group(name: groupNameController.text, picturePath: '');
                    if (_formKey.currentState!.validate()) {
                      if (userId != null) {
                        if (oldGroup == null) {
                          await Repository.addGroup(group, userId);
                        } else {
                          group.id = oldGroup.id;
                          await Repository.updateGroup(group, userId);
                        }
                      }
                    }
                    Navigator.pop(context);
                  },
                  child: Text(buttonTitle))
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    groupNameController.dispose();
    super.dispose();
  }
}
