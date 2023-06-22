import 'package:flutter/material.dart';
import 'package:to_do_list_app/components/note.dart';

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
      appBar: AppBar(title: const Text('ToDo List')),
      body: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Container(
          width: 300.0,
          margin: const EdgeInsets.all(16.0),
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.0)),
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
                height: 500,
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
    await getTaskRef('KOBMWD0vjZPcee7Nu2ZUthhX2JH3').add(Task(
      id: '',
      title: _titleControl.text,
      description: _descControl.text,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isChecked: false,
    ));
  }
}
