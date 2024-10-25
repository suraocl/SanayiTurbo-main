// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:sanayi_turbo/interface/screens/notifications_screen.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  print("backgroundHandler:");
  print(message.data.toString());
  print(message.notification?.title ?? "");

  openNotification(message.data);
}

class PushNotificationHelper {
  static String fcmToken = "";
  static Future<void> initialized() async {
    await Firebase.initializeApp();

    if (Platform.isAndroid) {
      // Local Notification Initalized
      NotificationHelper.initialized();
    } else if (Platform.isIOS) {
      FirebaseMessaging.instance.requestPermission();
    }
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    getDeviceTokenToSendNotification();

    // If App is Terminated state & used click notification
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      print("FirebaseMessaging.instance.getInitialMessage");

      if (message != null) {
        print("New Notification");
        print(message.data.toString());
        print(message.notification?.title ?? "");
      }
    });

    // App is Forground this method  work
    FirebaseMessaging.onMessage.listen((message) {
      print("FirebaseMessaging.onMessage.listen");
      if (message.notification != null) {
        print(message.notification!.title);
        print(message.notification!.body);
        print(message.data);

        if (Platform.isAndroid) {
          // Local Notification Code to Display Alert
          NotificationHelper.displayNotification(message);
        }
      }
    });

    // App on Backaground not Terminated
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("FirebaseMessaging.onMessageOpenedApp.listen");
      if (message.notification != null) {
        print(message.notification!.title);
        print(message.notification!.body);
        print(message.data);

        openNotification(message.data);
      }
    });

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
  }

  static Future<String> getDeviceTokenToSendNotification() async {
    fcmToken = (await FirebaseMessaging.instance.getToken()).toString();
    print("FCM Token: $fcmToken");

    return fcmToken;
  }
}

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialized() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    flutterLocalNotificationsPlugin.initialize(
        const InitializationSettings(android: initializationSettingsAndroid),
        onDidReceiveNotificationResponse: (details) {
      print(details.toString());
      print("localBackgroundHandler :");
      print(details.notificationResponseType ==
              NotificationResponseType.selectedNotification
          ? "selectedNotification"
          : "selectedNotificationAction");
      print(details.payload);

      try {
        var payloadObj = json.decode(details.payload ?? "{}") as Map? ?? {};
        openNotification(payloadObj);
      } catch (e) {
        print(e);
      }
    }, onDidReceiveBackgroundNotificationResponse: localBackgroundHandler);
  }

  static void displayNotification(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
            "push_notification_demo", "push_notification_demo_channel",
            importance: Importance.max, priority: Priority.high),
      );

      await flutterLocalNotificationsPlugin.show(
          id,
          message.notification!.title,
          message.notification!.body,
          notificationDetails,
          payload: json.encode(message.data));
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> sendPushMessage(String body, String title, String token) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAlq0zeMk:APA91bH0COxWYpggN0XfXkhTCS7MKxe5aXTzVfA-9lhjmJII_8UEiZNZ-QXtEXgt71x_QOtdZUlXRgmT1vlD5V9rwzqwsGZtXZ7fqBAip2GMtUSVZYNrtlsY4yWgYjjb00bRgQob8oI2',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title,
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": token
          },
        ),
      );
      print('done');
    } catch (e) {
      print("error push notification");
    }
  }

  Future<void> getBuyProductNotification(
      String recipientToken, String message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your_channel_id', 'your_channel_name',
            importance: Importance.max, priority: Priority.high);

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Yeni Talep!',
      message,
      platformChannelSpecifics,
      payload: recipientToken,
    );
  }
}

Future<void> localBackgroundHandler(NotificationResponse data) async {
  print(data.toString());
  print("localBackgroundHandler :");
  print(data.notificationResponseType ==
          NotificationResponseType.selectedNotification
      ? "selectedNotification"
      : "selectedNotificationAction");
  print(data.payload);

  try {
    var payloadObj = json.decode(data.payload ?? "{}") as Map? ?? {};
    openNotification(payloadObj);
  } catch (e) {
    print(e);
  }
}

void openNotification(Map payloadObj) async {
  await Future.delayed(const Duration(milliseconds: 300));
  if (payloadObj["user_login_need"].toString() == "true") {
/*    if(Globs.udValueBool(Globs.userLogin)) {
      // App inside user login
      if( payloadObj["user_id"].toString() == controller.user.toString() ) {
        // Notification Payload Data user id current
        openNotificationScreen(payloadObj);
      }else{
        // Notification Payload Data user id not match
        print("skip open screen");
      }
    }else{
      // App inside not user login
    //  pushRedirect = true;
      // pushPayload = payloadObj;

    }*/
  } else {
    //User not need
    openNotificationScreen(payloadObj);
  }
}

void openNotificationScreen(Map payloadObj) {
  try {
    if (payloadObj.isNotEmpty) {
      switch (payloadObj["page"] as String? ?? "") {
        case "detail":
          Get.offAll(const NotificationsScreen());
          break;
        case "data":
          Get.offAll(const NotificationsScreen());

          break;
        default:
      }
    }
  } catch (e) {
    print(e);
  }
}
