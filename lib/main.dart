import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo_flutter_firebase/model/task.dart';
import 'package:todo_flutter_firebase/services/todos_service.dart';
import 'package:todo_flutter_firebase/edit_page.dart';
import 'package:todo_flutter_firebase/firebase_options.dart';
import 'package:todo_flutter_firebase/nav_drawer.dart';

import 'model/Context.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo Flutter Firebase Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const MyHomePage(title: 'Todo Flutter Firebase'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

final colors = [
  Colors.red, // 0 - not in use
  Colors.green.shade100, // 1 - Low
  Colors.red, // 2 - not in use
  Colors.amber.shade100, // 3 - Med
  Colors.red, // 4 - not in use
  Colors.red.shade200, //5 - High
];

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    debugPrint("_MyHomePageState building $this");
    return StreamBuilder<List<Task>>(
        stream: FirebaseService.getTasks(),
        builder: (context, AsyncSnapshot<List<Task>> snapshot) {
          if (snapshot.hasError) {
            debugPrint("${snapshot.error}");
            return Center(
                child: Text(
                    "Data error: ${snapshot.error}!", textScaleFactor: 1.5)
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data == null) {
            return const Center(
                child: Text("Internal error: Could not get task list",
                    textScaleFactor: 1.5)
            );
          }
          const double maxWidth = 5;
          return Scaffold(
            appBar: AppBar(title: Text('Tasks (${snapshot.data!.length})')),
            drawer: const NavDrawer(),
            body:
            snapshot.data!.isEmpty ?
            const Center(child: Text("No tasks left! Add more with the + button",
                textScaleFactor: 1.3)) :
            ListView(children:
            snapshot.data!.map((task) => ListTile(
              tileColor: colors[task.priority!],
              leading: CircleAvatar(
                child: createAvatarChild(task),
              ),
              title: Text(task.name),
              subtitle: Text(task.description??"(No details)"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => (EditPage(task))));
              },
              trailing: Wrap(children: [
                IconButton(
                  constraints: const BoxConstraints(maxWidth: maxWidth),
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    debugPrint("Copy");
                    var task2 = task;
                    task2.id = Random().nextInt(2^32 - 1).toString();
                    FirebaseFirestore.instance
                        .collection('todos')
                        .doc(task2.id)
                        .set(task2.toJson());
                  },
                ),
                IconButton(
                  constraints: const BoxConstraints(maxWidth: maxWidth),
                  icon: const Icon(Icons.check),
                  color: Colors.green,
                  onPressed: null,
                ),
                IconButton(
                  constraints: const BoxConstraints(maxWidth: maxWidth),
                  icon: const Icon(Icons.delete),
                  color: Colors.red,
                  onPressed: () async {
                    var doc2del = FirebaseFirestore.instance.collection('todos').doc(task.id);
                    await doc2del.delete();
                    debugPrint("Doc $doc2del deleted");
                  },
                ),
              ]),
            ))
                .toList()),
            floatingActionButton: FloatingActionButton(
              onPressed: () =>  Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => (EditPage(Task(""))))),
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
          );
        }
    );
  }
  
  Widget createAvatarChild(Task t) {
    if (t.context == null) {
      return const Text("?", textScaleFactor: 1.4);
    }
    for (int i = 0; i < contexts.length; i++) {
      if (contexts[i].name == t.context && contexts[i].icon != null) {
        return contexts[i].icon!;
      }
    }
    // E.g. Turn "SysAdmin" into "SA"
    var capsOnly = t.context!.replaceAll(RegExp('[^A-Z0-9]{1,2}'), '');
    return Text(capsOnly.isNotEmpty ? capsOnly : t.context![0],
        textScaleFactor: 1.4);
  }
}
