import 'package:firebase_auth/firebase_auth.dart';
import 'package:fleetcarpooling/GenerateUsernameAndPassword.dart';

class AuthRegistrationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> registerUser(
      String email, String firstName, String lastName, String role) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email, password: generateRandomPassword());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }
}
