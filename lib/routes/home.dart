import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list_app/components/note.dart';
import 'package:to_do_list_app/models/user.dart';
import 'package:to_do_list_app/routes/welcome.dart';
import 'package:to_do_list_app/services/user_service.dart';

import '../models/task.dart';
import '../services/task_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleControl = TextEditingController(), _descControl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Row(
          children: [
            const Text('ToDo List'),
            const Spacer(),
            FutureBuilder<AppUser?>(
              future: getName(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasData && snapshot.data != null) {
                  return Text('Hello, ${snapshot.data!.name}');
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const Text('Not a valid user');
                }
              },
            ),
            const SizedBox(width: 20),
            IconButton(
              onPressed: () {
                AuthService().signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                  return const Welcome();
                }));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logged Out Successfully!')));
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
      body: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Container(
          width: 300.0,
          margin: const EdgeInsets.all(16.0),
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: 3,
                blurRadius: 10,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              TextFormField(
                controller: _titleControl,
                style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  hintText: 'Enter Title',
                  hintStyle: TextStyle(color: Colors.black26),
                  border: InputBorder.none,
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter a valid title' : null,
              ),
              SizedBox(
                height: 450,
                child: SingleChildScrollView(
                  child: TextFormField(
                    controller: _descControl,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Enter Description',
                      hintStyle: TextStyle(color: Colors.black26),
                      border: InputBorder.none,
                    ),
                    validator: (value) => value?.isEmpty ?? true ? 'Please enter a valid description' : null,
                  ),
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton.small(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      postTask();
                      _titleControl.clear();
                      _descControl.clear();
                    }
                  },
                  backgroundColor: Colors.blue[800],
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),
            ]),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Note(),
          ),
        ),
      ]),
    );
  }

  void postTask() async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;

    if (uid != null) {
      await getTaskRef(uid).add(Task(
        id: '',
        title: _titleControl.text,
        description: _descControl.text,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isChecked: false,
      ));

      print('Task added!');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Task added!')));
    } else {
      print('Task not added');
    }
  }

  Future<AppUser?> getName() async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;

    if (uid != null) {
      final userSnapshot = await getUserRef(uid).get();
      final userData = userSnapshot.data();
      if (userData != null) {
        return AppUser.fromMap(docId: uid, user: userData);
      }
    }
    return null;
  }
}
