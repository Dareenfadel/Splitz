import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:splitz/data/models/menu_item.dart';
import 'package:splitz/data/models/restaurant.dart';
import 'package:splitz/data/services/menu_item_service.dart';
import 'package:splitz/data/services/restaurant_service.dart';
import 'package:splitz/main.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;

class NotificationsService {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    _firebaseMessaging.getToken().then((token) {
      print('Token: $token');
    });
    await _firebaseMessaging.subscribeToTopic('offers');
    print('Subscribed to offers topic');

    initPushNotifications();
  }

  Future initPushNotifications() async {
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received a message while in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        RemoteNotification notification = message.notification!;

        print(
            'Message also contained a notification: ${notification.title}, ${notification.body}');
      }
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
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
      print(response.body);
    } else {
      print('Failed to send notification. Error: ${response.statusCode}');
    }
  }

  void handleMessage(RemoteMessage? message) {
    print('Message: $message');
    if (message == null) return;
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print('Handling a background message: ${message.messageId}');
  }
}
