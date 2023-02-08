import 'package:flutter/material.dart';
import 'package:todo_flutter_firebase/model/task.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo_flutter_firebase/services/todo.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
                child: Text("Internal error: Could not find any tasks",
                    textScaleFactor: 1.5)
            );
          }
          // Else we have data!
          return Scaffold(
            appBar: AppBar(title: Text('Tasks')),
            body: Column(children:
              snapshot.data!.map((task) => ListTile(
                leading: const Icon(Icons.check_box_outline_blank),
                  title: Text(task.name),
                subtitle: Text(task.description??"(No details)"),
                trailing: Wrap(children: [
                  const Icon(Icons.edit),
                  const Icon(Icons.copy),
                  const Icon(Icons.delete, color: Colors.red),
                ]),
              ))
                .toList()),
            floatingActionButton: FloatingActionButton(
              onPressed: () => debugPrint("FAB"),
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
          );
        }
    );
  }
}
