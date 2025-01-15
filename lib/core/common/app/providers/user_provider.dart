import 'package:education_app/features/auth/domain/entities/user.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  LocalUser? _user;

  LocalUser? get user => _user;

  void initUser(LocalUser? user) {
    if (user != null) _user = user;
  }

  set user(LocalUser? user) {
    if (user != null) {
      _user = user;
      Future.delayed(Duration.zero, notifyListeners);
    }
  }
}
