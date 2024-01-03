import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class CustomToast {
  void showStatusToast(String message, String flagContent, String vehicleIdContent,
      String selectedMarkerId) {
    if (_shouldSkipToast(flagContent)) {
      return;
    }

    if (_shouldShowToast(vehicleIdContent, selectedMarkerId)) {
      String cleanedMessage = _cleanMessage(message);
      showFlutterToast(cleanedMessage);
    }
  }

  bool _shouldSkipToast(String flagContent) {
    return flagContent == "0000" || flagContent == "1001" || flagContent == "1010";
  }

  bool _shouldShowToast(String vehicleIdContent, String selectedMarkerId) {
    return vehicleIdContent == selectedMarkerId;
  }

  String _cleanMessage(String message) {
    return message.replaceFirst(RegExp(r'\[.*?\]'), '').trim();
  }

  void showFlutterToast(String cleanedMessage) {
    Fluttertoast.showToast(
      msg: cleanedMessage,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
