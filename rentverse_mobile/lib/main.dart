import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/auth/ui/login_screen.dart';
// import 'features/security/ui/login_screen.dart';

void main() {
  runApp(const ProviderScope(child: RentVerseApp()));
}

class RentVerseApp extends StatelessWidget {
  const RentVerseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  const LoginScreen(),
    );
  }
}
