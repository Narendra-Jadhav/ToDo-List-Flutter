import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list_app/models/task.dart';
import 'package:to_do_list_app/services/task_service.dart';

// ignore: must_be_immutable
class Note extends StatelessWidget {
  final _updateFormKey = GlobalKey<FormState>();
  final updatedTaskTitle = TextEditingController(), updatedTaskDesc = TextEditingController();

  Note({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: Consumer(
        builder: (context, ref, child) {
          final tasksSnapshot = ref.watch(tasksProvider);

          return tasksSnapshot.when(
            data: (tasks) {
              if (tasks == null) {
                // Handle the case when tasks is null (user not authenticated)
                return const Text('Not authenticated');
              } else if (tasks.isEmpty) {
                // Handle the case when there are no tasks
                return const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'No Tasks for now, Create One!',
                      style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold, color: Colors.black54),
                    ),
                  ),
                );
              } else {
                // Display the tasks
                List<Task> sortedTasks = [...tasks]; // Create a copy of the tasks list
                sortedTasks.sort((a, b) {
                  // Sort the tasks based on isChecked and updatedAt properties
                  if (a.isChecked == b.isChecked) {
                    // If both tasks have the same isChecked value, sort by updatedAt
                    return b.updatedAt.compareTo(a.updatedAt);
                  } else {
                    // Sort the tasks with unchecked tasks first, followed by checked tasks
                    return a.isChecked ? 1 : -1;
                  }
                });

                return GridView.builder(
                  itemCount: tasks.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, crossAxisSpacing: 15, mainAxisSpacing: 15, childAspectRatio: 1.9),
                  itemBuilder: (context, index) {
                    final task = sortedTasks[index];
                    bool isChecked = task.isChecked;

                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
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
                        child: GridTile(
                          header: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 5, 0),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Checkbox(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                activeColor: Colors.green,
                                checkColor: Colors.white,
                                value: isChecked,
                                onChanged: (bool? value) {
                                  isChecked = value!;
                                  completeTask('KOBMWD0vjZPcee7Nu2ZUthhX2JH3', task.id, value);
                                },
                              ),
                            ),
                          ),
                          footer: Row(
                            children: [
                              Material(
                                color: Colors.transparent,
                                child: IconButton(
                                  onPressed: () {
                                    deleteTask('KOBMWD0vjZPcee7Nu2ZUthhX2JH3', task.id);
                                  },
                                  icon: const Icon(Icons.delete, color: Colors.amber, size: 21.0),
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
                                                    validator: (value) =>
                                                        value?.isEmpty ?? true ? 'Please enter a valid title' : null,
                                                  ),
                                                  SizedBox(
                                                    height: 400,
                                                    child: SingleChildScrollView(
                                                      child: TextFormField(
                                                        controller: updatedTaskDesc,
                                                        maxLines: null,
                                                        decoration: const InputDecoration(labelText: 'Description'),
                                                        validator: (value) => value?.isEmpty ?? true
                                                            ? 'Please enter a valid description'
                                                            : null,
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
                                                  updateTask('KOBMWD0vjZPcee7Nu2ZUthhX2JH3', task.id,
                                                      updatedTaskTitle.text, updatedTaskDesc.text);
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
                              const Spacer(),
                              Text(DateFormat('dd-MM-yyyy HH:mm:ss').format(task.updatedAt)),
                              const SizedBox(
                                width: 12.0,
                              )
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  task.title,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: isChecked ? Colors.black38 : Colors.black),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  task.description,
                                  style: TextStyle(fontSize: 15, color: isChecked ? Colors.black38 : Colors.black),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
            loading: () {
              // Display a loading indicator
              return const Center(
                child: SizedBox(
                  width: 40.0,
                  height: 40.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 4.0, // Adjust the stroke width as needed
                  ),
                ),
              );
            },
            error: (error, stackTrace) {
              // Handle any errors that occurred during data retrieval
              return Text('Error: $error');
            },
          );
        },
      ),
    );
  }

  Future<void> deleteTask(String uid, String taskId) async {
    final taskRef = getTaskRef(uid).doc(taskId);
    await taskRef.delete();
  }

  Future<void> completeTask(String uid, String taskId, bool isChecked) async {
    final taskRef = getTaskRef(uid).doc(taskId);
    await taskRef.update({'isChecked': isChecked});
  }

  Future<void> updateTask(String uid, String taskId, String taskTitle, String taskDesc) async {
    final taskRef = getTaskRef(uid).doc(taskId);
    await taskRef.update({'title': taskTitle, 'description': taskDesc, 'updatedAt': DateTime.now()});
  }
}
