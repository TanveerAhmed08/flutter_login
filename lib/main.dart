import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/Pages/login_page.dart';
import 'package:flutter_login/firebase_options.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const FirebaseLoginApp());
}

class FirebaseLoginApp extends StatelessWidget {
  const FirebaseLoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withOpacity(0.4),
          hintStyle: const TextStyle(color:Colors.greenAccent,fontFamily: "Gothic"),
          // border: const OutlineInputBorder(),
          labelStyle: const TextStyle(color: Colors.amberAccent,fontFamily: "Gothic"),
          counterStyle: const TextStyle(color: Colors.redAccent, fontSize: 12.0,fontFamily: "Gothic")
        ),
        // buttonTheme: const ButtonThemeData(
        //   buttonColor: Colors.deepPurple,
        //   textTheme: ButtonTextTheme.primary
        //   ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black45
        ),
        textTheme: const TextTheme(
          titleMedium: TextStyle(fontFamily: "Gothic"),
          bodyMedium: TextStyle(fontFamily: "Gothic")
        )
      ),
    );
  }
}