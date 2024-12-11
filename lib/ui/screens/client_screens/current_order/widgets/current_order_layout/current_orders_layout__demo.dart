// import 'package:flutter/material.dart';

// import 'current_order_page.dart';
// import 'current_order_page__all_items_tab.dart';
// import 'current_order_page__requests_tab.dart';
// import '../order_item_card/order_item_card_props.dart';

// // ignore: camel_case_types
// class CurrentOrdersPage_Demo extends StatelessWidget {
//   const CurrentOrdersPage_Demo({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: CurrentOrderPage(
//         requests: [
//           CurrentOrderPage_RequestsTabProps_Item(
//             requestor: OrderItemCardProps_User(
//               name: 'John Doe',
//               imageUrl: 'https://via.placeholder.com/60',
//               id: '1',
//             ),
//             item: OrderItemCardProps_Item(
//               title: 'Juicy Lucy Burger',
//               totalPrice: 150,
//               sharePrice: 50,
//               imageUrl: 'https://via.placeholder.com/60',
//               notes: "Extra cheese",
//               id: '1',
//             ),
//           ),
//           CurrentOrderPage_RequestsTabProps_Item(
//             requestor: OrderItemCardProps_User(
//                 name: 'Jane Smith',
//                 imageUrl: 'https://via.placeholder.com/60',
//                 id: '2'),
//             item: OrderItemCardProps_Item(
//               title: 'Veggie Pizza',
//               totalPrice: 120,
//               sharePrice: 40,
//               imageUrl: 'https://via.placeholder.com/60',
//               notes: "No olives",
//               id: '2',
//             ),
//           ),
//           CurrentOrderPage_RequestsTabProps_Item(
//             requestor: OrderItemCardProps_User(
//                 name: 'Alice Johnson',
//                 imageUrl: 'https://via.placeholder.com/60',
//                 id: '2'),
//             item: OrderItemCardProps_Item(
//               title: 'Chicken Wings',
//               totalPrice: 200,
//               sharePrice: 70,
//               imageUrl: 'https://via.placeholder.com/60',
//               notes: "Spicy",
//               id: '3',
//             ),
//           ),
//         ],
//         myItems: [
//           OrderItemCardProps_Item(
//             title: 'Cheeseburger',
//             totalPrice: 100,
//             sharePrice: 50,
//             imageUrl: 'https://via.placeholder.com/60',
//             notes: "No pickles",
//             id: '4',
//           ),
//           OrderItemCardProps_Item(
//             title: 'Pepperoni Pizza',
//             totalPrice: 150,
//             sharePrice: 75,
//             imageUrl: 'https://via.placeholder.com/60',
//             notes: "Extra pepperoni",
//             id: '5',
//           ),
//           OrderItemCardProps_Item(
//             title: 'Caesar Salad',
//             totalPrice: 80,
//             sharePrice: 40,
//             imageUrl: 'https://via.placeholder.com/60',
//             notes: "No croutons",
//             id: '6',
//           ),
//         ],
//         allItems: [
//           CurrentOrderPage_AllItemsTabProps_Item(
//             item: OrderItemCardProps_Item(
//               title: 'Margherita Pizza',
//               totalPrice: 120,
//               sharePrice: 60,
//               imageUrl: 'https://via.placeholder.com/60',
//               notes: "Extra cheese",
//               id: '7',
//             ),
//             isSharedWithMe: true,
//           ),
//           CurrentOrderPage_AllItemsTabProps_Item(
//             item: OrderItemCardProps_Item(
//               title: 'BBQ Chicken Wings',
//               totalPrice: 90,
//               sharePrice: 45,
//               imageUrl: 'https://via.placeholder.com/60',
//               notes: "Spicy sauce on side",
//               id: '8',
//             ),
//             isSharedWithMe: false,
//           ),
//           CurrentOrderPage_AllItemsTabProps_Item(
//             item: OrderItemCardProps_Item(
//               title: 'Greek Salad',
//               totalPrice: 70,
//               sharePrice: 35,
//               imageUrl: 'https://via.placeholder.com/60',
//               notes: "No onions",
//               id: '9',
//             ),
//             isSharedWithMe: true,
//           )
//         ],
//         totalPrice: 350,
//         onApprovePressed: (String itemId) {},
//         onRejectPressed: (String itemId) {},
//         onManagePressed: (String itemId) {},
//         onSharePressed: (String itemId) {},
//         onProceedToPaymentPressed: () {},
//       ),
//     );
//   }
// }
