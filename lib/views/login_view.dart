import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        title: Text("Login"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Enter Your E-mail here',
            ),
          ),
          TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                hintText: 'Enter Your Password here',
              )),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                final usercredential = await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                    email: email, password: password);
                print(usercredential);
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  print("User not Found");
                } else if (e.code == 'wrong-password') {
                  print("Wrong Password");
                }
              }
            },
            child: const Text(
              "Login",
              style: TextStyle(fontSize: 25, color: Colors.indigoAccent),
            ),
          ),
          TextButton(onPressed: (){
              Navigator.of(context).pushNamedAndRemoveUntil('/register/', (route) => false);
          },
              child: Text('Not registered yet? Register here!'))
        ],
      ),
    );
  }
}
