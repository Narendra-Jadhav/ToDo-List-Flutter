import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list_app/components/task_checkbox.dart';
import 'package:to_do_list_app/components/task_content.dart';
import 'package:to_do_list_app/components/task_footer.dart';
import 'package:to_do_list_app/models/task.dart';
import 'package:to_do_list_app/services/task_service.dart';

// ignore: must_be_immutable
class Note extends StatelessWidget {
  const Note({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: Consumer(
        builder: (context, ref, child) {
          final tasksSnapshot = ref.watch(tasksProvider);
          final user = FirebaseAuth.instance.currentUser;
          final uid = user?.uid;

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

                    return Container(
                      margin: const EdgeInsets.all(10.0),
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
                        header: TaskCheckbox(task: task, uid: uid, isChecked: isChecked),
                        footer: TaskFooter(task: task, uid: uid),
                        child: TaskContent(task: task, uid: uid, isChecked: isChecked),
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
}
