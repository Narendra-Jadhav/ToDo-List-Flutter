import 'package:flutter/material.dart';
import 'package:to_do_list_app/routes/login.dart';
import 'package:to_do_list_app/routes/signup.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'ToDo List',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
                ),
              ),
              const SizedBox(height: 100),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Login(
                      context: context,
                    );
                  }));
                },
                style: ButtonStyle(
                    textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 16)),
                    padding: MaterialStateProperty.all(const EdgeInsets.all(16)),
                  ),
                child: const Text('Login'),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SignUp(
                      context: context,
                    );
                  }));
                },
                style: ButtonStyle(
                    textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 16)),
                    padding: MaterialStateProperty.all(const EdgeInsets.all(16)),
                  ),
                child: const Text('Sign Up'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
