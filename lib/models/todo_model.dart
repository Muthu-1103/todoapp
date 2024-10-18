import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  final String id;
  final String title;
  final String desc;
  final bool isCompleted;
  final Timestamp timeStamp;

  Todo({
    required this.id,
    required this.title,
    required this.desc,
    required this.isCompleted,
    required this.timeStamp,
  });
}
