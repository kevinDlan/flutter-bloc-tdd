import 'package:education_app/core/common/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class NestedNavigationBackButton extends StatelessWidget {
  const NestedNavigationBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (_, __) async {
        try {
          context.pop();
        } catch (_) {
          Navigator.of(context).pop();
        }
      },
      child: IconButton(
        onPressed: () {
          try {
            context.pop();
          } catch (_) {
            Navigator.of(context).pop();
          }
        },
        icon: Theme.of(context).platform == TargetPlatform.iOS
            ? const Icon(Icons.arrow_back_ios)
            : const Icon(Icons.arrow_back),
      ),
    );
  }
}
