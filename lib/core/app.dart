import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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

  Future<void> _loadEnv() {
    if (dotenv.env.isNotEmpty) {
      return Future<void>.value();
    }

    return dotenv.load(fileName: 'assets/.env');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _loadEnv(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox.shrink();
        }

        return MaterialApp.router(
          title: kAppName,
          debugShowCheckedModeBanner: false,
          theme: buildCityFlowTheme(),
          routerConfig: routerConfig,
        );
      },
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
      bottomNavigationBar: _CityFlowBottomNav(
        currentIndex: _tabIndexForLocation(location),
        onTap: (index) => context.goNamed(_tabNameForIndex(index)),
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

class _CityFlowBottomNav extends StatelessWidget {
  const _CityFlowBottomNav({
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: kBackgroundOuter.withValues(alpha: 0.92),
        border: const Border(top: BorderSide(color: kBorder)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(2, 10, 2, 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_navItems.length, (index) {
              final item = _navItems[index];
              final active = index == currentIndex;
              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => onTap(index),
                child: Opacity(
                  opacity: active ? 1 : 0.38,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          item.icon,
                          size: 20,
                          color: active ? kGold : kCream,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.label,
                          style: TextStyle(
                            color: active ? kGold : kMutedText,
                            fontSize: 9,
                            fontWeight:
                                active ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 3,
                          height: 3,
                          decoration: BoxDecoration(
                            color: active ? kGold : kBackgroundOuter,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.icon, this.label);

  final IconData icon;
  final String label;
}

const _navItems = [
  _NavItem(Icons.home_outlined, 'Home'),
  _NavItem(Icons.directions_car_outlined, 'CityRide'),
  _NavItem(Icons.explore_outlined, 'Explore'),
  _NavItem(Icons.inventory_2_outlined, 'Lost & Fnd'),
  _NavItem(Icons.bolt_outlined, 'More'),
];
