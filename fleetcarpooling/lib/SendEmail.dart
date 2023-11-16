import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

Future<void> sendEmail(String email) async {
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
  } on MailerException catch (e) {
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
}
