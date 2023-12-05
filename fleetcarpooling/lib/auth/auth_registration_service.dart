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
    model.User _user = model.User(
        username: userName,
        email: email,
        firstName: firstName,
        lastName: lastName,
        role: role);

    DatabaseReference usersRef = _database.child("Users");
    DatabaseReference newUserRef = usersRef.child(uid);

    newUserRef.set(_user.toMap());
  }

  Future<void> registerUser(
      String email, String firstName, String lastName, String role) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email, password: generateRandomPassword());

      String userId = userCredential.user!.uid;
      String username = await generateUsername(firstName, lastName);
      writeDataToDatabase(userId, username, email, firstName, lastName, role);
      sendEmail(email, _auth);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }
}
