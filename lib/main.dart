import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:first/views/login_view.dart';
import 'package:first/views/register_view.dart';
import 'package:first/views/verify_email_view.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      useMaterial3: true,
    ),
    home: const HomePage(),
    routes:{
      '/login/':(context)=>const LoginView(),
      '/register/':(context)=>const RegisterView(),
      '/verify-email/':(context)=>const VerifyEmailView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return  FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
          final user = (FirebaseAuth.instance.currentUser);
          if(user!=null){
            if (user?.emailVerified ?? false) {
              print('Your Email is verified');
            } else {
              return const VerifyEmailView();
            }
          }
          else{
            return LoginView();
          }
          return Text('Done');
          default:
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 8,
                ),
              ),
            );
        }
      },
    );
  }
}


