import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
Import 'package:file_picker/file_picker.dart'
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
                debugPrint("Trying import");
				_doImport();
			/*
                var fileName = "/sdcard/Download/todo_flutter_firebase/todo.txt";
                var file = File(fileName);
                if (await Permission.storage.isPermanentlyDenied) {
                  openAppSettings();
                }
                print("0");
                if (await Permission.storage.isDenied) {
                  await Permission.storage.request();
                  print("1");
                }
                  if (await file.exists()) {
                    print("2");
                    Import.importTasks(await file.readAsLines());
                  } else {
                    debugPrint("File $fileName not found!");
                  }
			*/

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
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowedExtensions: ['todotxt'],
    );
    
    if (result != null) {
      final file = result.files.first;
      final filePath = '${directory.path}/${file.name}';
      
      // Save the selected file to the public directory
      await file.saveTo(filePath);
      
      // Open the selected file using the open_file package
      var newfile = await OpenFile.open(filePath);

      Import.importTasks(await newfile.readAsLines());

    }
  }
}
