import 'dart:async';
import 'package:fleetcarpooling/chat/models/message.dart';
import 'package:fleetcarpooling/chat/provider/firebase_provider.dart';
import 'package:core/ui_elements/colors';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

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
  late String email = "";
  late String role = "";
  late String name = "";
  late String lastname = "";
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
          name = userData['firstName'] ?? '';
          role = userData['role'] ?? '';
          email = userData['email'] ?? '';
          lastname = userData['lastName'] ?? '';
          username = userData['username'] ?? '';
          profileImage = userData['profileImage'] ?? '';
          if (userData['statusActivity'] == "online") {
            statusActivity = true;
          } else {
            statusActivity = false;
          }
        });
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

  Widget buildDialog(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.buttonColor, width: 2),
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    (profileImage != "" && profileImage != null)
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(profileImage),
                            radius: 30,
                          )
                        : CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Image.asset("assets/icons/profile.png"),
                            radius: 30,
                          ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: CircleAvatar(
                        backgroundColor:
                            statusActivity ? Colors.green : Colors.grey,
                        radius: 7,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${name} ${lastname}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: AppColors.mainTextColor)),
                    const SizedBox(height: 5),
                    Text(email,
                        style: const TextStyle(
                            fontSize: 13, color: AppColors.mainTextColor)),
                    const SizedBox(height: 5),
                    Text(role,
                        style: const TextStyle(
                            fontSize: 13, color: AppColors.mainTextColor)),
                  ],
                ),
              ],
            ),
            const Divider(
              height: 20,
              color: AppColors.mainTextColor,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Padding(
                padding: EdgeInsets.only(bottom: 1),
                child: Text(
                  'Close',
                  style: TextStyle(
                    color: AppColors.mainTextColor,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return buildDialog(context);
                },
              );
            },
            child: Stack(
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
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: CircleAvatar(
                      backgroundColor:
                          statusActivity ? Colors.green : Colors.grey,
                      radius: 5,
                    ),
                  ),
              ],
            ),
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
                      topLeft: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))
                  : const BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
            ),
            margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: widget.isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (!widget.isMe && role == "Employee")
                  Text(
                    username,
                    style: const TextStyle(
                      color: AppColors.mainTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                const SizedBox(height: 5),
                widget.isImage
                    ? GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                child: InteractiveViewer(
                                  child: Image.network(widget.message.content),
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: NetworkImage(widget.message.content),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    : Container(
                        constraints: BoxConstraints(maxWidth: 200),
                        child: Text(
                          widget.message.content,
                          style: const TextStyle(
                            color: AppColors.mainTextColor,
                          ),
                          maxLines: 10,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
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
        ],
      );
}
