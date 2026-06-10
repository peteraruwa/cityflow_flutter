# CityFlow — Codex Project Memory

> Place this file at: `cityflow_flutter/CODEX.md`
> Codex reads this file at the start of every session to understand
> the project before writing any code.

---

## Project Overview

**App name:** CityFlow
**Type:** Flutter mobile app (iOS + Android)
**Purpose:** Navigation, community guide, and city services app for
Redemption City (RCCG Camp), Ogun State, Nigeria
**Status:** Active development

---

## Absolute Rules — Never Break These

1. Never hardcode hex color values in widget files — always import from `core/colors.dart`
2. Never hardcode coordinates — always import from `core/locations.dart`
3. Never use `Navigator.push` — all navigation via `go_router` named routes in `core/router.dart`
4. Never use `_page.dart` naming — always use `_screen.dart`
5. Never put `user.dart` in `shared/models/` — it belongs in `features/auth/models/`
6. Never put feature-specific models in `shared/models/`
7. Never create a `screens/` subfolder inside a feature folder — screens sit flat
8. Never hardcode API keys in Dart files — load from `.env` via `flutter_dotenv`
9. Never use `setState` for business logic — business logic lives in the controller
10. Never modify `core/router.dart` when building a feature unless the task explicitly says to add a route
11. Never embed list data inline in Dart — load from `assets/data/*.json` via `rootBundle`
12. Never add new packages to the project without being explicitly told to

---

## Key Coordinates

```dart
// lib/core/locations.dart — single source of truth
const kRedemptionCityLat = 6.4531;
const kRedemptionCityLon = 3.3958;
const kRedemptionCityName = "Redemption City";
```

---

## Folder Structure

```
cityflow_flutter/
│
├── assets/
│   ├── images/
│   ├── icons/
│   ├── fonts/
│   └── data/
│       ├── places.json
│       ├── churches.json
│       ├── events.json
│       └── emergency_contacts.json
│
├── lib/
│   ├── main.dart
│   │
│   ├── core/
│   │   ├── app.dart
│   │   ├── router.dart
│   │   ├── theme.dart
│   │   ├── constants.dart
│   │   ├── colors.dart
│   │   ├── locations.dart
│   │   ├── api_service.dart
│   │   ├── storage_service.dart
│   │   ├── location_service.dart
│   │   └── utils/
│   │       ├── date_utils.dart
│   │       ├── string_utils.dart
│   │       └── location_utils.dart
│   │
│   ├── shared/
│   │   ├── widgets/
│   │   │   ├── custom_button.dart
│   │   │   ├── custom_text_field.dart
│   │   │   ├── place_card.dart
│   │   │   ├── event_card.dart
│   │   │   └── loading_view.dart
│   │   └── models/
│   │       ├── place.dart
│   │       └── event.dart
│   │
│   └── features/
│       ├── splash/
│       │   ├── splash_screen.dart
│       │   └── splash_controller.dart
│       │
│       ├── onboarding/
│       │   ├── onboarding_screen.dart
│       │   └── onboarding_controller.dart
│       │
│       ├── auth/
│       │   ├── login_screen.dart
│       │   ├── register_screen.dart
│       │   ├── auth_controller.dart
│       │   ├── auth_service.dart
│       │   └── models/
│       │       └── user.dart
│       │
│       ├── home/
│       │   ├── home_screen.dart
│       │   ├── home_controller.dart
│       │   └── widgets/
│       │       ├── quick_actions.dart
│       │       ├── featured_places.dart
│       │       └── upcoming_events.dart
│       │
│       ├── map/
│       │   ├── map_screen.dart
│       │   ├── place_details_screen.dart
│       │   ├── map_controller.dart
│       │   ├── map_service.dart
│       │   └── widgets/
│       │       ├── map_search_bar.dart
│       │       ├── place_marker.dart
│       │       └── route_card.dart
│       │
│       ├── explore/
│       │   ├── explore_screen.dart
│       │   ├── category_screen.dart
│       │   └── explore_controller.dart
│       │
│       ├── city_ride/
│       │   ├── city_ride_screen.dart
│       │   ├── request_ride_screen.dart
│       │   ├── ride_controller.dart
│       │   └── ride_service.dart
│       │
│       ├── emergency/
│       │   ├── emergency_screen.dart
│       │   ├── emergency_controller.dart
│       │   ├── emergency_service.dart
│       │   └── widgets/
│       │       ├── emergency_contact_card.dart
│       │       └── sos_button.dart
│       │
│       ├── lost_and_found/
│       │   ├── lost_and_found_screen.dart
│       │   ├── report_item_screen.dart
│       │   ├── item_details_screen.dart
│       │   ├── lost_found_controller.dart
│       │   └── models/
│       │       └── lost_item.dart
│       │
│       ├── ai_guide/
│       │   ├── ai_guide_screen.dart
│       │   ├── ai_guide_controller.dart
│       │   └── ai_guide_service.dart
│       │
│       ├── directory/
│       │   ├── business_directory_screen.dart
│       │   ├── business_details_screen.dart
│       │   ├── directory_controller.dart
│       │   └── models/
│       │       └── business.dart
│       │
│       ├── events/
│       │   ├── events_screen.dart
│       │   ├── event_details_screen.dart
│       │   ├── events_controller.dart
│       │   └── models/
│       │       └── event_detail.dart
│       │
│       ├── churches/
│       │   ├── churches_screen.dart
│       │   ├── church_details_screen.dart
│       │   ├── churches_controller.dart
│       │   └── models/
│       │       └── church.dart
│       │
│       ├── gallery/
│       │   ├── gallery_screen.dart
│       │   ├── gallery_controller.dart
│       │   └── widgets/
│       │       ├── daily_image_card.dart
│       │       └── gallery_grid.dart
│       │
│       ├── profile/
│       │   ├── profile_screen.dart
│       │   ├── edit_profile_screen.dart
│       │   └── profile_controller.dart
│       │
│       └── settings/
│           ├── settings_screen.dart
│           ├── privacy_policy_screen.dart
│           └── settings_controller.dart
│
├── test/
│   ├── widget_test.dart
│   └── features/
│
├── pubspec.yaml
├── analysis_options.yaml
├── CODEX.md
├── README.md
└── .gitignore
```

---

## Naming Conventions

| Thing | Convention | Example |
|---|---|---|
| Screen files | `snake_case_screen.dart` | `church_details_screen.dart` |
| Controller files | `snake_case_controller.dart` | `churches_controller.dart` |
| Service files | `snake_case_service.dart` | `emergency_service.dart` |
| Model files | `snake_case.dart` | `lost_item.dart` |
| Widget files | `snake_case.dart` | `sos_button.dart` |
| Classes | `PascalCase` | `ChurchDetailsScreen` |
| Constants | `kCamelCase` | `kRedemptionCityLat` |
| Riverpod providers | `camelCaseProvider` | `churchesControllerProvider` |

---

## Design Tokens

All color constants live in `lib/core/colors.dart`.
Never use hex values directly in widget files.

```dart
kBackground  = Color(0xFF08011A)  // dark navy — app background
kPurple      = Color(0xFF7128CE)  // primary brand purple
kPurpleLight = Color(0xFF8B5CF6)  // hover/active states
kGold        = Color(0xFFC48D38)  // accent, section headers, borders
kCream       = Color(0xFFEBE3D6)  // body text, card text
```

Default gradient: LinearGradient from kBackground to kPurple (top to bottom).
Section headers: kGold
Body text: kCream
Primary buttons: kPurple background, kCream text

---

## State Management

**Package:** `flutter_riverpod`

- Every feature controller is a `StateNotifier` or `AsyncNotifier`
- Exposed as a Riverpod `Provider` or `AsyncNotifierProvider`
- No `setState` for business logic — only for isolated local UI state
- Controllers live in `*_controller.dart`, never inside screen files

---

## Navigation

**Package:** `go_router` — configured in `lib/core/router.dart`

Named routes:

| Route name | Path | Screen |
|---|---|---|
| `splash` | `/splash` | SplashScreen |
| `onboarding` | `/onboarding` | OnboardingScreen |
| `home` | `/home` | HomeScreen |
| `map` | `/map` | MapScreen |
| `placeDetails` | `/map/place/:id` | PlaceDetailsScreen |
| `explore` | `/explore` | ExploreScreen |
| `category` | `/explore/:category` | CategoryScreen |
| `churches` | `/churches` | ChurchesScreen |
| `churchDetails` | `/churches/:id` | ChurchDetailsScreen |
| `events` | `/events` | EventsScreen |
| `eventDetails` | `/events/:id` | EventDetailsScreen |
| `gallery` | `/gallery` | GalleryScreen |
| `directory` | `/directory` | BusinessDirectoryScreen |
| `businessDetails` | `/directory/:id` | BusinessDetailsScreen |
| `cityRide` | `/city-ride` | CityRideScreen |
| `requestRide` | `/city-ride/request` | RequestRideScreen |
| `emergency` | `/emergency` | EmergencyScreen |
| `lostAndFound` | `/lost-and-found` | LostAndFoundScreen |
| `reportItem` | `/lost-and-found/report` | ReportItemScreen |
| `itemDetails` | `/lost-and-found/:id` | ItemDetailsScreen |
| `aiGuide` | `/ai-guide` | AiGuideScreen |
| `profile` | `/profile` | ProfileScreen |
| `editProfile` | `/profile/edit` | EditProfileScreen |
| `settings` | `/settings` | SettingsScreen |
| `privacyPolicy` | `/settings/privacy` | PrivacyPolicyScreen |

Initial route: `/splash`
Bottom nav uses `ShellRoute` for persistent navigation across tabs.

---

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.6.1
  go_router: ^14.6.2
  dio: ^5.7.0
  shared_preferences: ^2.3.3
  mhj_maps: any
  geolocator: ^13.0.2
  cached_network_image: ^3.4.1
  flutter_svg: ^2.0.16
  intl: ^0.20.1
  lottie: ^3.1.3
  flutter_dotenv: ^5.2.1
  url_launcher: ^6.3.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
```

Do not add any package not listed here without explicit instruction.

---

## API Keys

Loaded from `.env` at project root via `flutter_dotenv`.
`.env` is gitignored — never commit it.

```
# .env
ANTHROPIC_API_KEY=your_key_here
GOOGLE_MAPS_API_KEY=your_key_here
```

If `.env` is missing, log a clear error and fail gracefully — no crash.

---

## AI Guide Feature

- **Endpoint:** `https://api.anthropic.com/v1/messages`
- **Model:** `claude-sonnet-4-20250514`
- **Max tokens:** `1000`
- **System prompt:**

```
You are CityFlow Assistant, a helpful guide for Redemption City
(RCCG Camp), Ogun State, Nigeria. Help visitors navigate the city,
find churches, events, businesses, and services within the camp.
Keep responses concise and practical.
```

User messages are sent with full conversation history on every call
(no server-side memory). History is managed in `ai_guide_controller.dart`.

---

## Static Data Assets

Source of truth until a backend is connected.
Loaded with `rootBundle.loadString(path)` and parsed with `json.decode`.

```
assets/data/places.json              # POIs for map and explore features
assets/data/churches.json            # Church list for churches feature
assets/data/events.json              # Events list for events feature
assets/data/emergency_contacts.json  # Contacts for emergency feature
```

---

## Gallery — Daily Rotation Logic

Picture-of-the-day must be consistent all day and change at midnight.
Use day-of-year as seed, not millisecondsSinceEpoch.

```dart
// lib/features/gallery/gallery_controller.dart
final dayOfYear = int.parse(DateFormat("D").format(DateTime.now()));
final index = dayOfYear % images.length;
```

This logic lives only in `gallery_controller.dart`. Never duplicated.

---

## Every Screen Must Have Three States

Every screen that loads async data must handle all three states:

| State | Widget to show |
|---|---|
| Loading | `LoadingView()` from `shared/widgets/loading_view.dart` |
| Data | Content UI |
| Error | Error message text + retry `ElevatedButton` |

Every screen that shows a list must have an empty state:
a centered icon and a descriptive message when the list is empty.

---

## Test File Structure

Test files mirror the feature structure exactly:

```
test/
└── features/
    ├── churches/
    │   └── churches_controller_test.dart
    ├── gallery/
    │   └── gallery_controller_test.dart
    ├── events/
    │   └── events_controller_test.dart
    └── lost_and_found/
        └── lost_found_controller_test.dart
```

---

## Build & Run Commands

```bash
flutter clean             # Clear stale build/tool cache when Flutter/Dart tooling hangs or packages are out of sync
flutter pub get           # Install / sync dependencies
dart fix --apply          # Apply safe automated Dart fixes after analyzer findings
flutter run               # Run on connected device or emulator
flutter analyze           # Static analysis — run before committing
flutter test              # Run all tests
flutter build apk         # Android release APK
flutter build appbundle   # Android release bundle (Play Store)
flutter build ios         # iOS release build
```

---

## Known Decisions

- `mhj_maps` is used instead of `google_maps_flutter` (no API key required)
- All map previews in detail screens are non-interactive (fixed camera)
- `city_ride` uses mock data only — no real ride backend
- Gallery images use `picsum.photos` placeholders until real Firebase Storage URLs are provided
- AI Guide requires `ANTHROPIC_API_KEY` in `assets/.env` to function

---

## Build Order Reference

Build features in this order to respect dependencies:

1. `pubspec.yaml` — dependencies and asset registration
2. `core/constants.dart`, `core/locations.dart` — constants first
3. `core/colors.dart`, `core/theme.dart` — design tokens
4. `core/router.dart` — routing skeleton with placeholder screens
5. `core/app.dart`, `main.dart` — entry point
6. `core/storage_service.dart`, `core/location_service.dart`, `core/api_service.dart`
7. `shared/widgets/` — shared UI components
8. `features/splash/` → `features/onboarding/` → `features/home/`
9. Remaining features in any order (they are independent after step 8)
10. Bottom navigation (`ShellRoute` in `core/router.dart`)
11. Final audit: empty states, loading states, error states, navigation wiring

---

## What This App Is Not

- Not a real-time ride-hailing app — `city_ride` is a request/matching MVP
- Not a social network — no feed, no follows, no likes
- Not a full e-commerce directory — `directory` is a listings guide only
- Not a Firebase app (yet) — all data is local JSON until backend is specified
