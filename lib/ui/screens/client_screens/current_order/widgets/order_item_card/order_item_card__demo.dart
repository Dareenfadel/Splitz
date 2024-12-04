import 'package:flutter/material.dart';
import 'package:splitz/ui/screens/client_screens/current_order/widgets/order_item_card/order_item_card__in_receipt.dart';
import 'package:splitz/ui/screens/client_screens/current_order/widgets/order_item_card/order_item_card__request.dart';
import 'package:splitz/ui/screens/client_screens/current_order/widgets/order_item_card/order_item_card_props.dart';

// ignore: camel_case_types
class OrderItemCard_Demo extends StatelessWidget {
  const OrderItemCard_Demo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              OrderItemCard_Request(
                requestor: OrderItemCardProps_User(
                    id: "1", name: "Mathew", imageUrl: "X"),
                item: OrderItemCardProps_Item(
                    title: 'Cheeseburger',
                    notes: 'With extra cheese and bacon',
                    imageUrl:
                        'https://www.foodandwine.com/thmb/jldKZBYIoXJWXodRE9ut87K8Mag=/750x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/crispy-comte-cheesburgers-FT-RECIPE0921-6166c6552b7148e8a8561f7765ddf20b.jpg',
                    totalPrice: 159.99,
                    sharePrice: 53.33,
                    sharedWith: [
                      OrderItemCardProps_SharedWithUser(
                        id: "1",
                        name: 'John',
                        imageUrl: 'https://picsum.photos/200',
                        pendingApproval: true,
                      ),
                      OrderItemCardProps_SharedWithUser(
                        id: "2",
                        name: 'Sarah',
                        imageUrl: 'https://picsm.photos/100',
                        pendingApproval: false,
                      ),
                      OrderItemCardProps_SharedWithUser(
                        id: "3",
                        name: 'Mike',
                        imageUrl: 'https://picsum.hotos/300',
                        pendingApproval: false,
                      ),
                    ],
                    id: '1'),
                onApprovePressed: () {},
                onRejectPressed: () {},
              ),
              const SizedBox(height: 16),
              OrderItemCard_InReceipt(
                item: OrderItemCardProps_Item(
                    title: 'Cheeseburger',
                    notes: 'With extra cheese and bacon',
                    imageUrl:
                        'https://www.foodandwine.com/thmb/jldKZBYIoXJWXodRE9ut87K8Mag=/750x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/crispy-comte-cheesburgers-FT-RECIPE0921-6166c6552b7148e8a8561f7765ddf20b.jpg',
                    totalPrice: 159.99,
                    sharePrice: 53.33,
                    sharedWith: [
                      OrderItemCardProps_SharedWithUser(
                        id: "1",
                        name: 'John',
                        imageUrl: 'https://picsum.photos/200',
                        pendingApproval: true,
                      ),
                      OrderItemCardProps_SharedWithUser(
                        id: "2",
                        name: 'Sarah',
                        imageUrl: 'https://picsm.photos/100',
                        pendingApproval: false,
                      ),
                      OrderItemCardProps_SharedWithUser(
                        id: "3",
                        name: 'Mike',
                        imageUrl: 'https://picsum.hotos/300',
                        pendingApproval: false,
                      ),
                    ],
                    id: '2'),
                onManagePressed: () {},
              ),
              const SizedBox(height: 16),
              OrderItemCard_InReceipt(
                item: OrderItemCardProps_Item(
                    title: 'Cheeseburger',
                    notes: 'With extra cheese and bacon',
                    imageUrl:
                        'https://www.foodandwine.com/thmb/jldKZBYIoXJWXodRE9ut87K8Mag=/750x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/crispy-comte-cheesburgers-FT-RECIPE0921-6166c6552b7148e8a8561f7765ddf20b.jpg',
                    totalPrice: 159.99,
                    sharePrice: 53.33,
                    sharedWith: [
                      OrderItemCardProps_SharedWithUser(
                        id: "1",
                        name: 'John',
                        imageUrl: 'https://picsum.photos/200',
                        pendingApproval: false,
                      ),
                      OrderItemCardProps_SharedWithUser(
                        id: "2",
                        name: 'Sarah',
                        imageUrl: 'https://picsm.photos/100',
                        pendingApproval: false,
                      ),
                    ],
                    id: '3'),
                onManagePressed: () {},
              ),
              const SizedBox(height: 16),
              OrderItemCard_InReceipt(
                item: OrderItemCardProps_Item(
                    title: 'Spicy Chicken Wrap',
                    notes: 'Hot sauce and fresh vegetables',
                    imageUrl: 'https://example.com/wrap.jpg',
                    totalPrice: 89.99,
                    sharePrice: 29.99,
                    sharedWith: [
                      OrderItemCardProps_SharedWithUser(
                        id: "4",
                        name: 'John',
                        imageUrl: 'https://picsum.photos/200',
                        pendingApproval: false,
                      ),
                    ],
                    id: '4'),
                onManagePressed: () {},
              ),
              const SizedBox(height: 16),
              OrderItemCard_InReceipt(
                item: OrderItemCardProps_Item(
                  title: 'Supreme Pizza',
                  notes: 'All toppings, family size',
                  imageUrl: 'https://example.com/pizza.jpg',
                  totalPrice: 249.99,
                  sharePrice: 62.50,
                  id: '5',
                ),
                onManagePressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
