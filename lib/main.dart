import 'package:app_links/app_links.dart';
import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clevertap_demo/presentation/home/home_screen.dart';
import 'package:flutter_clevertap_demo/providers/cart_provider.dart';
import 'package:flutter_clevertap_demo/providers/home_provider.dart';
import 'package:flutter_clevertap_demo/providers/product_experience_provider.dart';
import 'package:flutter_clevertap_demo/services/payload_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  CleverTapPlugin.syncCustomTemplates();
  await _initFirebaseMessaging();
  runApp(const MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // Use a global navigator key or context if needed for navigation
  PayloadManager.handlePayload(
    null, // No context in background
    message.data,
    NotificationPayloadState.received,
  );
}

Future<void> _initFirebaseMessaging() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission();

  // Foreground
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // Use navigatorKey.currentContext if you want to show UI
    PayloadManager.handlePayload(
      navigatorKey.currentContext,
      message.data,
      NotificationPayloadState.received,
    );
  });

  // App opened from background
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    PayloadManager.handlePayload(
      navigatorKey.currentContext,
      message.data,
      NotificationPayloadState.opened,
    );
  });

  // Background/killed
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String notificationMessage = "No notification yet.";
  final appLinks = AppLinks(); // AppLinks is singleton
  final _clevertapPlugin = CleverTapPlugin();

  @override
  void initState() {
    _clevertapPlugin.setCleverTapPushClickedPayloadReceivedHandler(
        pushClickedPayloadReceived);
    super.initState();
  }

  void pushClickedPayloadReceived(Map<String, dynamic> notificationPayload) {
    Fluttertoast.showToast(
        msg:
            "pushClickedPayloadReceived called with notification payload: $notificationPayload");
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => ProductExperienceProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'Clevertap Flutter Demo',
        navigatorKey: navigatorKey,
        home: HomeScreen(),
      ),
    );
  }
}
