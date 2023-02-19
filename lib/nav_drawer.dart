import 'dart:io';

import 'package:flutter/material.dart';
import 'package:todo_flutter_firebase/services/import.dart';
import 'package:todo_flutter_firebase/settings.dart';

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
                // Android only, for now (sorry)
                var fileName = "/sdcard/todo.txt";
                var file = File(fileName);
                if (await file.exists()) {
                  Import.importTasks(await file.readAsLines());
                } else {
                  print("File $fileName not found!");
                }
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
}