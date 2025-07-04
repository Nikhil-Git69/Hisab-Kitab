import 'package:expensetracker/dashboard.dart';
import 'package:expensetracker/transactionPage.dart';
import 'package:flutter/material.dart';

class navPages extends StatefulWidget {
  const navPages({super.key});

  @override
  State<navPages> createState() => _navPagesState();
}

class _navPagesState extends State<navPages> {
  int _currentIndex = 0;

  final List<Widget> pages = [dashscr(), TransacPage()];

  void _onNavPageTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF215977),
        currentIndex: _currentIndex,
        onTap: _onNavPageTapped,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey.shade600,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: "Dashboard",),
          BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: "Transactions",),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
