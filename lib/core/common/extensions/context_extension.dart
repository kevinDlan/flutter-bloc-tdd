import 'package:education_app/core/common/app/providers/tab_navigator_provider.dart';
import 'package:education_app/core/common/app/providers/user_provider.dart';
import 'package:education_app/features/auth/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension ContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  Size get size => mediaQuery.size;

  double get height => size.height;

  double get widht => size.width;

  UserProvider get userProvider => read<UserProvider>();

  LocalUser? get currentUser => userProvider.user;

  TabNavigatorProvider get tabNavigatorProvider => read<TabNavigatorProvider>();

  void pop() => tabNavigatorProvider.pop();

  void push(Widget page) => tabNavigatorProvider.push(TabItem(child: page));
}
