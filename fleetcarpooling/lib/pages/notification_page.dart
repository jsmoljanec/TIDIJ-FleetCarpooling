import 'package:flutter/material.dart';
import 'package:fleetcarpooling/auth/authNotification.dart';
import 'package:fleetcarpooling/ui_elements/colors';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  AuthNotification authNotification = AuthNotification();
  String notificationMessage = '';

  void _showErrorMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

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
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: authNotification.reservationStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  notificationMessage = 'Error: ${snapshot.error}';
                  return Text(notificationMessage);
                } else {
                  List<Map<String, dynamic>> notifications =
                      snapshot.data ?? [];

                  notificationMessage =
                      'Notifications received: ${notifications.length}';

                  if (notifications.isEmpty) {
                    return const Center(
                      child: Text(
                        "No notifications",
                        style: TextStyle(fontSize: 20),
                      ),
                    );
                  } else {
                    return Expanded(
                      child: ListView(
                        children: notifications.map((notification) {
                          String message =
                              "You have a reservation for '${notification['pickupDate']}' from '${notification['pickupTime']}' until '${notification['returnDate']}' '${notification['returnTime']}'.";
                          return GestureDetector(
                            onTap: () {
                              _showReservationDetailsPopup(
                                  context, notification);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 28, right: 29, bottom: 12),
                              child: Card(
                                margin: const EdgeInsets.only(
                                    left: 28, right: 29, bottom: 12),
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
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }
                }
              },
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  void _showReservationDetailsPopup(
      BuildContext context, Map<String, dynamic> reservationDetails) async {
    try {
      dynamic vinCar = reservationDetails['VinCar'].toString();
      Map<String, dynamic>? carDetails =
          await authNotification.getCarDetails(vinCar);

      if (carDetails != null) {
        String pickupDate = reservationDetails['pickupDate'];
        String pickupTime = reservationDetails['pickupTime'];
        String returnDate = reservationDetails['returnDate'];
        String returnTime = reservationDetails['returnTime'];

        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Reservation Details'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Model: ${_getStringValue(carDetails['model'])}'),
                  Text('Brand: ${_getStringValue(carDetails['brand'])}'),
                  Text('Year: ${_getStringValue(carDetails['year'])}'),
                  const SizedBox(height: 16),
                  const Text('Reservation Details:'),
                  Text('Pickup Date: $pickupDate'),
                  Text('Pickup Time: $pickupTime'),
                  Text('Return Date: $returnDate'),
                  Text('Return Time: $returnTime'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      } else {
        // ignore: use_build_context_synchronously
        _showErrorMessage(
            context, 'Car details not found for VinCar: $vinCar');
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      _showErrorMessage(
          context, 'Error showing reservation details: $e');
    }
  }

  String _getStringValue(dynamic value) {
    if (value is int) {
      return value.toString();
    } else if (value is String) {
      return value;
    } else {
      return '';
    }
  }
}
