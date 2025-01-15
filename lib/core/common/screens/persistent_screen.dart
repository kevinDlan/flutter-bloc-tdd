import 'package:education_app/core/common/app/providers/tab_navigator_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PersistentScreen extends StatefulWidget {
  const PersistentScreen({this.body, super.key});

  final Widget? body;

  @override
  State<PersistentScreen> createState() => _PersistentScreenState();
}

class _PersistentScreenState extends State<PersistentScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.body ??
        context.watch<TabNavigatorProvider>().currentPage.child;
  }

  @override
  bool get wantKeepAlive => true;
}
