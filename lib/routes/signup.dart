import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list_app/models/user.dart';
import 'package:to_do_list_app/routes/home.dart';
import 'package:to_do_list_app/routes/login.dart';
import 'package:to_do_list_app/services/user_service.dart';

class SignUp extends StatelessWidget {
  final _signupFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(),
      _emailController = TextEditingController(),
      _passwordController = TextEditingController();

  final BuildContext context;

  SignUp({super.key, required this.context});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('ToDo List'),
      ),
      body: Align(
        alignment: Alignment.center,
        child: Container(
          width: 400,
          height: 500,
          padding: const EdgeInsets.fromLTRB(50, 30, 50, 30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Form(
            key: _signupFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  'Create Account',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                TextFormField(
                  controller: _nameController,
                  validator: (value) => value?.isEmpty ?? true ? 'Please enter your name' : null,
                  // validator: (value) {
                  // if (value == null || value.isEmpty) {
                  //   return 'Please enter your name';
                  // }
                  // return null;
                  // },
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextFormField(
                  controller: _emailController,
                  validator: (value) => value?.isEmpty ?? true ? 'Please enter your email' : null,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextFormField(
                  controller: _passwordController,
                  validator: (value) => value?.isEmpty ?? true ? 'Please enter your password' : null,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_signupFormKey.currentState?.validate() ?? false) {
                      createUser();
                    }
                  },
                  style: ButtonStyle(
                    textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 16)),
                    padding: MaterialStateProperty.all(const EdgeInsets.all(16)),
                  ),
                  child: const Text('Sign Up'),
                ),
                const Text("Already have an account?"),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                      return Login(
                        context: context,
                      );
                    }));
                  },
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void createUser() async {
    final name = _nameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      await AuthService().signUpWithEmailAndPassword(email, password);
      final user = FirebaseAuth.instance.currentUser;
      final uid = user?.uid;

      if (uid != null) {
        final newUser = AppUser(
          id: uid,
          name: name,
          email: email,
          password: password,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await getUserRef(uid).set(newUser);
        print('New User added successfully!');
        
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const HomeScreen();
            },
          ),
          (route) => false,
        );
      } else {
        print('Failed to retrieve UID for the authenticated user.');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter correct credentials!')));
    }
  }
}
