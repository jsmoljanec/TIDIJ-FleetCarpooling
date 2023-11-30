import 'package:fleetcarpooling/auth/authNotification.dart';
import 'package:fleetcarpooling/ui_elements/colors';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  AuthNotification authNotification = AuthNotification();
  String notificationMessage = '';

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double padding2 = screenHeight * 0.02;

    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 27.5),
            width: screenWidth,
            decoration: const BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: AppColors.buttonColor))),
            child: Padding(
              padding: EdgeInsets.only(top: padding2, bottom: padding2),
              child: const Text(
                "NOTIFICATIONS",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.mainTextColor, fontSize: 24),
              ),
            ),
          ),
          FutureBuilder<List<Map<dynamic, dynamic>>>(
            future: () async {
              var user = await authNotification.getCurrentUser();
              if (user != null) {
                return authNotification
                    .getReservationsNotifications(user.email!);
              } else {
                throw Exception("User not found");
              }
            }(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                notificationMessage = 'Error: ${snapshot.error}';
                return Text(notificationMessage);
              } else {
                List<Map<dynamic, dynamic>> notifications = snapshot.data ?? [];

                notificationMessage =
                    'Notifications received: ${notifications.length}';

                if (notifications.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.only(left: 28, right: 29, bottom: 12),
                    child: Card(
                      margin: EdgeInsets.only(left: 28, right: 29, bottom: 12),
                      color: AppColors.backgroundColor,
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          "No notifications",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Column(
                    children: notifications.map((notification) {
                      String message =
                          "You have a reservation for '${notification['pickupDate']}' from '${notification['pickupTime']}' until '${notification['returnDate']}' '${notification['returnTime']}'.";
                      return Padding(
                        padding: const EdgeInsets.only(left: 28, right: 29, bottom: 12),
                        child: Card(
                          margin: const EdgeInsets.only(left: 28, right: 29, bottom: 12),
                          color: AppColors.backgroundColor,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              message,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}