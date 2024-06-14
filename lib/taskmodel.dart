import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String? user_id;
  final String? title;
  final String description;
  final String category;
  final String date;
  final String taskId;
  final String? imageurl;


  TaskModel({
    required this.user_id,
    required this.title,
    required this.description,
    required this.category,
    required this.date,
    required this.taskId,
    required this.imageurl

  });

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      user_id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      category: map['category'] as String,
      date: map['date'] as String,
      taskId: map['taskId'] as String,
     imageurl: map['imageurl'] as String
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'date': date,
      'id' : user_id,
      'imageurl' : imageurl
    };
  }

    TaskModel.fromDocument(Map doc, String taskID)
      : user_id = doc["id"],
      taskId = taskID,
        title = doc["title"],
        description = doc["description"],
        category = doc["category"],
        date = doc["date"],
        imageurl = doc["imageurl"];

}
