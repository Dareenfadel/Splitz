// import 'package:flutter/material.dart';

// import 'selectable_users_list_props.dart';
// import 'selectable_users_list.dart';

// // ignore: camel_case_types
// class SelectableUserList_Demo extends StatefulWidget {
//   @override
//   State<SelectableUserList_Demo> createState() =>
//       _SelectableUserList_DemoState();
// }

// // ignore: camel_case_types
// class _SelectableUserList_DemoState extends State<SelectableUserList_Demo> {
//   final Set<String> _selectedUsers = {};

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SelectableUserList(
//                   users: [
//                     SelectableUsersListProps_User(
//                         id: "1",
//                         name: "John",
//                         imageUrl: "https://picsum.photos/200"),
//                     SelectableUsersListProps_User(
//                         id: "2",
//                         name: "Sarah",
//                         imageUrl: "https://picsum.photos/201"),
//                     SelectableUsersListProps_User(
//                         id: "3",
//                         name: "Mike",
//                         imageUrl: "https://picsum.photos/202"),
//                   ],
//                   selectedUsersIds: _selectedUsers,
//                   onUserSelected: (user) {
//                     print('${user.name} Added');
//                     setState(() {
//                       _selectedUsers.add(user.id);
//                     });
//                   },
//                   onUserDeselected: (user) {
//                     print('${user.name} Removed');
//                     setState(() {
//                       _selectedUsers.remove(user.id);
//                     });
//                   }),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
