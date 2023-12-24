import 'package:fleetcarpooling/chat/widgets/message_bubble.dart';
import 'package:provider/provider.dart';
import 'package:fleetcarpooling/chat/provider/firebase_provider.dart';
import 'package:fleetcarpooling/chat/widgets/chat_messages.dart';
import 'package:fleetcarpooling/chat/widgets/chat_text_field.dart';
import 'package:fleetcarpooling/ui_elements/buttons.dart';
import 'package:fleetcarpooling/ui_elements/colors';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen(
      {super.key, required this.vin, required this.brand, required this.model});
  final String vin;
  final String brand;
  final String model;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    isSameChat = false;
    Provider.of<FirebaseProvider>(context, listen: false)
        .getMessages(widget.vin);
    super.initState();
  }

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
              isSameChat = false;
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
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 250),
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/logo.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ChatMessages(receiverId: widget.vin),
                ChatTextField(
                  receiverId: widget.vin,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
