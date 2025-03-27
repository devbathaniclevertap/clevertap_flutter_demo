import 'package:flutter/material.dart';
import 'package:flutter_clevertap_demo/presentation/home/home_screen.dart';
import 'package:flutter_clevertap_demo/providers/providers.dart';
import 'package:provider/provider.dart';

void main() {
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
