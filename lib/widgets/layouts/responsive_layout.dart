import 'package:flutter/material.dart';

import '../../theme/app_breakpoints.dart';

/// Picks a layout per breakpoint.
///
/// Uses `LayoutBuilder` rather than the raw screen size so it also behaves
/// correctly inside split views, dialogs and previews.
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder:
        (context, constraints) => switch (AppBreakpoints.of(
          constraints.maxWidth,
        )) {
          ScreenSize.mobile => mobile,
          ScreenSize.tablet => tablet ?? mobile,
          ScreenSize.desktop => desktop ?? tablet ?? mobile,
        },
  );
}

/// Caps content width and centres it on large screens, so forms and reading
/// content do not stretch across a desktop window.
class ConstrainedBody extends StatelessWidget {
  const ConstrainedBody({
    super.key,
    required this.child,
    this.maxWidth = AppBreakpoints.maxContentWidth,
    this.padding,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Padding(padding: padding ?? EdgeInsets.zero, child: child),
    ),
  );
}
