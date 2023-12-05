import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> sendEmail(String email, FirebaseAuth auth) async {
  String username = dotenv.env['EMAIL_USERNAME']!;
  String password = dotenv.env['EMAIL_PASSWORD']!;

  final smtpServer = gmail(username, password);

  final message = Message()
    ..from = Address(username, 'FleetCarpooling')
    ..recipients.add(email)
    ..subject = 'Welcome to FleetCarpooling'
    ..html =
        "<h3>Welcome to FleetCarpooling</h3>\n<p>You have been successfully added to the application.</p>\n<p>In a few moments, you will receive a link where you can set your password.</p>\n\n<p>Best regards!</p>";

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
    Future.delayed(Duration(minutes: 1), () {
      sendLinkForNewPassword(email, auth);
    });
  } on MailerException catch (e) {
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
}

Future<void> sendLinkForNewPassword(String email, FirebaseAuth auth) async {
  try {
    await auth.sendPasswordResetEmail(email: email);
    print('Password reset email sent to $email');
  } catch (e) {
    print('Error sending password reset email: $e');
    // Handle errors as needed
  }
}
