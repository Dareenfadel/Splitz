import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:splitz/data/models/user.dart';

class SelectableUserList extends StatelessWidget {
  final List<UserModel> users;
  final void Function(UserModel)? onUserSelected;
  final void Function(UserModel)? onUserDeselected;
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
      children: users.map((user) => _buildItem(user)).toList(),
    );
  }

  Padding _buildItem(UserModel userModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(50),
        color: Colors.grey.withOpacity(0.5),
        strokeWidth: selectedUsersIds.contains(userModel.uid) ? 0 : 3,
        padding: EdgeInsets.zero,
        child: FilterChip(
          checkmarkColor: Colors.white,
          elevation: 4,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
              side: const BorderSide(style: BorderStyle.none)),
          selected: selectedUsersIds.contains(userModel.uid),
          onSelected: (selected) {
            if (selected) {
              onUserSelected?.call(userModel);
            } else {
              onUserDeselected?.call(userModel);
            }
          },
          padding: const EdgeInsets.all(10),
          avatar: CircleAvatar(
            backgroundImage: NetworkImage(userModel.imageUrl ?? ''),
            radius: 32,
          ),
          avatarBoxConstraints: const BoxConstraints.tightForFinite(),
          label: SizedBox(
            width: double.infinity,
            child: Text(
              userModel.name ?? "Unknown",
              style: const TextStyle(fontSize: 20),
            ),
          ),
          labelPadding:
              const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        ),
      ),
    );
  }
}
