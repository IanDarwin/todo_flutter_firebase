import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/task.dart';

class FirebaseService {

  static Stream<List<Task>> getTasks() =>
      FirebaseFirestore.instance
        .collection("todos")
        .snapshots()
        .map((snap) =>
          snap.docs.map(
                  (doc) => Task.fromMap(doc.data())
          ).toList());
}
