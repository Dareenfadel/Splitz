import 'package:splitz/data/models/user.dart';

// ignore: camel_case_types
class SelectableUsersListProps_User {
  final String id;
  final String name;
  final String imageUrl;

  SelectableUsersListProps_User({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory SelectableUsersListProps_User.fromUserModel(UserModel user) {
    return SelectableUsersListProps_User(
      id: user.uid,
      name: user.name ?? 'Unknown',
      imageUrl: user.imageUrl ?? '',
    );
  }
}
