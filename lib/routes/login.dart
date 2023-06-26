import 'package:flutter/material.dart';
import 'package:to_do_list_app/routes/home.dart';
import 'package:to_do_list_app/routes/signup.dart';
import 'package:to_do_list_app/services/user_service.dart';

class Login extends StatelessWidget {
  final _loginFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(), _passwordController = TextEditingController();

  final BuildContext context;

  Login({super.key, required this.context});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(title: const Text('ToDo List')),
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
            key: _loginFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  'Welcome Back',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
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
                    if (_loginFormKey.currentState?.validate() ?? false) {
                      loginUser();
                    }
                  },
                  style: ButtonStyle(
                    textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 16)),
                    padding: MaterialStateProperty.all(const EdgeInsets.all(16)),
                  ),
                  child: const Text('Login'),
                ),
                const Text("Don't have an account? Create One!"),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                      return SignUp(
                        context: context,
                      );
                    }));
                  },
                  child: const Text('Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void loginUser() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      await AuthService().loginWithEmailAndPassword(email, password);
      print('Logged In Successfully!');

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const HomeScreen();
          },
        ),
        (route) => false,
      );
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter correct credentials!')));
    }
  }
}
