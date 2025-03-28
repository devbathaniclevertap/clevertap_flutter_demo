import 'dart:developer';

import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clevertap_demo/presentation/home/home_screen.dart';
import 'package:flutter_clevertap_demo/providers/providers.dart';
import 'package:provider/provider.dart';

@pragma('vm:entry-point')
void _onKilledStateNotificationClickedHandler(Map<String, dynamic> map) async {
  log("Notification Payload received: $map");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  CleverTapPlugin.onKilledStateNotificationClicked(
    _onKilledStateNotificationClickedHandler,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(title: 'Clevertap Flutter Demo', home: HomeScreen()),
    );
  }
}
