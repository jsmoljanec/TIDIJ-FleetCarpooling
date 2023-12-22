import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fleetcarpooling/chat/models/message.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseFirestoreService {
  static final firestore = FirebaseFirestore.instance;

  static Future<void> addTextMessage({
    required String content,
    required String receiverId,
  }) async {
    final message = Message(
      content: content,
      sentTime: DateTime.now(),
      receiverId: receiverId,
      messageType: MessageType.text,
      senderId: FirebaseAuth.instance.currentUser!.uid,
    );
    await _addMessageToChat(receiverId, message);
  }

  static Future<void> _addMessageToChat(
    String receiverId,
    Message message,
  ) async {
    await firestore
        .collection('chat')
        .doc(receiverId)
        .collection('message')
        .add(message.toJson());
  }

  static Future<void> addImageMessage({
    required String receiverId,
    required XFile file,
  }) async {
    final image = await addStorage(
      file,
    );

    final message = Message(
      content: image,
      sentTime: DateTime.now(),
      receiverId: receiverId,
      messageType: MessageType.image,
      senderId: FirebaseAuth.instance.currentUser!.uid,
    );
    await _addMessageToChat(receiverId, message);
  }

  static Future<String> addStorage(XFile file) async {
    String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages =
        referenceRoot.child('image/chat/${DateTime.now()}');
    Reference referenceImageToUpload = referenceDirImages.child(uniqueName);
    referenceImageToUpload.putFile(File(file!.path));
    try {
      await referenceImageToUpload.putFile(File(file!.path));
      return await referenceImageToUpload.getDownloadURL();
    } catch (error) {
      return "error";
    }
  }
}
