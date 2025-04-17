import 'dart:convert';
import 'dart:developer';

import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clevertap_demo/models/native_display_entity.dart';
import 'package:flutter_clevertap_demo/services/native_bridge.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeProvider with ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController identityController = TextEditingController();
  TextEditingController stuffController = TextEditingController();

  String selectedAction = "onUserLogin";
  final List<String> actions = [
    "onUserLogin",
    "profilePush",
    "recordEvent",
    "profileSet",
    "getCleverTapId",
    "setLocation",
    "createPushNotification",
    "getNotificationPermission",
    "getAppBoxData",
    "inboxDidInitialize",
  ];

  List<String> stuff = [];

  void addStuff() {
    stuff.add(stuffController.text);
    notifyListeners();
  }

  void clearStuff() {
    stuffController.clear();
    stuff.clear();
    notifyListeners();
  }

  void updateSelectedAction(String data) {
    selectedAction = data;
    notifyListeners();
  }

  //Onuserlogin
  void onUserLogin() {
    var profile = {
      if (nameController.text.isNotEmpty) 'Name': nameController.text,
      if (identityController.text.isNotEmpty)
        'Identity': identityController.text,
      if (emailController.text.isNotEmpty) 'Email': emailController.text,
      if (phoneNumberController.text.isNotEmpty)
        'Phone': phoneNumberController.text,
      if (stuff.isNotEmpty) 'customer_type': stuff,
    };
    CleverTapPlugin.onUserLogin(profile);
  }

  //profilePush
  void profilePush() {
    var profile = {
      if (nameController.text.isNotEmpty) 'Name': nameController.text,
      if (identityController.text.isNotEmpty)
        'Identity': identityController.text,
      if (emailController.text.isNotEmpty) 'Email': emailController.text,
      if (phoneNumberController.text.isNotEmpty)
        'Phone': phoneNumberController.text,
      if (stuff.isNotEmpty) 'customer_type': stuff,
    };
    CleverTapPlugin.profileSet(profile);
  }

  //profileSet
  void profileSet() {
    var profile = {
      if (nameController.text.isNotEmpty) 'Name': nameController.text,
      if (identityController.text.isNotEmpty)
        'Identity': identityController.text,
      if (emailController.text.isNotEmpty) 'Email': emailController.text,
      if (phoneNumberController.text.isNotEmpty)
        'Phone': phoneNumberController.text,
      if (stuff.isNotEmpty) 'customer_type': stuff,
    };
    CleverTapPlugin.profileSet(profile);
  }

  //recordEvent
  void recordEvent() async {
    final epochTime =
        DateTime.now().millisecondsSinceEpoch ~/ 1000; // Convert to seconds
    await CleverTapPlugin.recordEvent("Product Viewed", {
      "product_name": "vada pav",
      "date/time": "\$D_$epochTime", // Using \$ to escape the $ symbol
    });
    // await Future.delayed(Duration(seconds: 2));
    // getAdUnits();
  }

  //setLocation
  void setLocation() {
    var lat = 19.07;
    var long = 72.87;
    CleverTapPlugin.setLocation(lat, long);
  }

  //getCleverTapId
  void getCleverTapId() {
    CleverTapPlugin.getCleverTapID()
        .then((clevertapId) {
          log("$clevertapId");
        })
        .catchError((error) {
          log("$error");
        });
  }

  //createPushNotification
  void createPushNotification() {
    CleverTapPlugin.createNotificationChannel(
      "fluttertest",
      "Flutter Test",
      "Flutter Test",
      3,
      true,
    );
  }

  void pushClickedPayloadReceived(Map<String, dynamic> notificationPayload) {
    print(
      "pushClickedPayloadReceived called with notification payload: $notificationPayload",
    );
    // You may perform UI operation like redirecting the user to a specific page based on custom key-value pairs
    // passed in the notificationPayload. You may also perform non UI operation such as HTTP requests, IO with local storage etc.
  }

  void getNotificationPermission() async {
    try {
      bool? isPushPermissionEnabled =
          await CleverTapPlugin.getPushNotificationPermissionStatus();
      log("Current permission status: $isPushPermissionEnabled");

      if (isPushPermissionEnabled == null || !isPushPermissionEnabled) {
        // Request permission
        var status = await Permission.notification.request();
        log("Permission request result: $status");

        if (status.isGranted) {
          await CleverTapPlugin.recordEvent("NotificationPermissionGranted", {
            "status": "granted",
          });
        } else {
          // Show settings dialog if denied
          await openAppSettings();
        }
      } else {
        log("Push Permission is already enabled");
        await CleverTapPlugin.recordEvent("GetNotification", {
          "product_name": "Vada pav",
        });
      }
    } catch (e) {
      log("Error requesting notification permission: $e");
    }
  }

  Future<void> requestNotificationPermission() async {
    var status = await Permission.notification.status;
    if (!status.isGranted) {
      await Permission.notification.request();
    }
  }

  void onDisplayUnitsLoaded(List<dynamic>? displayUnits) {
    log("Display Units = $displayUnits");
  }

  List<NativeDisplayEntity>? nativeDisplayEntity;

  void getAdUnits() async {
    final displayUnits = await CleverTapPlugin.getAllDisplayUnits();
    final data = jsonEncode(displayUnits);
    log("Display Units Payload = $data");
    showCoachMarks(data);
    notifyListeners();
  }

  //App Inbox
  void inboxDidInitialize() {
    log("inboxDidInitialize called");
    var styleConfig = {
      'noMessageTextColor': '#ff6600',
      'noMessageText': 'No message(s) to show.',
      'navBarTitle': 'App Inbox',
    };
    CleverTapPlugin.showInbox(styleConfig);
    notifyListeners();
  }

  void inboxMessagesDidUpdate() {
    log("inboxMessagesDidUpdate called");
  }

  void getAppBoxData() async {
    final messages = await CleverTapPlugin.getAllInboxMessages();
    log("Message : $messages");
  }


  Future<void> showCoachMarks(String data) async {
    String response = await NativeBridge.showCoachMarks(data);
    log("Coach Marks Response: $response");
  }
}
