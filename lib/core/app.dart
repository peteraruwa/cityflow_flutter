import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'colors.dart';
import 'constants.dart';
import 'theme.dart';

class CityFlowApp extends StatelessWidget {
  const CityFlowApp({
    required this.routerConfig,
    super.key,
  });

  final GoRouter routerConfig;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: kAppName,
      debugShowCheckedModeBanner: false,
      theme: buildCityFlowTheme(),
      routerConfig: routerConfig,
    );
  }
}

class CityFlowShell extends StatelessWidget {
  const CityFlowShell({
    required this.location,
    required this.child,
    super.key,
  });

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: child,
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: kBackground.withValues(alpha: 0.94),
          border: const Border(top: BorderSide(color: kBorder)),
        ),
        child: SafeArea(
          top: false,
          child: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
              currentIndex: _tabIndexForLocation(location),
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              selectedItemColor: kGold,
              unselectedItemColor: kMutedText,
              elevation: 0,
              selectedFontSize: 10,
              unselectedFontSize: 10,
              onTap: (index) => context.goNamed(_tabNameForIndex(index)),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.directions_car_outlined),
                  activeIcon: Icon(Icons.directions_car),
                  label: 'CityRide',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.explore_outlined),
                  activeIcon: Icon(Icons.explore),
                  label: 'Explore',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.inventory_2_outlined),
                  activeIcon: Icon(Icons.inventory_2),
                  label: 'Lost & Fnd',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bolt_outlined),
                  activeIcon: Icon(Icons.bolt),
                  label: 'More',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int _tabIndexForLocation(String location) {
    if (location == '/city-ride') return 1;
    if (location == '/explore') return 2;
    if (location == '/lost-and-found') return 3;
    if (location == '/profile') return 4;
    return 0;
  }

  String _tabNameForIndex(int index) {
    return switch (index) {
      1 => 'cityRide',
      2 => 'explore',
      3 => 'lostAndFound',
      4 => 'profile',
      _ => 'home',
    };
  }
}
