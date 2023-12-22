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
        String uid = user.uid;
        print('VIN broj u AuthNotifyMe prije spremanja: $vinCar');

        Map<String, dynamic> notifyMeData = {
          'vinCar': vinCar,
          'email': user.email,
          'pickupDate': pickupDate,
          'pickupTime': pickupTime,
          'returnDate': returnDate,
          'returnTime': returnTime,
        };

        DatabaseReference notifyMeRef = _database.child("NotifyMe").child(uid);
        await notifyMeRef.set(notifyMeData);
        print('VIN broj u AuthNotifyMe nakon spremanja: $vinCar');
      } else {
        throw Exception("User not authenticated");
      }
    } catch (e) {
      print("Error saving NotifyMe data: $e");
    }
  }
}
