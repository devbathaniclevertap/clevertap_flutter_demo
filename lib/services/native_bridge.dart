import 'package:flutter/services.dart';

class NativeBridge {
  static const MethodChannel _channel = MethodChannel('com.example.yourapp/method_channel');

  static Future<String> showCoachMarks(String jsonString) async {
    try {
      final String result = await _channel.invokeMethod('showCoachMarks', jsonString);
      return result;
    } catch (e) {
      return "Error calling native function: \$e";
    }
  }
}
