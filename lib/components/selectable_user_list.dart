
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

class SelectableUsersListProps_User {
  final String id;
  final String name;
  final String imageUrl;

  SelectableUsersListProps_User({
    required this.id,
    required this.name,
    required this.imageUrl,
  });
}

class SelectableUserList extends StatelessWidget {
  final List<SelectableUsersListProps_User> users;
  final void Function(SelectableUsersListProps_User)? onUserSelected;
  final void Function(SelectableUsersListProps_User)? onUserDeselected;
  final Set<String> selectedUsersIds;

  const SelectableUserList({
    super.key,
    required this.users,
    this.onUserSelected,
    this.onUserDeselected,
    this.selectedUsersIds = const {},
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: users
          .map(
            (user) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: Radius.circular(50),
                color: Colors.grey.withOpacity(0.5),
                strokeWidth: selectedUsersIds.contains(user.id) ? 0 : 3,
                padding: EdgeInsets.zero,
                child: FilterChip(
                  checkmarkColor: Colors.white,
                  elevation: 4,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: BorderSide(style: BorderStyle.none)),
                  selected: selectedUsersIds.contains(user.id),
                  onSelected: (selected) {
                    if (selected) {
                      onUserSelected?.call(user);
                    } else {
                      onUserDeselected?.call(user);
                    }
                  },
                  padding: EdgeInsets.all(10),
                  avatar: CircleAvatar(
                    backgroundImage: NetworkImage(user.imageUrl),
                    radius: 32,
                  ),
                  avatarBoxConstraints: BoxConstraints.tightForFinite(),
                  label: SizedBox(
                    width: double.infinity,
                    child: Text(
                      user.name,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  labelPadding:
                      EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
