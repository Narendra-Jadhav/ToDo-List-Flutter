import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list_app/models/user.dart';
import 'package:to_do_list_app/services/user_service.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _signupFormKey = GlobalKey<FormState>();

  final _nameController = TextEditingController(),
      _emailController = TextEditingController(),
      _passwordController = TextEditingController();

  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(title: const Text('ToDo List')),
      body: Center(
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
                  obscureText: !_showPassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                      icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_signupFormKey.currentState?.validate() ?? false) {
                      createUser();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 16),
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Text('Sign Up'),
                ),
                const Text("Already have an account?"),
                TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
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
        debugPrint('New User added successfully!');
        // ignore: use_build_context_synchronously
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      } else {
        debugPrint('Failed to retrieve UID for the authenticated user.');
      }
    } catch (e) {
      debugPrint('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Enter correct credentials!'),
        backgroundColor: Colors.red,
      ));
    }
  }
}
