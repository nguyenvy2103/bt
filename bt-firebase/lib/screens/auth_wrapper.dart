import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'main_navigation.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          return const MainNavigation();
        }
        return const LoginScreen();
      },
    );
  }
}
