import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user.dart';

final uidProvider = Provider((_) => 'KOBMWD0vjZPcee7Nu2ZUthhX2JH3');
final authProvider = StreamProvider((ref) => FirebaseAuth.instance.authStateChanges());

final userProvider = StreamProvider<AppUser?>((ref) async* {
  final uid = ref.watch(uidProvider);
  await for (final userDoc in getUserRef(uid).snapshots()) {
    yield userDoc.data();
  }
});

// final userProvider = StreamProvider<AppUser?>((ref) async* {
//   final user = ref.watch(authProvider).asData?.value;
//   if (user == null) {
//     yield null;
//   } else {
//     await for (final userDoc in getUserRef(user.uid).snapshots()) {
//       yield userDoc.data();
//     }
//   }
// });

DocumentReference<AppUser> getUserRef(final String uid) {
  return FirebaseFirestore.instance.collection('users').doc(uid).withConverter<AppUser>(
        fromFirestore: (doc, _) => AppUser.fromDoc(docId: doc.id, data: doc.data()!),
        toFirestore: (user, _) => user.toJson(),
      );
}