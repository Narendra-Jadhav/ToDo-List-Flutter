import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list_app/models/task.dart';
import 'package:to_do_list_app/services/task_service.dart';

class TaskFooter extends StatelessWidget {
  final Task task;
  final String? uid;
  final _updateFormKey = GlobalKey<FormState>();
  final updatedTaskTitle = TextEditingController(), updatedTaskDesc = TextEditingController();

  TaskFooter({super.key, required this.task, required this.uid});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: Colors.transparent,
          child: IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: SizedBox(
                      width: 350,
                      child: Text(
                        task.title,
                        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                    content: SizedBox(
                      width: 350,
                      child: SingleChildScrollView(
                        child: Text(task.description),
                      ),
                    ),
                    actions: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.close, color: Colors.amber, size: 21.0),
                        splashRadius: 20,
                      )
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.zoom_out_map, color: Colors.amber, size: 21.0),
            splashRadius: 20,
          ),
        ),
        Material(
          color: Colors.transparent,
          child: IconButton(
            onPressed: () {
              updatedTaskTitle.text = task.title;
              updatedTaskDesc.text = task.description;
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Edit Task', style: TextStyle(fontWeight: FontWeight.bold)),
                    content: Form(
                      key: _updateFormKey,
                      child: SizedBox(
                        width: 300,
                        height: 500,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              controller: updatedTaskTitle,
                              decoration: const InputDecoration(labelText: 'Title'),
                              validator: (value) => value?.isEmpty ?? true ? 'Please enter a valid title' : null,
                            ),
                            SizedBox(
                              height: 400,
                              child: SingleChildScrollView(
                                child: TextFormField(
                                  controller: updatedTaskDesc,
                                  maxLines: null,
                                  decoration: const InputDecoration(labelText: 'Description'),
                                  validator: (value) =>
                                      value?.isEmpty ?? true ? 'Please enter a valid description' : null,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          if (_updateFormKey.currentState?.validate() ?? false) {
                            updateTask(uid!, task.id, updatedTaskTitle.text, updatedTaskDesc.text);

                            Navigator.of(context).pop();
                            updatedTaskTitle.clear();
                            updatedTaskDesc.clear();
                          }
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.edit, color: Colors.amber, size: 21.0),
            splashRadius: 20,
          ),
        ),
        Material(
          color: Colors.transparent,
          child: IconButton(
            onPressed: () {
              deleteTask(uid!, task.id);
            },
            icon: const Icon(Icons.delete, color: Colors.amber, size: 21.0),
            splashRadius: 20,
          ),
        ),
        const Spacer(),
        Text(DateFormat('dd-MM-yyyy HH:mm:ss').format(task.updatedAt)),
        const SizedBox(
          width: 12.0,
        )
      ],
    );
  }

  Future<void> deleteTask(String uid, String taskId) async {
    final taskRef = getTaskRef(uid).doc(taskId);
    await taskRef.delete();
  }

  Future<void> updateTask(String uid, String taskId, String taskTitle, String taskDesc) async {
    final taskRef = getTaskRef(uid).doc(taskId);
    await taskRef.update({'title': taskTitle, 'description': taskDesc, 'updatedAt': DateTime.now()});
  }
}
