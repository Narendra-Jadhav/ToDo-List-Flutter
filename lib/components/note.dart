import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list_app/services/task_service.dart';

class _Checkbox extends StatefulWidget {
  final bool isChecked;
  final ValueChanged<bool?> onChanged;
  const _Checkbox({Key? key, required this.isChecked, required this.onChanged}) : super(key: key);

  @override
  State<_Checkbox> createState() => _CheckboxState();
}

class _CheckboxState extends State<_Checkbox> {
  bool isChecked = false;

  @override
  void initState() {
    isChecked = widget.isChecked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      activeColor: Colors.green,
      checkColor: Colors.white,
      value: isChecked,
      onChanged: (bool? value) {
        widget.onChanged;
        setState(() {
          isChecked = value!;
        });
      },
    );
  }
}

class Note extends StatelessWidget {
  const Note({super.key});

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
                return GridView.builder(
                  itemCount: tasks.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, crossAxisSpacing: 15, mainAxisSpacing: 15, childAspectRatio: 1.9),
                  itemBuilder: (context, index) {
                    final task = tasks[index];

                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.0)),
                        child: GridTile(
                          header: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 5, 0),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: _Checkbox(
                                isChecked: task.isChecked,
                                onChanged: (value) {
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
                                  onPressed: () {},
                                  icon: const Icon(Icons.edit, color: Colors.amber, size: 21.0),
                                  splashRadius: 20,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 190.0),
                                child: Text(DateFormat('dd-MM-yyyy').format(task.createdAt)),
                              )
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(task.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 10),
                                Text(task.description, style: const TextStyle(fontSize: 15)),
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

  Future<void> completeTask(String uid, String taskId, bool? isChecked) async {
    final taskRef = getTaskRef(uid).doc(taskId);
    await taskRef.update({'isChecked': isChecked});
  }
}
