import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:google_fonts/google_fonts.dart";
import "package:to_do_list_app/firebase_options.dart";
import "package:to_do_list_app/routes/home.dart";
import "package:to_do_list_app/routes/login.dart";
import "package:to_do_list_app/routes/signup.dart";
import "package:to_do_list_app/routes/welcome.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo List',
      home: const Welcome(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/signup': (context) => const SignUp(),
        '/login': (context) => const Login(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.light(primary: Colors.amber[700]!),
        fontFamily: GoogleFonts.varelaRound().fontFamily,
      ),
    );
  }
}
