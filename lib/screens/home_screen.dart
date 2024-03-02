import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:top_choir/model/group.dart';
import 'package:top_choir/repository.dart';
import 'package:top_choir/screens/add_group_screen.dart';
import 'package:top_choir/screens/group_screen.dart';
import 'package:top_choir/utils/my_encryption_utils.dart';
import 'package:top_choir/utils/my_firebase_utils.dart';
import 'package:top_choir/utils/my_navigator_utils.dart';

import '../reusable_components/common_center_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return DefaultTabController(
        length: 2,
        child: Builder(builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("DoRe"),
              leading:
                  IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute<ProfileScreen>(
                              builder: (context) => ProfileScreen(
                                    actions: [
                                      SignedOutAction((context) {
                                        Navigator.of(context).pop();
                                      })
                                    ],
                                  )));
                    },
                    icon: const Icon(Icons.person)),
                IconButton(
                    onPressed: () {
                      MyFirebaseUtils.firebaseAuthInstance.signOut();
                    },
                    icon: const Icon(Icons.logout))
              ],
              bottom: const TabBar(tabs: [
                Tab(text: 'Groups Joined'),
                Tab(text: 'Groups Created')
              ]),
            ),
            body: TabBarView(children: [
              GroupsSection(
                  stream:
                      Repository.getGroupsBelongStream(MyFirebaseUtils.userId!),
                  isOwner: false),
              GroupsSection(
                  stream:
                      Repository.getGroupsOwnedStream(MyFirebaseUtils.userId!),
                  isOwner: true)
            ]),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                var index = DefaultTabController.of(context).index;
                if (index == 0) {
                  _displayJoinGroupDialog(context, '', false);
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddGroupScreen()));
                }
              },
              child: const Icon(Icons.add),
            ),
          );
        }));
  }

  Future<void> _displayJoinGroupDialog(BuildContext context, String groupCode, bool isInvalid) async {

    TextEditingController groupCodeTextController = TextEditingController(text: groupCode);
    var formKey = GlobalKey<FormState>();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Join a Group'),
              Text('Paste Group Code below',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.start)
            ],
          ),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: groupCodeTextController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter group code';
                }
                return null;
              },
              decoration: InputDecoration(
                  hintText: "Group Code",
              errorText: isInvalid? 'No match found !': null),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('JOIN'),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  var groupId = MyEncryptionUtils.extractGroupIdFromCode(
                      groupCodeTextController.text);
                  var isGroupExist = await Repository.isGroupExist(groupId);
                  Navigator.pop(context);
                  if (isGroupExist) {
                    Repository.addToGroup(groupId);
                  } else {
                    // TODO find way to make dialog stateful and change error text without recreating dialog
                    _displayJoinGroupDialog(context, groupCodeTextController.text, true);
                  }
                }

              },
            ),
          ],
        );
      },
    );
  }
}

class GroupsSection extends StatelessWidget {
  const GroupsSection({
    super.key,
    required this.stream,
    required this.isOwner,
  });

  final Stream<List<Group>> stream;
  final bool isOwner;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Group>>(
        stream: stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          var documents = snapshot.data;
          if (documents == null || documents.isEmpty) {
            final title =
                isOwner ? 'No Groups Created Yet' : 'No Groups Joined Yet';
            return CommonCenterText(title: title);
          }
          return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final group = documents[index];
                return Container(
                    margin: const EdgeInsets.fromLTRB(0, 16.0, 0, 0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      title: Text(group.name),
                      onTap: () {
                        MyNavUtils.navigateTo(context,
                            GroupScreen(group: group, isOwner: true)); // Todo Temporaily allow everyone to edit
                      },
                      trailing: isOwner
                          ? PopupMenuButton<int>(
                              onSelected: (value) async {
                                if (value == 0) {
                                  MyNavUtils.navigateTo(
                                      context, AddGroupScreen(group: group));
                                } else if (value == 1) {
                                  // TODO show dialog to user warning user that deleting a group is irreversible
                                  // TODO show dialog with loading until delete is finished
                                  var userId = MyFirebaseUtils.userId;
                                  if (userId != null) {
                                    Repository.deleteGroup(group.id, userId);
                                  }
                                }
                              },
                              itemBuilder: (BuildContext context) {
                                return <PopupMenuEntry<int>>[
                                  PopupMenuItem(value: 0, child: Text("Edit")),
                                  PopupMenuDivider(),
                                  PopupMenuItem(value: 1, child: Text("Delete"))
                                ];
                              },
                            )
                          : null,
                    ));
              });
        },
      ),
    );
  }
}

