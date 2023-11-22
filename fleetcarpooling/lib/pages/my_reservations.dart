import 'package:flutter/material.dart';

class MyReservationsPage extends StatefulWidget {
  const MyReservationsPage({super.key});

  @override
  State<MyReservationsPage> createState() => _MyReservationsPageState();
}

class _MyReservationsPageState extends State<MyReservationsPage> {
  List<StatefulWidget> pages = [
    const MyReservationsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("My reservations page"),
    );
  }
}
