import 'package:fleetcarpooling/ui_elements/colors';
import 'package:flutter/material.dart';
import 'package:fleetcarpooling/auth/authNotification.dart';

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
              border: Border(bottom: BorderSide(color: AppColors.buttonColor)),
            ),
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
                        style: TextStyle(
                            fontSize: 20, color: AppColors.mainTextColor),
                      ),
                    );
                  } else {
                    return Expanded(
                      child: ListView(
                        children: notifications.map((notification) {
                          String message =
                              "You have a reservation for ${notification['pickupDate']} from ${notification['pickupTime']} until ${notification['returnDate']} ${notification['returnTime']}.";
                          return GestureDetector(
                            onTap: () {
                              _showReservationDetailsPopup(
                                  context, notification);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 13, right: 14, bottom: 12),
                              child: Card(
                                margin: const EdgeInsets.only(
                                    left: 13, right: 14, bottom: 12),
                                color: AppColors.backgroundColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    message,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: AppColors.mainTextColor,
                                    ),
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
            double notificationWidth = MediaQuery.of(context).size.width * 1.5;

            return AlertDialog(
              backgroundColor: AppColors.backgroundColor,
              title: const Text(
                'Reservation details',
                style: TextStyle(color: AppColors.mainTextColor, fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              content: SizedBox(
                width: notificationWidth,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(
                          'Model:', _getStringValue(carDetails['model'])),
                      _buildDetailRow(
                          'Brand:', _getStringValue(carDetails['brand'])),
                      _buildDetailRow(
                          'Year:', _getStringValue(carDetails['year'])),
                      const SizedBox(height: 16),
                      _buildDetailRow('Pickup Date:', pickupDate),
                      _buildDetailRow('Pickup Time:', pickupTime),
                      _buildDetailRow('Return Date:', returnDate),
                      _buildDetailRow('Return Time:', returnTime),
                    ],
                  ),
                ),
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Close',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.mainTextColor),
                      ),
                    ),
                  ),
                ),
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            );
          },
        );
      } else {
        // ignore: use_build_context_synchronously
        _showErrorMessage(context, 'Car details not found for VinCar: $vinCar');
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      _showErrorMessage(context, 'Error showing reservation details: $e');
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: AppColors.mainTextColor, fontSize: 20),
          children: [
            TextSpan(
              text: '$label ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
