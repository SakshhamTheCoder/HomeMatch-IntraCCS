import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailVerifyView extends StatefulWidget {
  const EmailVerifyView({super.key});

  @override
  State<EmailVerifyView> createState() => _EmailVerifyViewState();
}

class _EmailVerifyViewState extends State<EmailVerifyView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          const Text(
            "Please verify your email",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              await user?.sendEmailVerification();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Verification email sent. Please login after verification."),
                ),
              );
              Navigator.of(context).pushNamedAndRemoveUntil('/login/', (route) => false);
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.resolveWith<EdgeInsetsGeometry?>(
                (states) => const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
            child: const Text(
              "Send Email Verification",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ],
      ),
    ));
  }
}
