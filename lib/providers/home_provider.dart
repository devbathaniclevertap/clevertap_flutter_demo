import 'dart:developer';

import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:flutter/material.dart';
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
  void recordEvent() {
    CleverTapPlugin.recordEvent("Product Viewed", {"product_name": "Vada pav"});
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
    print(notificationPayload);
  }

  void getNotificationPermission() async {
    bool? isPushPermissionEnabled =
        await CleverTapPlugin.getPushNotificationPermissionStatus();
    print(isPushPermissionEnabled);
    if (isPushPermissionEnabled == null) return;

    if (!isPushPermissionEnabled) {
      requestNotificationPermission();
    } else {
      print("Push Permission is already enabled.");
    }
  }

  Future<void> requestNotificationPermission() async {
    var status = await Permission.notification.status;
    if (!status.isGranted) {
      await Permission.notification.request();
    }
  }
}
