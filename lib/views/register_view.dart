import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../firebase_options.dart';

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
        title: Text("Register"),
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
                    .createUserWithEmailAndPassword(
                    email: email, password: password);
                print(usercredential);
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  print("Weak Password");
                } else if (e.code == 'email-already-in-use') {
                  print('Email Already In Use');
                } else if (e.code == 'invalid-email') {
                  print('Invalid Email Entered');
                }
              }
            },
            child: const Text(
              "Register",
              style: TextStyle(fontSize: 25, color: Colors.indigoAccent),
            ),
          ),
          TextButton(onPressed: (){
            Navigator.of(context).pushNamedAndRemoveUntil('/login/', (route) => false);
          }, child:const Text('Already registered? Go back to Login Page!'))
        ],
      ),
    );
  }
}
