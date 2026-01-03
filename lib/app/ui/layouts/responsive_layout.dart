import 'package:flutter/material.dart';

class Breakpoints {
  static const double mobile = 500;
  static const double tablet = 1100;
}

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileLayout;
  final Widget? tabletLayout;
  final Widget? desktopLayout;

  const ResponsiveLayout({
    super.key,
    required this.mobileLayout,
    this.tabletLayout,
    this.desktopLayout,
  });

  static bool isMobile(BuildContext context) => MediaQuery.sizeOf(context).width < Breakpoints.mobile;

  static bool isTablet(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return w >= Breakpoints.mobile && w < Breakpoints.tablet;
  }

  static bool isDesktop(BuildContext context) => MediaQuery.sizeOf(context).width >= Breakpoints.tablet;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final width = constraints.maxWidth;

        if (width < Breakpoints.mobile) return mobileLayout;
        if (width < Breakpoints.tablet) return tabletLayout ?? mobileLayout;
        return desktopLayout ?? tabletLayout ?? mobileLayout;
      },
    );
  }
}
