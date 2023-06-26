import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list_app/services/user_service.dart';

import '../models/task.dart';

final tasksProvider = StreamProvider<List<Task>?>((ref) async* {
  final user = ref.watch(authProvider).asData?.value;
  if (user == null) {
    yield null;
  } else {
    await for (final tasks in getTaskRef(user.uid).snapshots()) {
      yield tasks.docs.map((taskDoc) => taskDoc.data()).toList();
    }
  }
});

CollectionReference<Task> getTaskRef(final String uid) {
  return FirebaseFirestore.instance.collection('users').doc(uid).collection('tasks').withConverter<Task>(
        fromFirestore: (doc, _) => Task.fromDoc(docId: doc.id, data: doc.data()!),
        toFirestore: (task, _) => task.toJson(),
      );
}
