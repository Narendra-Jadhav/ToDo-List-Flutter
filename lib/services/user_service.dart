import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do_list_app/models/user.dart';

final authProvider = StreamProvider((ref) => FirebaseAuth.instance.authStateChanges());

final userProvider = StreamProvider<AppUser?>((ref) async* {
  final user = ref.watch(authProvider).asData?.value;
  if (user == null) {
    yield null;
  } else {
    await for (final userDoc in getUserRef(user.uid).snapshots()) {
      yield userDoc.data();
    }
  }
});

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Sign up with email and password
  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw 'Error signing up: $e';
    }
  }

  // Login with email and password
  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw 'Error logging in: $e';
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw 'Error signing out: $e';
    }
  }
}

DocumentReference<AppUser> getUserRef(final String uid) {
  return FirebaseFirestore.instance.collection('users').doc(uid).withConverter<AppUser>(
        fromFirestore: (doc, _) => AppUser.fromDoc(docId: doc.id, data: doc.data()!),
        toFirestore: (user, _) => user.toJson(),
      );
}
