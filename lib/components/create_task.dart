import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list_app/models/task.dart';
import 'package:to_do_list_app/services/task_service.dart';

class CreateTask extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _titleControl = TextEditingController(), _descControl = TextEditingController();
  CreateTask({super.key});

  @override
  Widget build(BuildContext context) {
    void postTask() async {
      final user = FirebaseAuth.instance.currentUser;
      final uid = user?.uid;

      if (uid != null) {
        await getTaskRef(uid).add(
          Task(
            id: '',
            title: _titleControl.text,
            description: _descControl.text,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            isChecked: false,
          ),
        );

        debugPrint('Task added!');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Task added!')));
      } else {
        debugPrint('Task not added');
      }
    }

    return Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
          ],
        ),
      ),
    );
  }
}
