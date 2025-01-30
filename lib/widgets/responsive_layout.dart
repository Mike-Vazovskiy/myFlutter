import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileScreen;
  final Widget? tabletScreen;
  final Widget? desktopScreen;

  const ResponsiveLayout({
    Key? key,
    required this.mobileScreen,
    this.tabletScreen,
    this.desktopScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // простая логика: <600 - mobile, <1100 - tablet, иначе desktop
    if (width < 600) {
      return mobileScreen;
    } else if (width < 1100) {
      return tabletScreen ?? mobileScreen;
    } else {
      return desktopScreen ?? mobileScreen;
    }
  }
}
