import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todoapp/models/todo_model.dart';

class DatabaseServices {
  final CollectionReference todoCollection =
      FirebaseFirestore.instance.collection("todos");
  User? user = FirebaseAuth.instance.currentUser;

  Future<DocumentReference> addTodoItem(String title, String desc) async {
    return await todoCollection.add({
      'uid': user!.uid,
      'title': title,
      'description': desc,
      'completed': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateTodo(String id, String title, String desc) async {
    final updateCollection =
        FirebaseFirestore.instance.collection("todos").doc(id);
    return await updateCollection.update({
      'title': title,
      'description': desc,
      'createdAt':FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateTodoStatus(String id, bool completed) async {
    return await todoCollection.doc(id).update({'completed': completed});
  }

  Future<void> deleteTask(String id) async {
    return await todoCollection.doc(id).delete();
  }

  Stream<List<Todo>> get todos {
    return todoCollection
        .where('uid', isEqualTo: user!.uid)
        .where('completed', isEqualTo: false)
        .snapshots()
        .map(_todoListFromSnapshot);
  }

  Stream<List<Todo>> get completeTodos {
    return todoCollection
        .where('uid', isEqualTo: user!.uid)
        .where('completed', isEqualTo: true)
        .snapshots()
        .map(_todoListFromSnapshot);
  }

  List<Todo> _todoListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Todo(
        id: doc.id,
        title: doc['title'] ?? '',
        desc: doc['description'] ?? '',
        isCompleted: doc['completed'] ?? false,
        timeStamp: doc['createdAt'] ?? Timestamp.now(),
      );
    }).toList();
  }
}
