import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home_outlined),
          activeIcon: const Icon(Icons.home),
          label: 'home'.tr,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.category_outlined),
          activeIcon: const Icon(Icons.category),
          label: 'categories'.tr,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.favorite_outline),
          activeIcon: const Icon(Icons.favorite),
          label: 'favorites'.tr,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.search),
          activeIcon: const Icon(Icons.search),
          label: 'search'.tr,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.settings_outlined),
          activeIcon: const Icon(Icons.settings),
          label: 'settings'.tr,
        ),
      ],
    );
  }
}
