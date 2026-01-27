import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/ui_helper.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "UTH SmartTasks",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.login),
              label: const Text("Sign in with Google"),
              onPressed: () async {
                showLoading(context);
                try {
                  final user = await auth.signInWithGoogle();
                  hideLoading(context);

                  if (user != null) {
                    showSnackBar(context, "Đăng nhập thành công");
                  }
                } catch (e) {
                  hideLoading(context);
                  showSnackBar(context, "Đăng nhập thất bại", success: false);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
