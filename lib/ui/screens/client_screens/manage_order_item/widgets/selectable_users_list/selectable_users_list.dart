
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import 'selectable_users_list_props.dart';


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
                radius: const Radius.circular(50),
                color: Colors.grey.withOpacity(0.5),
                strokeWidth: selectedUsersIds.contains(user.id) ? 0 : 3,
                padding: EdgeInsets.zero,
                child: FilterChip(
                  checkmarkColor: Colors.white,
                  elevation: 4,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: const BorderSide(style: BorderStyle.none)),
                  selected: selectedUsersIds.contains(user.id),
                  onSelected: (selected) {
                    if (selected) {
                      onUserSelected?.call(user);
                    } else {
                      onUserDeselected?.call(user);
                    }
                  },
                  padding: const EdgeInsets.all(10),
                  avatar: CircleAvatar(
                    backgroundImage: NetworkImage(user.imageUrl),
                    radius: 32,
                  ),
                  avatarBoxConstraints: const BoxConstraints.tightForFinite(),
                  label: SizedBox(
                    width: double.infinity,
                    child: Text(
                      user.name,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  labelPadding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
