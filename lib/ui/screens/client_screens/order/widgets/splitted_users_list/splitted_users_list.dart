import 'package:flutter/material.dart';

// ignore: camel_case_types
class SplittedUsersListProps_User {
  final String id;
  final String name;
  final String imageUrl;
  final bool pendingApproval;

  SplittedUsersListProps_User({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.pendingApproval,
  });
}

class SplittedUsersList extends StatelessWidget {
  final List<SplittedUsersListProps_User> users;

  const SplittedUsersList({
    super.key,
    required this.users,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: users
          .map(
            (user) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Card(
                elevation: 4,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(user.imageUrl),
                        radius: 32,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 16,
                          ),
                          child: Text(
                            user.name,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      if (user.pendingApproval)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Icon(Icons.hourglass_top_rounded,
                              size: 16, color: Colors.grey[600]),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
