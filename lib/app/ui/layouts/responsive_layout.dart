import 'package:flutter/material.dart';

enum LayoutType {
  mobileLayout,
  tabletLayout,
  webLayout,
}

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileLayout;
  final Widget? tabletLayout;
  final Widget? webLayout;

  const ResponsiveLayout({
    super.key,
    required this.mobileLayout,
    this.tabletLayout,
    this.webLayout,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return mobileLayout;
        } else if (constraints.maxWidth < 1200) {
          return tabletLayout ?? mobileLayout;
        } else {
          return webLayout ?? tabletLayout ?? mobileLayout;
        }
      },
    );
  }
}
