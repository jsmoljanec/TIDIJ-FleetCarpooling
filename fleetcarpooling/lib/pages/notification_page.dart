import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<StatefulWidget> pages = [
    const NotificationPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("Notification page"),
    );
  }
}
