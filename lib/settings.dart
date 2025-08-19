import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

import 'context_list_screen.dart';

/// Activity for Settings.
///
class SettingsPage extends StatefulWidget {

  @override
  SettingsState createState() => SettingsState();

}

class SettingsState extends State<SettingsPage> {

  SettingsState();

  @override
  Widget build(BuildContext context) {

    return SettingsScreen(title: "Todo List Settings",
        children: <Widget>[
          SettingsGroup(title: "Authentication",
              children: [
                
              ]),
          SettingsGroup(
            title: "Personalization",
            children: [
              TextButton(
                  onPressed: () => {
                    Navigator.push(context, MaterialPageRoute(
                    builder: (context) => ContextListScreen(FirebaseFirestore.instance)))
                  },
                  child: const Text("Categories..."))
            ],
          ),
          SettingsGroup(
            title: "Personalization",
            children: [
              ],
        )
      ]
    );
  }

  @override
  void dispose() {
	// Do we need anything here?
	super.dispose();
  }
}


