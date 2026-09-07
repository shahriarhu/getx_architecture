import 'package:flutter/material.dart';

import '../../core/extensions/context_extensions.dart';
import '../../theme/app_spacing.dart';
import '../app_text.dart';

/// Screen shell used by every page.
///
/// Centralises three things that are easy to forget per-screen: dismissing the
/// keyboard on an outside tap, safe-area handling, and consistent page padding.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.title,
    this.appBar,
    this.actions,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.padded = true,
    this.safeArea = true,
    this.dismissKeyboardOnTap = true,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
  });

  final Widget body;

  /// Convenience for a plain title bar; ignored when [appBar] is given.
  final String? title;
  final PreferredSizeWidget? appBar;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool padded;
  final bool safeArea;
  final bool dismissKeyboardOnTap;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    Widget content =
        padded
            ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
              child: body,
            )
            : body;

    if (safeArea) content = SafeArea(child: content);

    if (dismissKeyboardOnTap) {
      content = GestureDetector(
        onTap: context.unfocus,
        behavior: HitTestBehavior.opaque,
        child: content,
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar:
          appBar ??
          (title == null
              ? null
              : AppBar(title: AppText.titleLarge(title), actions: actions)),
      body: content,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
