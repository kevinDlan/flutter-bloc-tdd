import 'package:flutter/material.dart';

class CustomPopMenuItem {
  const CustomPopMenuItem({
    required this.icon,
    this.title = '',
    this.onTap,
  });

  final String title;
  final Widget icon;
  final void Function()? onTap;
}
