import 'package:flutter/material.dart';
import 'package:to_do_list_app/models/task.dart';
import 'package:to_do_list_app/services/task_service.dart';

// ignore: must_be_immutable
class TaskCheckbox extends StatelessWidget {
  final Task task;
  final String? uid;
  bool isChecked;

  TaskCheckbox({super.key, required this.task, required this.uid, required this.isChecked});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            completeTask(uid!, task.id, value);
          },
        ),
      ),
    );
  }

  Future<void> completeTask(String uid, String taskId, bool isChecked) async {
    final taskRef = getTaskRef(uid).doc(taskId);
    await taskRef.update({'isChecked': isChecked});
  }
}
