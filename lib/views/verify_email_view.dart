
import 'package:first/constants/routes.dart';
import 'package:first/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Your Email!')),
      body: Column(
        children: [
          const Text("We've sent an email-verification. Please open it to verify your account"),
          const Text("If you haven't recieved a verification email yet, press the button below"),
          TextButton(
              onPressed: () async {
                // final user = AuthService.firebase().currentUser;
                await AuthService.firebase().sendEmailVerification();
              },
              child: const Text('Send Email Verification')),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().logout();
              Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
            child: const Text('Restart'),
          )
        ],
      ),
    );
  }
}
