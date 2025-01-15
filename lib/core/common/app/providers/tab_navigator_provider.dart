import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class TabNavigatorProvider extends ChangeNotifier {
  TabNavigatorProvider(this._initialPage) {
    _navigationStack.add(_initialPage);
  }

  final TabItem _initialPage;

  final List<TabItem> _navigationStack = [];

  TabItem get currentPage => _navigationStack.last;

  void push(TabItem tabItem) {
    _navigationStack.add(tabItem);

    notifyListeners();
  }

  void pop() {
    if (_navigationStack.length > 1) _navigationStack.removeLast();
    notifyListeners();
  }

  void popToRoot() {
    _navigationStack
      ..clear()
      ..add(_initialPage);

    notifyListeners();
  }

  void popTo(TabItem page) {
    _navigationStack.remove(page);

    notifyListeners();
  }

  void popUntil(TabItem? page) {
    if (page == null) return popToRoot();
    if (_navigationStack.length > 1) {
      _navigationStack.removeRange(1, _navigationStack.indexOf(page) + 1);

      notifyListeners();
    }
  }

  void pushAndRemoveUntil(TabItem page) {
    _navigationStack
      ..clear()
      ..add(page);

    notifyListeners();
  }
}

class TabNavProvider extends InheritedNotifier<TabNavigatorProvider> {
  const TabNavProvider({
    required this.navigatorProvider,
    required super.child,
    required super.key,
  }) : super(notifier: navigatorProvider);

  final TabNavigatorProvider navigatorProvider;

  static TabNavigatorProvider? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TabNavProvider>()
        ?.navigatorProvider;
  }
}

class TabItem extends Equatable {
  TabItem({required this.child}) : id = const Uuid().v1();

  final Widget child;
  final String id;

  @override
  List<dynamic> get props => [id];
}
