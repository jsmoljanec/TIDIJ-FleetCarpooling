import 'package:flutter/material.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  List<StatefulWidget> pages = [
    const MapPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("Map page"),
    );
  }
}
