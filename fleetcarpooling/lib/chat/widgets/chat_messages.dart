import 'package:firebase_auth/firebase_auth.dart';
import 'package:fleetcarpooling/chat/models/message.dart';
import 'package:fleetcarpooling/chat/widgets/message_bubble.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  ChatMessages({super.key});
  final messages = [
    Message(
        senderId: 'jR4alnTKbUTOIroHFsHAFLId1va2',
        receiverId: 'gNfEHSQZ5ZUcY6JG5AarK8O0SVw1',
        content: 'Hello',
        sentTime: DateTime.now(),
        messageType: MessageType.text),
    Message(
        senderId: 'gNfEHSQZ5ZUcY6JG5AarK8O0SVw1',
        receiverId: 'jR4alnTKbUTOIroHFsHAFLId1va2',
        content: 'How are you?',
        sentTime: DateTime.now(),
        messageType: MessageType.text),
  ];
  @override
  Widget build(BuildContext context) => ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final isTextMessage = messages[index].messageType == MessageType.text;
          final isMe = FirebaseAuth.instance.currentUser?.uid ==
              messages[index].senderId;

          return isTextMessage
              ? MessageBubble(
                  isMe: isMe,
                  message: messages[index],
                  isImage: false,
                )
              : MessageBubble(
                  isMe: isMe,
                  message: messages[index],
                  isImage: true,
                );
        },
      );
}
