import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:app_links/app_links.dart';
import 'package:clevertap_plugin/clevertap_plugin.dart';
// import 'package:clevertap_signedcall_flutter/models/fcm_processing_mode.dart';
// import 'package:clevertap_signedcall_flutter/models/signed_call_error.dart';
// import 'package:clevertap_signedcall_flutter/models/swipe_off_behaviour.dart';
// import 'package:clevertap_signedcall_flutter/plugin/clevertap_signedcall_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clevertap_demo/models/native_display_entity.dart';
import 'package:flutter_clevertap_demo/models/test_native_display_entity.dart';
import 'package:flutter_clevertap_demo/presentation/home/native_display_screen.dart';
import 'package:flutter_clevertap_demo/services/native_bridge.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeProvider with ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController identityController = TextEditingController();
  TextEditingController stuffController = TextEditingController();
  final AppLinks _appLinks = AppLinks();

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
    "makeACall"
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
    Map<String, dynamic> eventData = {};
    if (stuffController.text == "Product Viewed") {
      final random = math.Random();
      final randomNumber =
          100 + random.nextInt(900); // 3-digit number (100-999)
      eventData = {"product_name": "Random_$randomNumber"};
    }
    await CleverTapPlugin.recordEvent(stuffController.text, eventData);
    if (stuffController.text == "App Inbox Message") {
      var styleConfig = {
        'noMessageTextColor': '#ff6600',
        'noMessageText': 'No message(s) to show.',
        'navBarTitle': 'App Inbox'
      };
      await Future.delayed(Duration(seconds: 3));
      CleverTapPlugin.showInbox(styleConfig);
    }
  }

  //setLocation
  void setLocation() {
    var lat = 19.07;
    var long = 72.87;
    CleverTapPlugin.setLocation(lat, long);
  }

  //getCleverTapId
  void getCleverTapId() {
    CleverTapPlugin.getCleverTapID().then((clevertapId) {
      log("$clevertapId");
    }).catchError((error) {
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
    log(
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

  List<TestNativeDisplayEntity>? entities;
  void onDisplayUnitsLoaded(List<dynamic>? displayUnits, BuildContext context) {
    if (displayUnits != null && displayUnits.isNotEmpty) {
      try {
        final jsonStr = json.encode(displayUnits);
        log("Raw Display Units = $jsonStr");
        entities = testNativeDisplayEntityFromJson(jsonStr);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NativeDisplayScreen(data: entities!),
          ),
        );
      } catch (e) {
        log("Error parsing display units: $e");
      }
    }
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

  // final _cleverTapPlugin = CleverTapPlugin();
  void inboxMessagesDidUpdate() {
    print("inboxMessagesDidUpdate called");
  }

  void getProductExperienceData() async {
    const variables = {"Testing": "default"};
    CleverTapPlugin.defineVariables(variables);
    CleverTapPlugin.syncVariables();
    CleverTapPlugin.getVariables()
        .then((variables) => {print("getVariables: $variables")});

    CleverTapPlugin.getVariable('Testing').then((variable) =>
        {print('variable value for key \'flutter_var_string\': $variable')});
  }

  void getAppBoxData() async {
    final messages = await CleverTapPlugin.getAllInboxMessages();
    log("Message : $messages");
  }

  Future<void> showCoachMarks(String data) async {
    String response = await NativeBridge.showCoachMarks(data);
    log("Coach Marks Response: $response");
  }

  // Initialize deep linking
  Future<void> initDeepLinks(BuildContext context) async {
    try {
      // Handle initial link if app was opened from dead state
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null && context.mounted) {
        handleDeepLink(initialUri, context);
      }
      // Handle links when app is in background/foreground
      _appLinks.uriLinkStream.listen((uri) {
        if (context.mounted) {
          handleDeepLink(uri, context);
        }
      });
    } catch (e) {
      debugPrint('Deep link error: $e');
    }
  }

  void handleDeepLink(Uri uri, BuildContext context) {
    log("The URL is $uri");
  }

}
