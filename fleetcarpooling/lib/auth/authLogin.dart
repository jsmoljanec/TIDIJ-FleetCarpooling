import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthLogin {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> findEmail(String username) async {
    final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
    var query = await databaseReference
        .child("Users")
        .orderByChild('username')
        .equalTo(username)
        .limitToFirst(1)
        .once();

    if (query.snapshot.value != null) {
      Map<dynamic, dynamic>? userMap =
          query.snapshot.value as Map<dynamic, dynamic>?;

      if (userMap != null && userMap.isNotEmpty) {
        String userID = userMap.keys.first;
        String userEmail = userMap[userID]['email'];
        return userEmail;
      }
    }

    return "";
  }

  Future<void> login({required String email, required String password}) async {
    if (email.contains('@')) {
      email = email;
    } else {
      email = await findEmail(email);
    }

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("Login successful: ${userCredential.user?.email}");
    } catch (e) {
      print("Login failed: $e");
    }
  }
}
