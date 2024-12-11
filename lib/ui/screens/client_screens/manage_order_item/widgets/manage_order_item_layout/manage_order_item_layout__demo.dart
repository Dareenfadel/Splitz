// import 'package:flutter/material.dart';

// import '../selectable_users_list/selectable_users_list_props.dart';
// import '../splitted_users_list/splitted_users_list.dart';
// import 'manage_order_item_page.dart';

// // ignore: camel_case_types
// class ManageOrderItemPage_Demo extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: ManageOrderItemPage(
//         splittedWithUsers: [
//           SplittedUsersListProps_User(
//             id: "1",
//             name: "John",
//             imageUrl: "https://picsum.photos/200",
//             pendingApproval: true,
//           ),
//           SplittedUsersListProps_User(
//             id: "2",
//             name: "Sarah",
//             imageUrl: "https://picsum.photos/201",
//             pendingApproval: false,
//           ),
//           SplittedUsersListProps_User(
//             id: "3",
//             name: "Mike",
//             imageUrl: "https://picsum.photos/202",
//             pendingApproval: true,
//           ),
//         ],
//         notSplittedWithUsers: [
//           SelectableUsersListProps_User(
//               id: "1", name: "John", imageUrl: "https://picsum.photos/200"),
//           SelectableUsersListProps_User(
//               id: "2", name: "Sarah", imageUrl: "https://picsum.photos/201"),
//           SelectableUsersListProps_User(
//               id: "3", name: "Mike", imageUrl: "https://picsum.photos/202"),
//         ],
//         onRequestPressed: (List<String> selectedUsers) {},
//         onLeavePressed: () {},
//       ),
//     );
//   }
// }
