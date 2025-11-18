import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const BalancedMindApp());
}

class BalancedMindApp extends StatelessWidget {
  const BalancedMindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BalancedMind',
      theme: ThemeData(
        useMaterial3: true,

        primaryColor: const Color(0xFF673AB7),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepPurple,
          accentColor: const Color(0xFF81C784),
        ),
        scaffoldBackgroundColor: Colors.grey.shade50,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF673AB7),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF673AB7),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}