import 'package:flutter/material.dart';
import 'package:firebaseauthsigninsignup/screens/create_edit_tasks.dart';
import 'package:firebaseauthsigninsignup/utilities/task_model.dart';


Widget buildTaskList({
  required BuildContext context,
  required List<TaskModel>? retrievedTasksList,
  required VoidCallback initRetrieval,
  required Future<void> Function() logout,
  required Future<void> Function(TaskModel taskModel) deleteTask,
}) {
  return Scaffold(
    appBar: AppBar(
      leading: IconButton(
        icon: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ToDoPage()),
          );
          initRetrieval();
        },
      ),
      title: const Text('Home Page'),
      backgroundColor: Colors.lightBlueAccent,
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            logout();
          },
        ),
      ],
    ),
    body: retrievedTasksList == null
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: retrievedTasksList.length,
            itemBuilder: (BuildContext context, int index) {
              return SingleChildScrollView(
                child: Card(
                  child: ListTile(
                    title: Text(retrievedTasksList[index].title ?? ''),
                    leading: retrievedTasksList[index].imageurl != null
                        ? Image.network(retrievedTasksList[index].imageurl!)
                        : Image.network('https://picsum.photos/200'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(retrievedTasksList[index].description),
                        Text(retrievedTasksList[index].date),
                        Text(retrievedTasksList[index].category),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (String value) async {
                        if (value == 'edit') {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ToDoPage(task: retrievedTasksList[index])),
                          );
                          initRetrieval();
                        } else if (value == 'delete') {
                          deleteTask(retrievedTasksList[index]);
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return {'Edit', 'Delete'}.map((String choice) {
                          return PopupMenuItem<String>(
                            value: choice.toLowerCase(),
                            child: Text(choice),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              );
            },
          ),
  );
}

Widget buildCategoryList({
  required List<String>? retrievedCategoryList,
}) {
  return retrievedCategoryList == null
      ? const Center(child: CircularProgressIndicator())
      : ListView.builder(
          itemCount: retrievedCategoryList.length,
          itemBuilder: (BuildContext context, int index) {
            return SingleChildScrollView(
              child: Card(
                child: ListTile(
                  title: Text(retrievedCategoryList[index]),
                ),
              ),
            );
          },
        );
}
