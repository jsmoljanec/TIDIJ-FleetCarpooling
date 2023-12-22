import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:fleetcarpooling/chat/models/message.dart';
import 'package:flutter/material.dart';

class FirebaseProvider extends ChangeNotifier {
  ScrollController scrollController = ScrollController();
  List<Message> messages = [];

  Future<Map<String, dynamic>> getUserData(String userId) async {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref("Users/$userId");
      DatabaseEvent event = await ref.once();
      Map<dynamic, dynamic>? userData =
          event.snapshot.value as Map<dynamic, dynamic>?;
      return userData?.map((key, value) => MapEntry(key.toString(), value)) ??
          {};
    } catch (error) {
      throw Exception("Error fetching user data: $error");
    }
  }

  List<Message> getMessages(String receiverId) {
    FirebaseFirestore.instance
        .collection('chat')
        .doc(receiverId)
        .collection('message')
        .orderBy('sentTime', descending: false)
        .snapshots(includeMetadataChanges: true)
        .listen((messages) {
      this.messages =
          messages.docs.map((doc) => Message.fromJson(doc.data())).toList();
      notifyListeners();
      scrollDown();
    });
    return messages;
  }

  void scrollDown() => WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        }
      });
}
