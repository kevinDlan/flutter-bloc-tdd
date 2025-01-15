import 'package:education_app/core/common/app/providers/tab_navigator_provider.dart';
import 'package:education_app/core/common/screens/persistent_screen.dart';
import 'package:education_app/features/profil/prensentation/screens/profil_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardController extends ChangeNotifier {
  List<int> _indexHistory = [];

  final List<Widget> _screens = [
    ChangeNotifierProvider(
      create: (_) => TabNavigatorProvider(
        TabItem(
          child: const Center(
            child: Text('Home screen'),
          ),
          // HomeScreen(),
        ),
      ),
      child: const PersistentScreen(),
    ),
    ChangeNotifierProvider(
      create: (_) => TabNavigatorProvider(
        TabItem(
          child: const Center(
            child: Text('Materials screen'),
          ),
          // HomeScreen(),
        ),
      ),
      child: const PersistentScreen(),
    ),
    ChangeNotifierProvider(
      create: (_) => TabNavigatorProvider(
        TabItem(
          child: const Center(
            child: Text('Chat screen'),
          ),
          // HomeScreen(),
        ),
      ),
      child: const PersistentScreen(),
    ),
    ChangeNotifierProvider(
      create: (_) => TabNavigatorProvider(
        TabItem(
          child: const ProfilScreen(),
        ),
      ),
      child: const PersistentScreen(),
    ),
  ];

  List<Widget> get screens => _screens;

  int _currentIndex = 3;

  int get currentIndex => _currentIndex;

  void changeIndex(int index) {
    if (_currentIndex == index) return;

    _currentIndex = index;
    _indexHistory.add(index);
    notifyListeners();
  }

  void goBack() {
    if (_indexHistory.length == 1) return;
    _indexHistory.removeLast();
    _currentIndex = _indexHistory.last;
    notifyListeners();
  }

  void resetIndex() {
    _indexHistory = [0];
    _currentIndex = 0;
  }
}
