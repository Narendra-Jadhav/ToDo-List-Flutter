import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
final class Task {
  final String id, title, description;
  final bool isChecked;
  final DateTime createdAt, updatedAt;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.isChecked,
  });

  factory Task.fromDoc({required final docId, required final Map<String, dynamic> data}) {
    return Task(
      id: docId,
      title: data['title'] as String,
      description: data['description'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      isChecked: data['isChecked'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isChecked': isChecked,
    };
  }
}
