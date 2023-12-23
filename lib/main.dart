import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:first/views/login_view.dart';
import 'package:first/views/register_view.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      useMaterial3: true,
    ),
    home: const HomePage(),
  ));
}
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text("Home Page"),
        backgroundColor: Colors.blueGrey,
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user=(FirebaseAuth.instance.currentUser);
              if(user?.emailVerified??false){
                print('Your Email is verified');
              }
              else{
                print('You need to verify your Email first');
              }
              return Text('Done');
            default:
              return const Text("Loading.....");
          }
        },
      ),
    );
  }
}



