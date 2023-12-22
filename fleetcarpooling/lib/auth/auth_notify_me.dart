import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthNotifyMe {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<void> saveNotifyMeData(
    String vinCar,
    String pickupDate,
    String pickupTime,
    String returnDate,
    String returnTime,
  ) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();

        Map<String, dynamic> notifyMeData = {
          'vinCar': vinCar,
          'email': user.email,
          'pickupDate': pickupDate,
          'pickupTime': pickupTime,
          'returnDate': returnDate,
          'returnTime': returnTime,
        };

        DatabaseReference notifyMeRef =
            _database.child("NotifyMe").child(uniqueName);
        await notifyMeRef.set(notifyMeData);
      } else {
        throw Exception("User not authenticated");
      }
    } catch (e) {
      throw Exception("Error saving NotifyMe data");
    }
  }
}