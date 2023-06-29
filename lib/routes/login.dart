import 'package:flutter/material.dart';
import 'package:to_do_list_app/services/user_service.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _loginFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(), _passwordController = TextEditingController();
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
                    if (_loginFormKey.currentState?.validate() ?? false) {
                      loginUser();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 16),
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Text('Login'),
                ),
                const Text("Don't have an account? Create One!"),
                TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/signup'),
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
      debugPrint('Logged In Successfully!');

      // ignore: use_build_context_synchronously
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } catch (e) {
      debugPrint('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Enter correct credentials!'),
        backgroundColor: Colors.red,
      ));
    }
  }
}
