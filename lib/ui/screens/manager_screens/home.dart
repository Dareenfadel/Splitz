import 'package:flutter/material.dart';

import 'package:splitz/data/services/auth.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text('Homee ya manager'),
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              await _auth.signOut();
            },
            icon: Icon(Icons.person),
            tooltip: 'log out',
          )
        ],
      ),
    );
  }
}
