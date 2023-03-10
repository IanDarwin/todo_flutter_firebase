import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:todo_flutter_firebase/services/import.dart';
import 'package:todo_flutter_firebase/settings.dart';

import 'model/task.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  build(context) {
    return Drawer(
      child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.lightGreen,
                  image: DecorationImage(
                      fit: BoxFit.none,
                     image: AssetImage('images/logo.png'))
              ),
              child: Text(
                'Todo Menu',
                style: TextStyle(color: Colors.black, fontSize: 25),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.input),
              title: const Text('Intro/Help'),
              onTap: () => {},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Import'),
              onTap: () async  {
                debugPrint("Trying import");
				        _doImport();
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () => {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => const SettingsPage()))
              },
            ),
			const AboutListTile(
              icon: Icon(Icons.info),
              applicationName:  'TodoFlutterFirebase',
              aboutBoxChildren: [
                Text("A basic Todo List Application, using Flutter and Firebase"),
              ],
            )
            ,
          ]),
    );
  }

  _doImport() async {
    // Get the public directory path
    final directory = await getExternalStorageDirectory();
    
    // Use the file picker to select a file
    final result = await FilePicker.platform.pickFiles();
    
    if (result != null) {
      final file = result.files.first;
      var lines = await File(file.path!).readAsLines();
      var db = FirebaseFirestore.instance.collection('todos');
      for (Task task in Import.importTasks(lines)){
            db
            .doc(task.id)
            .set(task.toJson())
            .then((_) => debugPrint('Added'))
            .catchError((error) => print('Add failed: $error'));
      }
    }
  }
}
