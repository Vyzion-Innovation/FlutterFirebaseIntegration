import 'package:firebaseauthsigninsignup/screens/createtasks.dart';
import 'package:firebaseauthsigninsignup/screens/welcome.dart';
import 'package:firebaseauthsigninsignup/taskmodel.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? loggedinUser;
  List<TaskModel>? retrievedTasksList;
  late List<String?> retrievedcategoryList;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
    _initRetrieval();
  }

  Future<void> _initRetrieval() async {
    var list = await fetchTasks();
    var cList = await fetchCategory();
    setState(() {
      retrievedTasksList = list;
      retrievedcategoryList = cList;
    });
  }

  Future<List<TaskModel>> fetchTasks() async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> snapshot = await db
        .collection("tasks")
        .where('id', isEqualTo: loggedinUser!.uid)
        .get();
    return snapshot.docs
        .map((docSnapshot) => TaskModel.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<List<String>> fetchCategory() async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await db.collection("categoryList").get();
    return snapshot.docs.map((doc) => doc['category'] as String).toList();
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
            MaterialPageRoute(builder: (context) => const WelcomeScreen()),
            (route) => false));
  }

  Future<void> deleteTask(TaskModel taskModel) async {
    print(taskModel.taskId);
    final FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection('tasks').doc(taskModel.taskId).delete();
    _initRetrieval();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex == 0 ? _buildTaskList() : _buildCategoryList(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Task List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Category List',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildTaskList() {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ToDoPage()),
              );
              _initRetrieval();
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
                itemCount: retrievedTasksList?.length,
                itemBuilder: (BuildContext context, int index) {
                  return SingleChildScrollView(
                    child: Card(
                      child: ListTile(
                        title: Text(retrievedTasksList![index].title ?? ''),
                        leading: retrievedTasksList![index].imageurl != null
                            ? Image.network(
                                retrievedTasksList![index].imageurl!)
                            : Image.network('https://picsum.photos/200'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(retrievedTasksList![index].description),
                            Text(retrievedTasksList![index].date),
                            Text(retrievedTasksList![index].category),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (String value) async {
                            if (value == 'edit') {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ToDoPage(
                                        task: retrievedTasksList![index])),
                              );
                              _initRetrieval();
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
              ));
  }

  Widget _buildCategoryList() {
    return retrievedcategoryList == null
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: retrievedcategoryList?.length,
            itemBuilder: (BuildContext context, int index) {
              return SingleChildScrollView(
                child: Card(
                  child: ListTile(
                    title: Text(retrievedcategoryList[index]!),
                  ),
                ),
              );
            },
          );
  }
}
