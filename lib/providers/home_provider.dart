import 'dart:convert';
import 'dart:developer';

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
    // final epochTime =
    //     DateTime.now().millisecondsSinceEpoch ~/ 1000; // Convert to seconds
    await CleverTapPlugin.recordEvent(stuffController.text, {});
    if (stuffController.text == "App Inbox Message") {
      var styleConfig = {
        'noMessageTextColor': '#ff6600',
        'noMessageText': 'No message(s) to show.',
        'navBarTitle': 'App Inbox'
      };
      await Future.delayed(Duration(seconds: 3));
      CleverTapPlugin.showInbox(styleConfig);
    }
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

  //****** SIGNED CALL FUNTIONS *******/
  // void signedCallInitHandler(SignedCallError? signedCallInitError) async {
  //   if (signedCallInitError == null) {
  //     debugPrint("Signed Call SDK Initialized!");
  //   } else {
  //     final errorCode = signedCallInitError.errorCode;
  //     final errorMessage = signedCallInitError.errorMessage;
  //     final errorDescription = signedCallInitError.errorDescription;
  //     debugPrint("SignedCall initialization failed: \n"
  //         "error-code - $errorCode \n"
  //         "error-message - $errorMessage \n"
  //         "error-description - $errorDescription");
  //   }
  // }

  // ///Common fields of Android & iOS
  // final Map<String, dynamic> initProperties = {
  //   "accountId": "TEST-4W5-9RR-646Z",
  //   "apiKey": "a840bcd88d53486b88ea8cebe45e0a13",
  //   "cuid": "123",
  // };
  // //Creates push primer config using Half-Interstitial template
  // var pushPrimerConfig = {
  //   'inAppType': 'half-interstitial',
  //   'titleText': 'Get Notified',
  //   'messageText':
  //       'Please enable notifications on your device to use Push Notifications.',
  //   'followDeviceOrientation': false,
  //   'positiveBtnText': 'Allow',
  //   'negativeBtnText': 'Cancel',
  //   'fallbackToSettings': true,
  //   'backgroundColor': '#FFFFFF',
  //   'btnBorderColor': '#000000',
  //   'titleTextColor': '#000000',
  //   'messageTextColor': '#000000',
  //   'btnTextColor': '#000000',
  //   'btnBackgroundColor': '#FFFFFF',
  //   'btnBorderRadius': '4',
  //   'imageUrl':
  //       'https://icons.iconarchive.com/icons/treetog/junior/64/camera-icon.png'
  // };
  // final Map<String, dynamic> fcmProcessingNotification = {
  //   "title": "<TEsting>", //required
  //   "subtitle": "<Testing subtitle>", //required
  // };
  // void initSignedCall() async {
  //   ///Android only fields
  //   if (Platform.isAndroid) {
  //     initProperties["allowPersistSocketConnection"] = true;
  //     initProperties["promptReceiverReadPhoneStatePermission"] = true;
  //     initProperties["notificationPermissionRequired"] = true;
  //     initProperties["promptPushPrimer"] = pushPrimerConfig;
  //     initProperties["fcmProcessingMode"] = FCMProcessingMode.foreground;
  //     initProperties["fcmProcessingNotification"] = fcmProcessingNotification;

  //     initProperties["swipeOffBehaviourInForegroundService"] =
  //         SCSwipeOffBehaviour.endCall;
  //   }
  //   //To initialize the Signed Call Flutter SDK
  //   CleverTapSignedCallFlutter.shared.init(
  //     initProperties: initProperties,
  //     initHandler: signedCallInitHandler,
  //   );
  // }

  // void logoutSignedCall() {
  //   CleverTapSignedCallFlutter.shared.logout();
  // }

  // void signedCallVoIPCallHandler(SignedCallError? signedCallVoIPError) {
  //   if (signedCallVoIPError == null) {
  //     debugPrint("VoIP call is placed successfully!");
  //   } else {
  //     final errorCode = signedCallVoIPError.errorCode;
  //     final errorMessage = signedCallVoIPError.errorMessage;
  //     final errorDescription = signedCallVoIPError.errorDescription;
  //     debugPrint("VoIP call is failed: \n"
  //         "error-code - $errorCode \n"
  //         "error-message - $errorMessage \n"
  //         "error-description - $errorDescription");
  //   }
  // }

  // void makeSignedCall() async {
  //   const callOptions = {
  //     "remoteContext": "Calling for testing",
  //     "initiatorImage": "https://picsum.photos/id/1/200/300",
  //     "receiverImage":
  //         "https://media.istockphoto.com/id/1443628665/photo/adult-writing-in-the-classroom.jpg?s=1024x1024&w=is&k=20&c=WZ9Zv8MPhqo4F4nRhkqGaK9uohN6Z7PE2aXfZyxDdoc="
  //   };
  //   CleverTapSignedCallFlutter.shared.call(
  //     receiverCuid: "123",
  //     callContext: "Calling for testing",
  //     callOptions: callOptions,
  //     voIPCallHandler: signedCallVoIPCallHandler,
  //   );
  // }

  // void disconnectSignallingSocket() {
  //   CleverTapSignedCallFlutter.shared.disconnectSignallingSocket();
  // }
}
