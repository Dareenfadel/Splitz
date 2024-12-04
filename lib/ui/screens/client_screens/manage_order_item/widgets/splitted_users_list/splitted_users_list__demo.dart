import 'package:flutter/material.dart';

import 'splitted_users_list.dart';

// ignore: camel_case_types
class SplittedUsersList_Demo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SplittedUsersList(
                users: [
                  SplittedUsersListProps_User(
                    id: "1",
                    name: "John",
                    imageUrl: "https://picsum.photos/200",
                    pendingApproval: true,
                  ),
                  SplittedUsersListProps_User(
                    id: "2",
                    name: "Sarah",
                    imageUrl: "https://picsum.photos/201",
                    pendingApproval: false,
                  ),
                  SplittedUsersListProps_User(
                    id: "3",
                    name: "Mike",
                    imageUrl: "https://picsum.photos/202",
                    pendingApproval: true,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
