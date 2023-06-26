import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list_app/components/create_task.dart';
import 'package:to_do_list_app/components/note.dart';
import 'package:to_do_list_app/models/user.dart';
import 'package:to_do_list_app/routes/welcome.dart';
import 'package:to_do_list_app/services/user_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Row(
          children: [
            const Text('ToDo List'),
            const Spacer(),
            FutureBuilder<AppUser?>(
              future: getName(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return Text('Hello, ${snapshot.data!.name}');
                } else {
                  return const Text('Unknown User');
                }
              },
            ),
            const SizedBox(width: 20),
            IconButton(
              onPressed: () {
                AuthService().signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                  return const Welcome();
                }));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logged Out Successfully!')));
              },
              icon: const Icon(Icons.logout, color: Colors.white),
            ),
          ],
        ),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CreateTask(),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Note(),
            ),
          ),
        ],
      ),
    );
  }

  Future<AppUser?> getName() async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;

    if (uid != null) {
      final userSnapshot = await getUserRef(uid).get();
      final userData = userSnapshot.data();
      if (userData != null) {
        return AppUser.fromMap(docId: uid, user: userData);
      }
    }
    return null;
  }
}
