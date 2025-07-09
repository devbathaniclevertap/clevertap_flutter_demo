import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum NotificationPayloadState {
  received,
  opened,
  dismissed,
}

class PayloadManager {
  static void handlePayload(BuildContext? context, Map<String, dynamic> payload,
      NotificationPayloadState state) {
    String stateText = _stateToString(state);
    String message = 'Notification $stateText: ${payload.toString()}';
    _showToast(message);
    // Add any additional logic for each state here
  }

  static String _stateToString(NotificationPayloadState state) {
    switch (state) {
      case NotificationPayloadState.received:
        return 'Received';
      case NotificationPayloadState.opened:
        return 'Opened';
      case NotificationPayloadState.dismissed:
        return 'Dismissed';
    }
  }

  static void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast
          .LENGTH_LONG, // 5 seconds is not directly supported, but LONG is ~5s on Android
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
