import 'package:flutter/material.dart';
import 'package:sanayi_turbo/service/push_notification_helper.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<String> notifications = []; // Bildirimleri tutacak liste

  @override
  void initState() {
    super.initState();
    NotificationHelper.initialized();
    NotificationHelper.displayNotification;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bildirimler'),
      ),
      body: notifications.isEmpty
          ? Center(
              child: Text('Henüz bildirim yok.'),
            )
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(notifications[index]),
                );
              },
            ),
    );
  }
}
