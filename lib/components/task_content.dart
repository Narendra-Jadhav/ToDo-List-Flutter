import 'package:flutter/material.dart';
import 'package:to_do_list_app/models/task.dart';

class TaskContent extends StatelessWidget {
  final Task task;
  final String? uid;
  final bool isChecked;

  const TaskContent({super.key, required this.task, required this.uid, required this.isChecked});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 30, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task.title,
            style:
                TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isChecked ? Colors.black38 : Colors.black),
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
    );
  }
}
