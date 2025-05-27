import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clevertap_demo/presentation/home/home_screen.dart';
import 'package:flutter_clevertap_demo/providers/providers.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  CleverTapPlugin.syncCustomTemplates();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String notificationMessage = "No notification yet.";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(title: 'Clevertap Flutter Demo', home: HomeScreen()),
    );
  }
}
