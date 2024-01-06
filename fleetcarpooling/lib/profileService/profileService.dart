import 'package:firebase_database/firebase_database.dart';
import 'package:fleetcarpooling/auth/user_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'dart:io';

class ProfileService {
  static final firestore = FirebaseFirestore.instance;

  Future<String> addStorage({required XFile file}) async {
    String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot
        .child('profile_images/${FirebaseAuth.instance.currentUser?.uid}}');
    Reference referenceImageToUpload = referenceDirImages.child(uniqueName);
    referenceImageToUpload.putFile(File(file!.path));

    try {
      await referenceImageToUpload.putFile(File(file!.path));
      String downloadURL = await referenceImageToUpload.getDownloadURL();
      await UserRepository().updateUserProfileImage(downloadURL);
      return await referenceImageToUpload.getDownloadURL();
    } catch (error) {
      return "error";
    }
  }
}
