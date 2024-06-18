import 'package:firebaseauthsigninsignup/custom_functions/auth_service.dart';
import 'package:firebaseauthsigninsignup/custom_functions/task_category_list.dart';
import 'package:firebaseauthsigninsignup/utilities/taskmodel.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? loggedInUser;
  List<TaskModel>? retrievedTasksList = [];
  List<String> retrievedCategoryList = [];
  int _selectedIndex = 0;
  QueryDocumentSnapshot<Object?>? _lastDocument;
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  bool isStopLoading = false;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    _initRetrieval();
    _fetchData();
    _scrollController.addListener(_onScroll);
  }
  Future<void> _initRetrieval() async {
    var fetchedData = await fetchCategory();
    setState(() {
      retrievedCategoryList = fetchedData;
    });
  }

  List<TaskModel> modelToList(QuerySnapshot querySnapshot) {
    return querySnapshot.docs
        .map((docSnapshot) => TaskModel.fromDocument(
            docSnapshot.data() as Map<String, dynamic>, docSnapshot.id))
        .toList();
  }

  Future<void> _refreshData() async {
    isStopLoading = false;
    await _fetchData(isRefresh: true);
  }

  Future<void> _fetchData({bool isRefresh = false}) async {
    QuerySnapshot querySnapshot;
    if (isStopLoading) {
      return;
    }

    if (isRefresh) {
      _lastDocument = null;
      setState(() {
        retrievedTasksList = null;
      });
    }

    if (_lastDocument == null) {
      querySnapshot = await FirebaseFirestore.instance
          .collection("tasks")
          .where('id', isEqualTo: loggedInUser!.uid)
          .limit(8)
          .get();
    } else {
      querySnapshot = await FirebaseFirestore.instance
          .collection("tasks")
          .where('id', isEqualTo: loggedInUser!.uid)
          .startAfterDocument(_lastDocument!)
          .limit(8)
          .get();

      isStopLoading = querySnapshot.docs.length < 8;
    }

    if (querySnapshot.docs.isNotEmpty) {
      _lastDocument = querySnapshot.docs.last;
      setState(() {
        retrievedTasksList = [
          ...(retrievedTasksList ?? []),
          ...modelToList(querySnapshot)
        ];
      });
    }

    isLoading = false;
  }

  Future<List<String>> fetchCategory() async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await db.collection("categoryList").get();
    return querySnapshot.docs.map((doc) => doc['category'] as String).toList();
  }

  Future<void> getCurrentUser() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        loggedInUser = user;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !isLoading) {
      isLoading = true;
      _fetchData();
    }
  }

  Future<void> deleteTask(TaskModel taskModel) async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection('tasks').doc(taskModel.taskId).delete();
    _refreshData();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _logout() async {
    await AuthService().onTapLogOut(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex == 0
          ? buildTaskList(
              context: context,
              retrievedTasksList: retrievedTasksList,
              initRetrieval: _initRetrieval,
              logout: _logout,
              deleteTask: deleteTask,
            )
          : buildCategoryList(retrievedCategoryList: retrievedCategoryList),
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
}
