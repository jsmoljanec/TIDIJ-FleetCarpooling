import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fleetcarpooling/auth/user_model.dart' as usermod;

class UserRepository {
  Future<usermod.User> fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = user.uid;

        DatabaseReference ref = FirebaseDatabase.instance.ref("Users/$uid");

        DatabaseEvent event = await ref.once();

        Map<dynamic, dynamic>? userData =
            event.snapshot.value as Map<dynamic, dynamic>?;

        return usermod.User(
          firstName: userData?['firstName'] ?? '',
          lastName: userData?['lastName'] ?? '',
          email: userData?['email'] ?? '',
          username: userData?['username'] ?? '',
          role: userData?['role'] ?? '',
          profileImage: userData?['profileImage'] ?? '',
        );
      } else {
        throw Exception('User is null');
      }
    } catch (e) {
      print("Error: $e");
      throw e;
    }
  }

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );

        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPassword);

        print("Password changed successfully");
      } else {
        throw Exception('User is null');
      }
    } catch (e) {
      print("Error changing password: $e");
      throw e;
    }
  }
}
