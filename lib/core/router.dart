import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/ai_guide/ai_guide_screen.dart';
import '../features/churches/church_details_screen.dart';
import '../features/churches/churches_screen.dart';
import '../features/city_ride/city_ride_screen.dart';
import '../features/city_ride/request_ride_screen.dart';
import '../features/directory/business_details_screen.dart';
import '../features/directory/business_directory_screen.dart';
import '../features/emergency/emergency_screen.dart';
import '../features/events/event_details_screen.dart';
import '../features/events/events_screen.dart';
import '../features/explore/category_screen.dart';
import '../features/explore/explore_screen.dart';
import '../features/gallery/gallery_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/home/home_screen.dart';
import '../features/lost_and_found/item_details_screen.dart';
import '../features/lost_and_found/lost_and_found_screen.dart';
import '../features/lost_and_found/report_item_screen.dart';
import '../features/map/map_screen.dart';
import '../features/map/place_details_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/profile/edit_profile_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/settings/privacy_policy_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/splash/splash_screen.dart';
import 'app.dart';
import 'colors.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  debugLogDiagnostics: true, // ADD THIS - enables GoRouter debug logging
  redirect: (context, state) {
    debugPrint('🔄 ROUTER REDIRECT: ${state.uri.path}'); // DEBUG
    return null;
  },
  routes: [
    GoRoute(
      name: 'splash',
      path: '/splash',
      builder: (_, __) {
        debugPrint('📍 ROUTER: Building SplashScreen');
        return const SplashScreen();
      },
    ),
    GoRoute(
      name: 'onboarding',
      path: '/onboarding',
      builder: (_, __) {
        debugPrint('📍 ROUTER: Building OnboardingScreen');
        return const OnboardingScreen();
      },
    ),
    GoRoute(
      name: 'login',
      path: '/login',
      builder: (_, __) {
        debugPrint('📍 ROUTER: Building LoginScreen');
        return const LoginScreen();
      },
    ),
    GoRoute(
      name: 'map',
      path: '/map',
      builder: (_, __) {
        debugPrint('📍 ROUTER: Building MapScreen');
        return const MapScreen();
      },
    ),
    GoRoute(
      name: 'placeDetails',
      path: '/map/place/:id',
      builder: (_, state) {
        debugPrint(
            '📍 ROUTER: Building PlaceDetailsScreen for id=${state.pathParameters['id']}');
        return PlaceDetailsScreen(
          id: state.pathParameters['id'] ?? '',
        );
      },
    ),
    GoRoute(
      name: 'category',
      path: '/explore/:category',
      builder: (_, state) {
        debugPrint(
            '📍 ROUTER: Building CategoryScreen for category=${state.pathParameters['category']}');
        return CategoryScreen(
          category: state.pathParameters['category'] ?? '',
        );
      },
    ),
    GoRoute(
      name: 'churches',
      path: '/churches',
      builder: (_, __) {
        debugPrint('📍 ROUTER: Building ChurchesScreen');
        return const ChurchesScreen();
      },
    ),
    GoRoute(
      name: 'churchDetails',
      path: '/churches/:id',
      builder: (_, state) {
        debugPrint(
            '📍 ROUTER: Building ChurchDetailsScreen for id=${state.pathParameters['id']}');
        return ChurchDetailsScreen(
          id: state.pathParameters['id'] ?? '',
        );
      },
    ),
    GoRoute(
      name: 'events',
      path: '/events',
      builder: (_, __) {
        debugPrint('📍 ROUTER: Building EventsScreen');
        return const EventsScreen();
      },
    ),
    GoRoute(
      name: 'eventDetails',
      path: '/events/:id',
      builder: (_, state) {
        debugPrint(
            '📍 ROUTER: Building EventDetailsScreen for id=${state.pathParameters['id']}');
        return EventDetailsScreen(
          id: state.pathParameters['id'] ?? '',
        );
      },
    ),
    GoRoute(
      name: 'gallery',
      path: '/gallery',
      builder: (_, __) {
        debugPrint('📍 ROUTER: Building GalleryScreen');
        return const GalleryScreen();
      },
    ),
    GoRoute(
      name: 'directory',
      path: '/directory',
      builder: (_, __) {
        debugPrint('📍 ROUTER: Building BusinessDirectoryScreen');
        return const BusinessDirectoryScreen();
      },
    ),
    GoRoute(
      name: 'businessDetails',
      path: '/directory/:id',
      builder: (_, state) {
        debugPrint(
            '📍 ROUTER: Building BusinessDetailsScreen for id=${state.pathParameters['id']}');
        return BusinessDetailsScreen(
          id: state.pathParameters['id'] ?? '',
        );
      },
    ),
    GoRoute(
      name: 'requestRide',
      path: '/city-ride/request',
      builder: (_, __) {
        debugPrint('📍 ROUTER: Building RequestRideScreen');
        return const RequestRideScreen();
      },
    ),
    GoRoute(
      name: 'emergency',
      path: '/emergency',
      builder: (_, __) {
        debugPrint('📍 ROUTER: Building EmergencyScreen');
        return const EmergencyScreen();
      },
    ),
    GoRoute(
      name: 'reportItem',
      path: '/lost-and-found/report',
      builder: (_, __) {
        debugPrint('📍 ROUTER: Building ReportItemScreen');
        return const ReportItemScreen();
      },
    ),
    GoRoute(
      name: 'itemDetails',
      path: '/lost-and-found/:id',
      builder: (_, state) {
        debugPrint(
            '📍 ROUTER: Building ItemDetailsScreen for id=${state.pathParameters['id']}');
        return ItemDetailsScreen(
          id: state.pathParameters['id'] ?? '',
        );
      },
    ),
    GoRoute(
      name: 'aiGuide',
      path: '/ai-guide',
      builder: (_, __) {
        debugPrint('📍 ROUTER: Building AiGuideScreen');
        return const AiGuideScreen();
      },
    ),
    GoRoute(
      name: 'editProfile',
      path: '/profile/edit',
      builder: (_, __) {
        debugPrint('📍 ROUTER: Building EditProfileScreen');
        return const EditProfileScreen();
      },
    ),
    GoRoute(
      name: 'settings',
      path: '/settings',
      builder: (_, __) {
        debugPrint('📍 ROUTER: Building SettingsScreen');
        return const SettingsScreen();
      },
    ),
    GoRoute(
      name: 'privacyPolicy',
      path: '/settings/privacy',
      builder: (_, __) {
        debugPrint('📍 ROUTER: Building PrivacyPolicyScreen');
        return const PrivacyPolicyScreen();
      },
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        debugPrint('📍 ROUTER: Building ShellRoute for location=${state.uri.path}');
        return CityFlowShell(
          location: state.uri.path,
          child: child,
        );
      },
      routes: [
        GoRoute(
          name: 'home',
          path: '/home',
          builder: (_, __) {
            debugPrint('📍 ROUTER: Building HomeScreen');
            return const HomeScreen();
          },
        ),
        GoRoute(
          name: 'cityRide',
          path: '/city-ride',
          builder: (_, __) {
            debugPrint('📍 ROUTER: Building CityRideScreen');
            return const CityRideScreen();
          },
        ),
        GoRoute(
          name: 'explore',
          path: '/explore',
          builder: (_, __) {
            debugPrint('📍 ROUTER: Building ExploreScreen');
            return const ExploreScreen();
          },
        ),
        GoRoute(
          name: 'lostAndFound',
          path: '/lost-and-found',
          builder: (_, __) {
            debugPrint('📍 ROUTER: Building LostAndFoundScreen');
            return const LostAndFoundScreen();
          },
        ),
        GoRoute(
          name: 'profile',
          path: '/profile',
          builder: (_, __) {
            debugPrint('📍 ROUTER: Building ProfileScreen');
            return const ProfileScreen();
          },
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) {
    debugPrint('❌ ROUTER ERROR: ${state.error}');
    debugPrint('❌ ROUTER ERROR location: ${state.uri.path}');
    return Scaffold(
      backgroundColor: kBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: kDanger, size: 48),
            const SizedBox(height: 16),
            Text(
              'Navigation Error',
              style:
                  Theme.of(context).textTheme.titleMedium?.copyWith(color: kCream),
            ),
            const SizedBox(height: 8),
            Text(
              'Path: ${state.uri.path}',
              style: const TextStyle(color: kMutedText),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.goNamed('splash'),
              child: const Text('Go to Splash'),
            ),
          ],
        ),
      ),
    );
  },
);
