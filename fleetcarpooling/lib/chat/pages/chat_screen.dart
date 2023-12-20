import 'package:fleetcarpooling/ui_elements/buttons.dart';
import 'package:fleetcarpooling/ui_elements/colors';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String vin;
  final String brand;
  final String model;
  const ChatScreen(
      {super.key, required this.vin, required this.brand, required this.model});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 70,
        title: Padding(
          padding: EdgeInsets.only(top: 15.0),
          child: Text(
            '${widget.brand} ${widget.model} ',
            style: TextStyle(
                color: AppColors.mainTextColor, fontWeight: FontWeight.w400),
          ),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: CircularIconButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.black,
            height: 0.5,
          ),
        ),
      ),
    );
  }
}
