import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebaseauthsigninsignup/screens/createtasks.dart';
import 'package:firebaseauthsigninsignup/screens/editscreen.dart';
import 'package:firebaseauthsigninsignup/screens/welcome.dart';
import 'package:firebaseauthsigninsignup/taskmodel.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? loggedinUser;
  List<TaskModel>? retrievedTasksList;

  @override
  void initState() {
    super.initState();
    
    getCurrentUser();
    _initRetrieval();
  }

  Future<void> _initRetrieval() async {
    var list = await fetchTasks();
    setState(() {
      retrievedTasksList = list;
    });
  }

  Future<List<TaskModel>> fetchTasks() async {
    final FirebaseFirestore _db = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db
        .collection("tasks")
        .where('id', isEqualTo: loggedinUser!.uid)
        .get();
    return snapshot.docs
        .map((docSnapshot) => TaskModel.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<void> getCurrentUser() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        loggedinUser = user;
      });
    }
  }

  Future<void> logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    await _auth.signOut().then((value) => Navigator.of(context)
        .pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => WelcomeScreen()),
            (route) => false));
  }

  Future<void> deleteTask(TaskModel taskModel) async {
    print(taskModel.taskId);
    final FirebaseFirestore _db = FirebaseFirestore.instance;
    await _db.collection('tasks').doc(taskModel.taskId).delete();
    _initRetrieval();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ToDoPage()),
            );
          },
        ),
        title: Text('Home Page'),
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
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: retrievedTasksList?.length,
              itemBuilder: (BuildContext context, int index) {
                return SingleChildScrollView(
                  child: Card(
                    child: ListTile(
                      title: Text(retrievedTasksList![index].title),
                      leading: retrievedTasksList![index].imageurl != null
                              ? Image.network(retrievedTasksList![index].imageurl!)
                              : Image.network('https://picsum.photos/200'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(retrievedTasksList![index].description),
                          Text(retrievedTasksList![index].date),
                          Text(retrievedTasksList![index].category),
                          Text(retrievedTasksList![index].id),
                        ],
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (String value) {
                          if (value == 'edit') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditToDoPage(
                                      task: retrievedTasksList![index])),
                            );
                          } else if (value == 'delete') {
                            deleteTask(retrievedTasksList![index]);
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
}
