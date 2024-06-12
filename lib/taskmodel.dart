import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String date;
  final String taskId;
  final String? imageurl;


  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.date,
    required this.taskId,
    required this.imageurl

  });

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      category: map['category'] as String,
      date: map['date'] as String,
      taskId: map['taskId'] as String,
      imageurl: map['imageurl'] as String,

    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'date': date,
      'id' : id,
      'imageurl' : imageurl
    };
  }

   TaskModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.data()!["id"],
      taskId = doc.id,
        title = doc.data()!["title"],
        description = doc.data()!["description"],
        category = doc.data()!["category"],
        date = doc.data()!["date"],
        imageurl = doc.data()!["imageurl"];
       

}
