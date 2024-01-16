import 'package:first/constants/routes.dart';
import 'package:first/enums/menu_action.dart';
import 'package:first/services/auth/auth_service.dart';
import 'package:first/services/crud/notes_service.dart';
import 'package:first/utilities/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NotesService _notesService;

  String get userEmail => AuthService.firebase().currentUser!.email!;

  @override
  void initState() {
    _notesService = NotesService();
    return super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _notesService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Notes",style: TextStyle(color:Colors.white),),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(newNoteRoute);
            },
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          PopupMenuButton<MenuAction>(
              icon: Icon(Icons.more_vert, color: Colors.white),
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
              })
        ],
      ),
      body: FutureBuilder(
        future: _notesService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                stream: _notesService.allNotes,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      // TODO: Handle this case.
                      return const Text('waiting for all states');
                      break;
                    case ConnectionState.active:


                    default:
                      return const CircularProgressIndicator();
                  }
                },
              );
            // TODO: Handle this case.
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
