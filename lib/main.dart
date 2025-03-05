import 'package:flutter/material.dart';
import 'package:pilem/screens/home_screen.dart';
import 'package:pilem/screens/favorite_screen.dart';
import 'package:pilem/screens/search_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens =[
    const HomeScreen(),
    const SearchScreen(),
    const FavoriteScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}