import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
final class AppUser {
  final String id, name, email, password;
  final DateTime createdAt, updatedAt;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AppUser.fromDoc({required final String docId, required final Map<String, dynamic> data}) {
    return AppUser(
      id: docId,
      name: data['name'] as String,
      email: data['email'] as String,
      password: data['password'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
