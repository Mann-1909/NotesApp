
import 'package:first/constants/routes.dart';
import 'package:first/enums/menu_action.dart';
import 'package:first/services/auth/auth_service.dart';
import 'package:first/utilities/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;



class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main UI"),
        backgroundColor: Colors.blue,
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldlogout = await showLogOutDialog(context);
                  devtools.log(shouldlogout.toString());
                  if (shouldlogout) {
                    await AuthService.firebase().logout();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (route) => false,
                    );
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem(
                  value: MenuAction.logout,
                  child: Text('Log Out'),
                ),
              ];
            },
          )
        ],
      ),
      body: const Text('Hello world'),
    );
  }
}


