import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'tips_screen.dart';
import 'tracker_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    ChatScreen(),
    TipsScreen(),
    BalanceTrackerScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Mentoria IA',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline),
            label: 'Dicas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Monitor',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        elevation: 10,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}