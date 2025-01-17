import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:splitz/constants/app_colors.dart';
import 'package:splitz/data/models/menu_item.dart';
import 'package:splitz/data/models/order_item.dart';
import 'package:splitz/data/models/restaurant.dart';
import 'package:splitz/data/models/user.dart';
import 'package:splitz/data/services/menu_item_service.dart';
import 'package:splitz/data/services/order_item_service.dart';
import 'package:splitz/data/services/order_service.dart';
import 'package:splitz/data/services/restaurant_service.dart';
import 'package:splitz/data/services/users_service.dart';
import 'package:splitz/main.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:splitz/ui/screens/client_screens/menu.dart';
import 'package:toastification/toastification.dart';

class SplittingRequestNotificationTypes {
  static const String splitRequest = 'split_request';
  static const String splitRequestAccepted = 'split_request_accepted';
  static const String splitRequestRejected = 'split_request_rejected';

  static const String splitEquallyRequest = 'split_equally_request';
  static const String splitEquallyRequestAccepted =
      'split_equally_request_accepted';
  static const String splitEquallyRequestRejected =
      'split_equally_request_rejected';
      
  static const String splitLeave = 'split_leave';
  static const String splitJoin = 'split_join';

  static const String prefix = 'split_';
  
}

class NotificationsService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  NotificationsService._privateConstructor();
  static final NotificationsService _instance =
      NotificationsService._privateConstructor();
  factory NotificationsService() => _instance;

  static final OrderService _orderService = OrderService();
  static final OrderItemService _orderItemService = OrderItemService();

  static StreamSubscription<RemoteMessage>? _onMessageSubscription;

  Future<void> initNotifications(String userId) async {
    await _firebaseMessaging.requestPermission();
    _firebaseMessaging.getToken().then((token) async {
      print('FCM Token: $token');
      if (token != null) {
        await saveTokenToDatabase(userId, token);
      }
    });
    await _firebaseMessaging.subscribeToTopic('offers');
    print('Subscribed to offers topic');
    initPushNotifications();
  }

  Future<void> saveTokenToDatabase(String userId, String token) async {
    // Assuming you have a User model and a UserService to handle database operations
    UsersService userService = UsersService();
    await userService.updateUserFcmToken(userId, token);
  }

  Future initPushNotifications() async {
    // Handle when the app is in the background and notification is tapped
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleMessage(message); // Handle background notification tap
    });
    // Handle when the app is in the foreground
    _onMessageSubscription?.cancel(); // Cancel the previous subscription
    _onMessageSubscription =
        FirebaseMessaging.onMessage.listen(_firebaseMessagingForegroundHandler);
  }

  Future<void> handleInitialMessage() async {
    final RemoteMessage? initialMessage =
        await _firebaseMessaging.getInitialMessage();

    if (initialMessage != null) {
      handleMessage(initialMessage);
    }
  }

  static Future<String> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "guc-splitz",
      "private_key_id": "0edafc479ed563b99fdaca427fd5d095cc4752ae",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQD5LYuWieXpQtj8\nm3zDBY1gCdWK5EI0hrjwfiqDjd1QJWOIl/ggS40lH6HkieNJuXShDpd5JtpAoP+7\nUSu21lZsIzX3/YA4S/7PalOPxQam7/d8FSJlVQMFvYT9qN3XS/du7kXh4XHJ2MZn\neISHp6iwX08V/pUozcLcxRpasZCgDFxBlPrs70EWjsnAD8gELXcx7L5LjLHBxSLS\nFwjJBS4n8F0WdbUNk1sFC14DoDuk5P7aUkTCiwKGLFeVGmpdPLUIQc/15kFI7/Yg\nCd9v7zRtUySE8L3kTBbjCxwi61I+lY2WfdwA9iH5s7slU42koKoFMTHF+RaFtvjN\nb8K8swpzAgMBAAECggEAK1E4n/3vAwME970MDlcrwZNUFSYjQEBfbCdyupXx8Fnf\nmMJadzrLGbYLDdDOu2VLGiiQOpZ/gJa8flLZF5rhQUFJw4fFP4Qukt44Epk8086J\npn+CED2cHeZZdUNi9WeWZyly6pankmBl9VzlJTQHRkn7VKaCRaqngnudXkDaFIhZ\nvP06Cu56N0VRTZqPMPbcjRfWPsCOuiFTwCYXA7iqZ9kKkPl3PltBPKo6om2WFQ5i\nUdOCxDhy+gfT2GO4v4EF3PE49riF7aRaJ4LFfGiG1ZyJB73Nb9gDVC0Fnl0j6p8u\nt2nn9D8iPIeh+L1p9KoBWOEcVcQpCDUQWC+q5zTBIQKBgQD9PgC5qCRqEm1C1Gg5\nIPWGQootpkpezfiRB+q3NfukrZj0KfZUoxzJqBZS3NOhSia5nE6dsmbkanmyGwRS\nGJNxrapb2+oVK2jLenjtfa7iEUHvCmGNIrAYTnesa9uaMr9sRtSFxT07yABw60zt\nE9zgOCJPh2pchDrwBGpem0oykQKBgQD75DY9cf173Htk1dydQa5S3C/dgICwl3JJ\nt8vZ/lxhfgn4Ghad64qwA4+yia85KFUrjevSNhxFa3hzuTyPa9TYtlte+yU111Nb\nAVAHju8Qoch7VOGJ7MlVvK1IDAaRPvnOBjF5U/FgtTKGo9QCYBiFrLxvzsfqx59M\nuozWgV0mwwKBgQDX5UQ5A2AIDi2YC/3OtoqbK58hy+Mbb/25p0Yza5JdkqIThrK6\n9VRVlzdw7VJ+7viUxO1BBBc0JJIbhWzpkIojICtcpN+rrJZq4r61ubCeipfrcq43\n5Jq8HilolYtiqmEHrlsAsGbD0H6PxgqPE5/6h+C4bHoA5bpZZWpJvZpEAQKBgByR\nmJlFeXN34ULhgqEPVv8s2/zqWy4sLxkvUF6MG9wu2GCcTN5iXZty+/RK62W3Llm/\nQfTYkEJLWyD87GJz33Mo05olL+Y4YsrajkIdMv4W608ZpG7pPTiNKrYWLxSAKQL1\n7tyM6b6HLpDYue3/Cij3G3Qu5ru5IlcofVrC11bTAoGBALl8Au3Xf33L0GbOq6S/\nvV9EqSJmKsAUNtqejAzHNGPvOEja8FLHfa0lueasXgNjNZLHHfSkV6OY6+1SOvmK\nfrBRJATVmNKmN49Nxz3/ABjcGOy4o4vrYRio8rX2sDSy8FMd7sKjHgBgQT6RUwzK\nUhZQK8Kknz/N1uRqq7E7TExI\n-----END PRIVATE KEY-----\n",
      "client_email": "split-z-manager@guc-splitz.iam.gserviceaccount.com",
      "client_id": "117375620398876537192",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/split-z-manager%40guc-splitz.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/firebase.messaging",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/userinfo.email"
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    // get the access token
    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
            auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
            scopes,
            client);

    client.close();

    return credentials.accessToken.data;
  }

  static sendNotificationToTopic(
      String topic, String restaurantId, String itemId) async {
    final String serverAccessTokenKey = await getAccessToken();
    String endpointFirebaseCloudMessaging =
        "https://fcm.googleapis.com/v1/projects/guc-splitz/messages:send";

    RestaurantService restaurantService = RestaurantService();
    Restaurant restaurant =
        await restaurantService.fetchRestaurantById(restaurantId);

    MenuItemModel? item =
        await MenuItemService().fetchMenuItemWithDetails(restaurantId, itemId);

    final Map<String, dynamic> message = {
      'message': {
        'topic': topic,
        'notification': {
          'title': 'New Offer!',
          'body': '${item?.name} from ${restaurant.name}!'
        },
        'data': {
          'restaurantId': restaurantId,
          'itemId': itemId,
          'type': 'offer',
        }
      }
    };

    final http.Response response = await http.post(
      Uri.parse(endpointFirebaseCloudMessaging),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverAccessTokenKey'
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification. Error: ${response.statusCode}');
    }
  }

  static Future<void> sendNotificationViaFcmToken({
    required String fcmToken,
    required String title,
    required String body,
    required Map<String, String> data,
  }) async {
    if (fcmToken == null || fcmToken.isEmpty) {
      print('FCM token is null or empty [$fcmToken]');
      return;
    }

    final String serverAccessTokenKey = await getAccessToken();
    String endpointFirebaseCloudMessaging =
        "https://fcm.googleapis.com/v1/projects/guc-splitz/messages:send";

    final Map<String, dynamic> message = {
      'message': {
        'token': fcmToken,
        'notification': {'title': title, 'body': body},
        'data': data
      }
    };

    final http.Response response = await http.post(
      Uri.parse(endpointFirebaseCloudMessaging),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverAccessTokenKey'
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification. Error: ${response.body}');

      print('Failed to send notification. Error: ${response.statusCode}');
    }
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    final data = message.data;
    final restaurantId = data['restaurantId'];
    final type = data['type'];

    if (restaurantId != null && type == 'offer') {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => MenuScreen(restaurantId: restaurantId),
        ),
      );
    }

    if (type == 'split') {}
  }

  Future<void> _firebaseMessagingForegroundHandler(
      RemoteMessage message) async {
    print('Received a message while in the foreground!');
    print('Message data: ${message.data}');

    final data = message.data;
    final restaurantId = data['restaurantId'];
    final type = data['type'];

    if (message.notification != null) {
      RemoteNotification notification = message.notification!;

      print(
          'Message also contained a notification: ${notification.title}, ${notification.body}');
    }

    if (type.startsWith(SplittingRequestNotificationTypes.prefix)) {
      handleSplittingRequestNotification(message);
    }
  }

  void handleSplittingRequestNotification(RemoteMessage message) {
    if (navigatorKey.currentContext == null) return;
    if (message.notification == null) return;

    FlutterRingtonePlayer().playNotification();
    toastification.show(
      context: navigatorKey.currentContext!,
      title: Text(message.notification!.title ?? ''),
      description: Text(message.notification!.body ?? ''),
      autoCloseDuration: Duration(seconds: 5),
      alignment: Alignment.topCenter,
      primaryColor: AppColors.primary,
      icon: Icon(Icons.notifications),
    );
  }

  // if (restaurantId != null && type == 'offer') {
  //   RestaurantService restaurantService = RestaurantService();
  //   restaurantService.fetchRestaurantById(restaurantId).then((restaurant) {
  //     ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
  //       SnackBar(content: Text('New offers from ${restaurant.name}')),
  //     );
  //   });

  //   Future.delayed(Duration(seconds: 2), () {
  //     navigatorKey.currentState?.push(
  //       MaterialPageRoute(
  //         builder: (context) => MenuScreen(restaurantId: restaurantId),
  //       ),
  //     );
  //   });
  // }

  static Future<void> _sendSplittingRequestNotificationHelper({
    required String orderId,
    required int itemIndex,
    required String requestedToUserId,
    required Function({
      required OrderItem orderItem,
      required UserModel requestedToUser,
      required UserModel requestedByUser,
    }) sendNotification,
  }) async {
    var (orderItem, usersMap) = await _orderItemService.getOrderItemAndItsUsers(
      orderId: orderId,
      itemIndex: itemIndex,
    );
    print(
        "Trying to get request for $requestedToUserId, orderItem: ${orderItem.toMap()}");
    var request = orderItem.getRequestFor(requestedToUserId);

    var requestedToUser = usersMap[request.userId]!;
    var requestedByUser = usersMap[request.requestedBy]!;

    if (requestedToUser.fcmToken == null || requestedToUser.fcmToken!.isEmpty) {
      print(
          'User with [id=${requestedToUser.uid}] does not have an FCM token [${requestedToUser.fcmToken}]');
      return Future.value();
    }

    if (requestedByUser.fcmToken == null || requestedByUser.fcmToken!.isEmpty) {
      print(
          'User with [id=${requestedByUser.uid}] does not have an FCM token [${requestedByUser.fcmToken}]');
      return Future.value();
    }

    sendNotification(
      orderItem: orderItem,
      requestedToUser: requestedToUser,
      requestedByUser: requestedByUser,
    );
  }

  static Future<void> sendSplittingRequestNotification({
    required String orderId,
    required int itemIndex,
    required String requestedToUserId,
  }) async {
    // Wait for 2 seconds to let the request be saved in the database
    await Future.delayed(Duration(seconds: 2));
    
    return _sendSplittingRequestNotificationHelper(
      orderId: orderId,
      itemIndex: itemIndex,
      requestedToUserId: requestedToUserId,
      sendNotification: ({
        required orderItem,
        required requestedToUser,
        required requestedByUser,
      }) {
        sendNotificationViaFcmToken(
          fcmToken: requestedToUser.fcmToken!,
          title: 'Split Request',
          body:
              '${requestedByUser.name ?? 'Someone'} wants to split ${orderItem.itemName} with you!',
          data: {
            'type': SplittingRequestNotificationTypes.splitRequest,
          },
        );
      },
    );
  }

  static Future<void> sendAcceptSplittingRequestNotification({
    required String orderId,
    required int itemIndex,
    required String requestedToUserId,
  }) async {
    return _sendSplittingRequestNotificationHelper(
      orderId: orderId,
      itemIndex: itemIndex,
      requestedToUserId: requestedToUserId,
      sendNotification: ({
        required orderItem,
        required requestedToUser,
        required requestedByUser,
      }) {
        sendNotificationViaFcmToken(
          fcmToken: requestedByUser.fcmToken!,
          title: 'Split Request Accepted',
          body:
              '${requestedToUser.name ?? 'Someone'} accepted your split request for an ${orderItem.itemName}!',
          data: {
            'type': SplittingRequestNotificationTypes.splitRequestAccepted,
          },
        );
      },
    );
  }

  // This special, because the deleted request is not in the order item
  static Future<void> sendRejectSplittingRequestNotification({
    required OrderItem orderItemBeforeRejecting,
    required Map<String, UserModel> usersMap,
    required String requestedToUserId,
  }) async {
    var request = orderItemBeforeRejecting.getRequestFor(requestedToUserId);
    var requestedToUser = usersMap[request.userId]!;
    var requestedByUser = usersMap[request.requestedBy]!;

    if (requestedToUser.fcmToken == null || requestedToUser.fcmToken!.isEmpty) {
      print(
          'User with [id=${requestedToUser.uid}] does not have an FCM token [${requestedToUser.fcmToken}]');
      return;
    }

    if (requestedByUser.fcmToken == null || requestedByUser.fcmToken!.isEmpty) {
      print(
          'User with [id=${requestedByUser.uid}] does not have an FCM token [${requestedByUser.fcmToken}]');
      return;
    }

    sendNotificationViaFcmToken(
      fcmToken: requestedByUser.fcmToken!,
      title: 'Split Request Rejected',
      body:
          '${requestedToUser.name ?? 'Someone'} rejected your split request for an ${orderItemBeforeRejecting.itemName}!',
      data: {
        'type': SplittingRequestNotificationTypes.splitRequestRejected,
      },
    );
  }

  static Future<void> _sendSplittingEquallyRequestNotificationHelper({
    required String orderId,
    required String requestedByUserId,
  }) async {
    var (order, usersMap) =
        await _orderService.listenToOrderAndItsUsersByOrderId(orderId).first;
    var requestedByUser = usersMap[requestedByUserId]!;
  }

  static Future<void> sendSplittingEquallyRequestNotification({
    required String orderId,
    required String requestedByUserId,
  }) async {
    var (order, usersMap) =
        await _orderService.listenToOrderAndItsUsersByOrderId(orderId).first;
    var requestedByUser = usersMap[requestedByUserId]!;

    for (final user in usersMap.values) {
      if (user.uid == requestedByUser.uid) {
        continue;
      }

      if (user.fcmToken == null) {
        print('User with [id=${user.uid}] does not have an FCM token');
        continue;
      }

      sendNotificationViaFcmToken(
        fcmToken: user.fcmToken!,
        title: 'Split Equally Request',
        body:
            '${requestedByUser.name ?? 'Someone'} wants to split the order equally with you!',
        data: {
          'type': SplittingRequestNotificationTypes.splitEquallyRequest,
        },
      );
    }
  }

  static Future<void> sendAcceptSplittingEquallyRequestNotification({
    required String orderId,
    required String acceptingUserId,
  }) async {
    var (order, usersMap) =
        await _orderService.listenToOrderAndItsUsersByOrderId(orderId).first;
    var acceptingUser = usersMap[acceptingUserId]!;

    for (final user in usersMap.values) {
      if (user.uid == acceptingUser.uid) {
        continue;
      }

      if (user.fcmToken == null) {
        print('User with [id=${user.uid}] does not have an FCM token');
        continue;
      }

      sendNotificationViaFcmToken(
        fcmToken: user.fcmToken!,
        title: 'Split Equally Request Accepted',
        body:
            '${acceptingUser.name ?? 'Someone'} accepted the split equally request!',
        data: {
          'type': SplittingRequestNotificationTypes.splitEquallyRequestAccepted,
        },
      );
    }
  }

  static Future<void> sendRejectSplittingEquallyRequestNotification({
    required String orderId,
    required String rejectingUserId,
  }) async {
    var (order, usersMap) =
        await _orderService.listenToOrderAndItsUsersByOrderId(orderId).first;
    var rejectingUser = usersMap[rejectingUserId]!;

    for (final user in usersMap.values) {
      if (user.uid == rejectingUser.uid) {
        continue;
      }

      if (user.fcmToken == null) {
        print('User with [id=${user.uid}] does not have an FCM token');
        continue;
      }

      sendNotificationViaFcmToken(
        fcmToken: user.fcmToken!,
        title: 'Split Equally Request Rejected',
        body:
            '${rejectingUser.name ?? 'Someone'} rejected the split equally request!',
        data: {
          'type': SplittingRequestNotificationTypes.splitEquallyRequestRejected,
        },
      );
    }
  }

  static Future<void> sendLeaveOrderItemNotification({
    required String orderId,
    required int itemIndex,
    required String leavingUserId,
  }) async {
    var (order, usersMap) =
        await _orderService.listenToOrderAndItsUsersByOrderId(orderId).first;
    var orderItem = order.items[itemIndex];

    for (final user in usersMap.values) {
      if (user.uid == leavingUserId) {
        continue;
      }

      if (user.fcmToken == null) {
        print('User with [id=${user.uid}] does not have an FCM token');
        continue;
      }

      sendNotificationViaFcmToken(
        fcmToken: user.fcmToken!,
        title: 'User Left Order Item',
        body:
            '${user.name ?? 'Someone'} left the order item ${orderItem.itemName}!',
        data: {
          'type': SplittingRequestNotificationTypes.splitLeave,
        },
      );
    }
  }
  
  
  static Future<void> sendJoinOrderItemNotification({
    required String orderId,
    required int itemIndex,
    required String joiningUserId,
  }) async {
    var (order, usersMap) =
        await _orderService.listenToOrderAndItsUsersByOrderId(orderId).first;
    var orderItem = order.items[itemIndex];

    for (final user in usersMap.values) {
      if (user.uid == joiningUserId) {
        continue;
      }

      if (user.fcmToken == null) {
        print('User with [id=${user.uid}] does not have an FCM token');
        continue;
      }

      sendNotificationViaFcmToken(
        fcmToken: user.fcmToken!,
        title: 'User Joined Order Item',
        body:
            '${user.name ?? 'Someone'} joined the order item ${orderItem.itemName}!',
        data: {
          'type': SplittingRequestNotificationTypes.splitJoin,
        },
      );
    }
  }
}
