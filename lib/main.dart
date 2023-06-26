import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:to_do_list_app/routes/home.dart";
import "package:to_do_list_app/routes/login.dart";
import "package:to_do_list_app/routes/signup.dart";
import "package:to_do_list_app/routes/welcome.dart";

import "firebase_options.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo List',
      initialRoute: '/',
      routes: {
        '/': (context) {
          if (user != null) {
            return const HomeScreen();
          } else {
            return const Welcome();
          }
        },
        '/signup': (context) => SignUp(
              context: context,
            ),
        '/login': (context) => Login(
              context: context,
            ),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.light(primary: Colors.amber[700]!),
        fontFamily: GoogleFonts.varelaRound().fontFamily,
      ),
    );
  }
}
