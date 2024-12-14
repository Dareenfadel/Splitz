import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notification =
        ModalRoute.of(context)!.settings.arguments as RemoteNotification;

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text(notification?.title ?? 'No Title'),
            subtitle: Text(notification?.body ?? 'No Body'),
          ),
        ],
      ),
    );
  }
}
