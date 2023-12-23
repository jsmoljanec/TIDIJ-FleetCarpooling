import 'dart:async';
import 'package:fleetcarpooling/chat/models/message.dart';
import 'package:fleetcarpooling/chat/provider/firebase_provider.dart';
import 'package:fleetcarpooling/ui_elements/colors';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:provider/provider.dart';

bool isSameChat = false;

class MessageBubble extends StatefulWidget {
  const MessageBubble({
    Key? key,
    required this.isMe,
    required this.isImage,
    required this.message,
  }) : super(key: key);

  final bool isMe;
  final bool isImage;
  final Message message;

  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  late String username = "";
  late String profileImage = "";
  late bool statusActivity = false;
  late Timer _timer;
  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _timer = Timer.periodic(Duration(seconds: 15), (Timer timer) {
      _fetchUserData();
    });
  }

  void _fetchUserData() {
    FirebaseProvider().getUserData(widget.message.senderId).then((userData) {
      if (mounted) {
        setState(() {
          username = userData['username'] ?? '';
          profileImage = userData['profileImage'] ?? '';
          if (userData['statusActivity'] == "online")
            statusActivity = true;
          else
            statusActivity = false;
        });
        if (!isSameChat) {
          Provider.of<FirebaseProvider>(context, listen: false).scrollDown();
          isSameChat = true;
        }
      }
    }).catchError((error) {
      print("Error fetching user data: $error");
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.isMe
      ? Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: _buildMessageContainer(),
            ),
          ],
        )
      : Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: _buildMessageContainer(),
            ),
          ],
        );

  Widget _buildMessageContainer() => Row(
        mainAxisAlignment:
            widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              if (!widget.isMe)
                (profileImage != "" && profileImage != null)
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(profileImage),
                        radius: 20,
                      )
                    : CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Image.asset("assets/icons/profile.png"),
                        radius: 20,
                      ),
              if (!widget.isMe)
                CircleAvatar(
                  backgroundColor: statusActivity ? Colors.green : Colors.grey,
                  radius: 5,
                ),
            ],
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: widget.isMe
                  ? AppColors.backgroundColor
                  : AppColors.backgroundColor,
              borderRadius: widget.isMe
                  ? const BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                      topLeft: Radius.circular(30),
                      bottomLeft: Radius.circular(30))
                  : const BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      topLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
            margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: widget.isMe
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: [
                Text(
                  username,
                  style: const TextStyle(
                    color: AppColors.mainTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                widget.isImage
                    ? Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: NetworkImage(widget.message.content),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : Text(widget.message.content,
                        style: const TextStyle(color: AppColors.mainTextColor)),
                const SizedBox(height: 5),
                Text(
                  timeago.format(widget.message.sentTime),
                  style: const TextStyle(
                    color: AppColors.mainTextColor,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          if (widget.isMe)
            (profileImage != "" && profileImage != null)
                ? CircleAvatar(
                    backgroundImage: NetworkImage(profileImage),
                    radius: 20,
                  )
                : CircleAvatar(
                    child: Image.asset("assets/icons/profile.png"),
                    radius: 20,
                  ),
        ],
      );
}
