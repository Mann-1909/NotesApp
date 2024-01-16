
import 'package:first/constants/routes.dart';
import 'package:first/services/auth/auth_service.dart';
import 'package:first/views/login_view.dart';
import 'package:first/views/notes/new_note_view.dart';
import 'package:first/views/notes/notes_view.dart';
import 'package:first/views/register_view.dart';
import 'package:first/views/verify_email_view.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

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
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      verifyemailRoute: (context) => const VerifyEmailView(),
      notesRoute: (context) => const NotesView(),
      newNoteRoute:(context)=>const NewNoteView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = (AuthService.firebase().currentUser);
            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }

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
