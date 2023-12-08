import 'package:firebase_auth/firebase_auth.dart';
import 'package:fleetcarpooling/auth/generate_username_and_password.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fleetcarpooling/auth/send_email.dart';
import 'user_model.dart' as model;

class AuthRegistrationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  void writeDataToDatabase(String uid, String userName, String email,
      String firstName, String lastName, String role) {
    String profileImage = "";
    model.User _user = model.User(
        username: userName,
        email: email,
        firstName: firstName,
        lastName: lastName,
        role: role,
        profileImage: profileImage,
        statusActivity: "offline");

    DatabaseReference usersRef = _database.child("Users");
    DatabaseReference newUserRef = usersRef.child(uid);

    newUserRef.set(_user.toMap());
  }

  Future<void> registerUser(
      String email, String firstName, String lastName, String role) async {
    String password = generateRandomPassword();
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      String userId = userCredential.user!.uid;
      String username = await generateUsername(firstName, lastName);
      writeDataToDatabase(userId, username, email, firstName, lastName, role);
      sendEmail(email, _auth, username, password);
    } on FirebaseAuthException catch (e) {
      if (e.message == "The email address is badly formatted.")
        throw FirebaseAuthException(code: 'wrong-format');
      else
        throw FirebaseAuthException(code: 'email-already-in-use');
    } catch (e) {
      throw FirebaseAuthException(code: 'user-not-added');
    }
  }
}
