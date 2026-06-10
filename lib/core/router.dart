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
  routes: [
    GoRoute(
      name: 'splash',
      path: '/splash',
      builder: (_, __) => const SplashScreen(),
    ),
    GoRoute(
      name: 'onboarding',
      path: '/onboarding',
      builder: (_, __) => const OnboardingScreen(),
    ),
    GoRoute(
      name: 'login',
      path: '/login',
      builder: (_, __) => const LoginScreen(),
    ),
    GoRoute(
      name: 'map',
      path: '/map',
      builder: (_, __) => const MapScreen(),
    ),
    GoRoute(
      name: 'placeDetails',
      path: '/map/place/:id',
      builder: (_, state) => PlaceDetailsScreen(
        id: state.pathParameters['id'] ?? '',
      ),
    ),
    GoRoute(
      name: 'category',
      path: '/explore/:category',
      builder: (_, state) => CategoryScreen(
        category: state.pathParameters['category'] ?? '',
      ),
    ),
    GoRoute(
      name: 'churches',
      path: '/churches',
      builder: (_, __) => const ChurchesScreen(),
    ),
    GoRoute(
      name: 'churchDetails',
      path: '/churches/:id',
      builder: (_, state) => ChurchDetailsScreen(
        id: state.pathParameters['id'] ?? '',
      ),
    ),
    GoRoute(
      name: 'events',
      path: '/events',
      builder: (_, __) => const EventsScreen(),
    ),
    GoRoute(
      name: 'eventDetails',
      path: '/events/:id',
      builder: (_, state) => EventDetailsScreen(
        id: state.pathParameters['id'] ?? '',
      ),
    ),
    GoRoute(
      name: 'gallery',
      path: '/gallery',
      builder: (_, __) => const GalleryScreen(),
    ),
    GoRoute(
      name: 'directory',
      path: '/directory',
      builder: (_, __) => const BusinessDirectoryScreen(),
    ),
    GoRoute(
      name: 'businessDetails',
      path: '/directory/:id',
      builder: (_, state) => BusinessDetailsScreen(
        id: state.pathParameters['id'] ?? '',
      ),
    ),
    GoRoute(
      name: 'requestRide',
      path: '/city-ride/request',
      builder: (_, __) => const RequestRideScreen(),
    ),
    GoRoute(
      name: 'emergency',
      path: '/emergency',
      builder: (_, __) => const EmergencyScreen(),
    ),
    GoRoute(
      name: 'reportItem',
      path: '/lost-and-found/report',
      builder: (_, __) => const ReportItemScreen(),
    ),
    GoRoute(
      name: 'itemDetails',
      path: '/lost-and-found/:id',
      builder: (_, state) => ItemDetailsScreen(
        id: state.pathParameters['id'] ?? '',
      ),
    ),
    GoRoute(
      name: 'aiGuide',
      path: '/ai-guide',
      builder: (_, __) => const AiGuideScreen(),
    ),
    GoRoute(
      name: 'editProfile',
      path: '/profile/edit',
      builder: (_, __) => const EditProfileScreen(),
    ),
    GoRoute(
      name: 'settings',
      path: '/settings',
      builder: (_, __) => const SettingsScreen(),
    ),
    GoRoute(
      name: 'privacyPolicy',
      path: '/settings/privacy',
      builder: (_, __) => const PrivacyPolicyScreen(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => CityFlowShell(
        location: state.uri.path,
        child: child,
      ),
      routes: [
        GoRoute(
          name: 'home',
          path: '/home',
          builder: (_, __) => const HomeScreen(),
        ),
        GoRoute(
          name: 'cityRide',
          path: '/city-ride',
          builder: (_, __) => const CityRideScreen(),
        ),
        GoRoute(
          name: 'explore',
          path: '/explore',
          builder: (_, __) => const ExploreScreen(),
        ),
        GoRoute(
          name: 'lostAndFound',
          path: '/lost-and-found',
          builder: (_, __) => const LostAndFoundScreen(),
        ),
        GoRoute(
          name: 'profile',
          path: '/profile',
          builder: (_, __) => const ProfileScreen(),
        ),
      ],
    ),
  ],
  errorBuilder: (_, state) => Scaffold(
    backgroundColor: kBackground,
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: kDanger, size: 48),
          const SizedBox(height: 16),
          Text(
            'Navigation Error',
            style: Theme.of(_).textTheme.titleMedium?.copyWith(color: kCream),
          ),
          const SizedBox(height: 8),
          Text(
            'Path: ${state.uri.path}',
            style: const TextStyle(color: kMutedText),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () =>
                _rootNavigatorKey.currentState?.pushReplacementNamed('/splash'),
            child: const Text('Go to Splash'),
          ),
        ],
      ),
    ),
  ),
);
