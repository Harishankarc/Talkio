import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:talkio/screens/home.dart';
import 'package:talkio/screens/profile.dart';
import 'package:talkio/utils/constant.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const Home(),
    const Profile()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      backgroundColor: appbackground,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 0, 0, 0),
              Color.fromARGB(190, 18, 18, 18),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: GNav(
          selectedIndex: _selectedIndex,
          backgroundColor: Colors.transparent,
          tabBackgroundColor: Colors.grey.shade800,
          haptic: true,
          color: Colors.white54,
          activeColor: Colors.white,
          tabBorderRadius: 20,
          padding: const EdgeInsets.all(20),
          tabMargin: const EdgeInsets.all(10),
          gap: 10,
          onTabChange: (index) => setState(() => _selectedIndex = index),
          tabs: const [
            GButton(icon: Icons.home, text: 'Home',textSize: 30),
            GButton(icon: Icons.person, text: 'Profile',textSize: 30),
          ],
        ),
      ),
    );
  }
}