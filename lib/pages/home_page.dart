import 'package:firebase_connection_1/services/strings.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {
            /// TODO: log out feature
          }, icon: const Icon(Icons.logout))
        ],
      ),
      drawer:  Drawer(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text("accountName"),
              accountEmail: Text("accountEmail"),
            ),
            ListTile(
              onTap: () {
                /// TODO: delete account feature
              },
              title: const Text(I18N.deleteAccount),
            )
          ],
        ),
      ),
    );
  }
}
