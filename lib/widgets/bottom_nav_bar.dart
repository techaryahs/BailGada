import 'package:flutter/material.dart';
import '../utils/translation_helper.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFFFF9800),
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.white,
      items: [
        BottomNavigationBarItem(icon: const Icon(Icons.home), label: 'home'.tr),
        BottomNavigationBarItem(icon: const Icon(Icons.event), label: 'events'.tr),
        BottomNavigationBarItem(icon: const Icon(Icons.payment), label: 'payments'.tr),
        // BottomNavigationBarItem(icon: Icon(Icons.approval), label: 'Approvals'),
        // BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
    );
  }
}
