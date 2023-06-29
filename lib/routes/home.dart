import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list_app/components/create_task.dart';
import 'package:to_do_list_app/components/note.dart';
import 'package:to_do_list_app/services/user_service.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider).asData?.value;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Row(
          children: [
            const Text('ToDo List'),
            const Spacer(),
            Text(user == null ? 'Loading...' : user.name),
            const SizedBox(width: 20),
            IconButton(
              onPressed: () {
                AuthService().signOut();
                Navigator.pushReplacementNamed(context, '/');
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
}
