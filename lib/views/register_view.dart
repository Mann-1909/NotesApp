import 'package:first/constants/routes.dart';
import 'package:first/services/auth/auth_exceptions.dart';
import 'package:first/services/auth/auth_service.dart';
import 'package:first/utilities/show_error_dialog.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    // TODO: implement initState
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Register",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      backgroundColor: Colors.tealAccent,
      body: Padding(
        padding: EdgeInsets.fromLTRB(30, 0, 30, 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock, size: 100, color: Colors.black54),
            TextField(
              cursorColor: Colors.red,
              autofocus: false,
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: 'Enter Your E-mail here',
              ),
            ),
            Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 5)),
            TextField(
                cursorColor: Colors.red,
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Enter Your Password here',
                )),
            Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 5)),
            TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  await AuthService.firebase().login(email: email, password: password);
                  // final user = AuthService.firebase().currentUser;
                  await AuthService.firebase().sendEmailVerification();
                  Navigator.of(context).pushNamed(verifyemailRoute);
                } on WeakPasswordAuthException {
                  await showErrorDialog(context, "Weak Password");
                } on EmailAlreadyInUseAuthException {
                  await showErrorDialog(context, "Email is Already In Use");
                } on InvalidEmailAuthException {
                  await showErrorDialog(context, "Invalid Email Entered");
                } on GenericAuthException {
                  await showErrorDialog(context, "Authentication Error");
                }
              },
              child: const Text(
                "Register",
                style: TextStyle(fontSize: 25, color: Colors.indigoAccent),
              ),
            ),
            Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 5)),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
                },
                child: const Text('Already registered? Go back to Login Page!'))
          ],
        ),
      ),
    );
  }
}
