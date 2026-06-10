import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/colors.dart';
import '../../shared/models/event.dart';
import '../../shared/models/place.dart';
import '../../shared/widgets/app_screen.dart';
import '../../shared/widgets/error_view.dart';
import '../../shared/widgets/loading_view.dart';
import 'home_controller.dart';

// Static data for home screen sections
const _quotes = [
  _Quote(
    text:
        'Faith is the substance of things hoped for, the evidence of things not seen.',
    author: 'Hebrews 11:1',
  ),
  _Quote(
    text: 'I can do all things through Christ who strengthens me.',
    author: 'Philippians 4:13',
  ),
  _Quote(
    text: 'The Lord is my shepherd; I shall not want.',
    author: 'Psalm 23:1',
  ),
];

const _tickerItems = [
  'Sunday Victory Service — 7:00 AM at New Arena',
  'Digging Deep — Tuesday 6 PM at Faith Chapel',
  'Camp store open daily 8 AM – 9 PM',
  'CityRide shuttle: Gate A – Arena – Zone D',
];

class _Quote {
  const _Quote({required this.text, required this.author});
  final String text;
  final String author;
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  int _quoteIndex = 0;
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning,';
    if (hour < 17) return 'Good afternoon,';
    return 'Good evening,';
  }

  @override
  Widget build(BuildContext context) {
    final homeData = ref.watch(homeControllerProvider);

    return homeData.when(
      loading: () => const Scaffold(
        backgroundColor: kBackground,
        body: LoadingView(),
      ),
      error: (error, _) => Scaffold(
        backgroundColor: kBackground,
        body: ErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(homeControllerProvider),
        ),
      ),
      data: (data) => Scaffold(
        backgroundColor: kBackground,
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [kBackground, kBackground, kPurple],
              stops: [0, 0.68, 1],
            ),
          ),
          child: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(homeControllerProvider);
                await ref.read(homeControllerProvider.future);
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
                children: [
                  // App Bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
                    child: _AppBar(
                      onSearchTap: () => context.goNamed('explore'),
                      onBellTap: () {},
                    ),
                  ),
                  const Divider(
                    height: 1,
                    color: Color(0x18C48D38),
                    indent: 18,
                    endIndent: 18,
                  ),
                  // News Ticker
                  _NewsTicker(items: _tickerItems),
                  // Greeting + Weather
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
                    child: _GreetingWeather(greeting: _greeting()),
                  ),
                  // Quote of the Day
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 20, 18, 0),
                    child: _QuoteCard(
                      quote: _quotes[_quoteIndex],
                      quoteIndex: _quoteIndex,
                      total: _quotes.length,
                      onDotTap: (i) => setState(() => _quoteIndex = i),
                    ),
                  ),
                  // Hero LIVE Card
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 20, 18, 0),
                    child: _HeroLiveCard(
                      pulseController: _pulseController,
                      onDirections: () => context.goNamed('map'),
                      onDetails: () => context.goNamed('events'),
                    ),
                  ),
                  // Emergency SOS Banner
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
                    child: _EmergencyBanner(
                      pulseController: _pulseController,
                      onTap: () => context.goNamed('emergency'),
                    ),
                  ),
                  // Quick Actions 2x2
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 20, 18, 0),
                    child: _QuickActionsGrid(),
                  ),
                  // Upcoming Events
                  if (data.events.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 24, 18, 0),
                      child: SectionHeader(
                        title: 'Upcoming Events',
                        actionLabel: 'See all',
                        onAction: () => context.goNamed('events'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 130,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        scrollDirection: Axis.horizontal,
                        itemCount: data.events.take(6).length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final event = data.events[index];
                          return _EventChip(
                            event: event,
                            onTap: () => context.goNamed(
                              'eventDetails',
                              pathParameters: {'id': event.id},
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                  // News & Announcements
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 24, 18, 0),
                    child: const SectionHeader(title: 'News & Announcements'),
                  ),
                  const SizedBox(height: 12),
                  ..._newsItems.map(
                    (item) => Padding(
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 10),
                      child: _NewsCard(item: item),
                    ),
                  ),
                  // City Tour
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
                    child: _CityTourCard(
                      onTap: () => context.goNamed('map'),
                    ),
                  ),
                  // Find a Church
                  if (data.places.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 24, 18, 0),
                      child: SectionHeader(
                        title: 'Find a Church',
                        actionLabel: 'See all',
                        onAction: () => context.goNamed('churches'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...data.places
                        .where((p) => p.category == 'church')
                        .take(2)
                        .map(
                          (p) => Padding(
                            padding:
                                const EdgeInsets.fromLTRB(18, 0, 18, 10),
                            child: _ChurchCard(place: p),
                          ),
                        ),
                  ],
                  // CityFlow AI Preview
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
                    child: _AiPreviewCard(
                      onTap: () => context.goNamed('aiGuide'),
                    ),
                  ),
                  // Did You Know
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
                    child: const _DidYouKnowCard(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar({required this.onSearchTap, required this.onBellTap});

  final VoidCallback onSearchTap;
  final VoidCallback onBellTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CityFlow',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: kCream,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.4,
                    ),
              ),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined,
                      color: kGold, size: 12),
                  const SizedBox(width: 3),
                  Text(
                    'Redemption City · 110115',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: kMutedText,
                          fontSize: 11,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onSearchTap,
          icon: const Icon(Icons.search, color: kCream),
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              onPressed: onBellTap,
              icon: const Icon(Icons.notifications_none, color: kCream),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: kGold,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _NewsTicker extends StatefulWidget {
  const _NewsTicker({required this.items});
  final List<String> items;

  @override
  State<_NewsTicker> createState() => _NewsTickerState();
}

class _NewsTickerState extends State<_NewsTicker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final ScrollController _scrollController;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.5, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = widget.items.join('   •   ');

    return Container(
      height: 36,
      color: kGold.withValues(alpha: 0.07),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _pulse,
            builder: (context, child) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding:
                  const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: kGold.withValues(alpha: _pulse.value),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'NEWS',
                style: TextStyle(
                  color: kBackground,
                  fontWeight: FontWeight.w800,
                  fontSize: 9,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _scrollController,
              child: Text(
                text,
                style: const TextStyle(
                  color: kCream,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GreetingWeather extends StatelessWidget {
  const _GreetingWeather({required this.greeting});
  final String greeting;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: kMutedText,
                    ),
              ),
              Text(
                'Peter 👋',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: kCream,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                "Here's what's happening in the city today.",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: kMutedText,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: kBorder),
            borderRadius: BorderRadius.circular(20),
            color: kSurface,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wb_sunny_outlined,
                  color: kGold, size: 16),
              const SizedBox(width: 5),
              Text(
                '29° / Sunny',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: kCream,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuoteCard extends StatelessWidget {
  const _QuoteCard({
    required this.quote,
    required this.quoteIndex,
    required this.total,
    required this.onDotTap,
  });

  final _Quote quote;
  final int quoteIndex;
  final int total;
  final void Function(int) onDotTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            kGold.withValues(alpha: 0.18),
            kGold.withValues(alpha: 0.04),
          ],
        ),
        border: Border.all(color: kGold.withValues(alpha: 0.32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.format_quote, color: kGold, size: 36),
              const Spacer(),
              Text(
                'QUOTE OF THE DAY',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: kGold,
                      letterSpacing: 1,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '"${quote.text}"',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: kCream,
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            '— ${quote.author}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: kGold,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              total,
              (i) => GestureDetector(
                onTap: () => onDotTap(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: i == quoteIndex ? 18 : 6,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: i == quoteIndex ? kGold : kDimText,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroLiveCard extends StatelessWidget {
  const _HeroLiveCard({
    required this.pulseController,
    required this.onDirections,
    required this.onDetails,
  });

  final AnimationController pulseController;
  final VoidCallback onDirections;
  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            kPurple.withValues(alpha: 0.8),
            kPurpleDark,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kPurpleLight.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AnimatedBuilder(
                animation: pulseController,
                builder: (context, _) => Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: kDanger.withValues(
                        alpha: 0.5 + pulseController.value * 0.5),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: kDanger.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                      color: kDanger.withValues(alpha: 0.4)),
                ),
                child: const Text(
                  'LIVE NOW',
                  style: TextStyle(
                    color: kDanger,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Sunday Victory Service',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: kCream,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  color: kPurpleLight, size: 14),
              const SizedBox(width: 4),
              const Text(
                'New Arena Auditorium',
                style: TextStyle(color: kMutedText, fontSize: 12),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.access_time_outlined,
                  color: kPurpleLight, size: 14),
              const SizedBox(width: 4),
              const Text(
                '7:00 AM',
                style: TextStyle(color: kMutedText, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _HeroButton(
                  label: 'Get Directions',
                  isPrimary: true,
                  onTap: onDirections,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _HeroButton(
                  label: 'View Details',
                  isPrimary: false,
                  onTap: onDetails,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroButton extends StatelessWidget {
  const _HeroButton({
    required this.label,
    required this.isPrimary,
    required this.onTap,
  });

  final String label;
  final bool isPrimary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: isPrimary ? kPurple : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isPrimary
                ? kPurpleLight.withValues(alpha: 0.4)
                : kCream.withValues(alpha: 0.3),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isPrimary ? kCream : kCream.withValues(alpha: 0.8),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

class _EmergencyBanner extends StatelessWidget {
  const _EmergencyBanner({
    required this.pulseController,
    required this.onTap,
  });

  final AnimationController pulseController;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: kDanger.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: kDanger.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.warning_amber_outlined,
                color: kDanger, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Emergency / SOS',
                    style: TextStyle(
                      color: kDanger,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Ambulance 199  •  Police 112  •  Fire 190  •  Road 122',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: kMutedText,
                        ),
                  ),
                ],
              ),
            ),
            AnimatedBuilder(
              animation: pulseController,
              builder: (context, child) => Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: kDanger.withValues(
                      alpha: 0.4 + pulseController.value * 0.6),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: kDimText),
          ],
        ),
      ),
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2.4,
      children: const [
        _QuickActionTile(
          icon: Icons.navigation_outlined,
          label: 'Navigate',
          color: kPurple,
          routeName: 'map',
        ),
        _QuickActionTile(
          icon: Icons.directions_car_outlined,
          label: 'CityRide',
          color: kGold,
          routeName: 'cityRide',
        ),
        _QuickActionTile(
          icon: Icons.hotel_outlined,
          label: 'Stay',
          color: Color(0xFF3B82F6),
          routeName: 'explore',
        ),
        _QuickActionTile(
          icon: Icons.event_outlined,
          label: 'Events',
          color: Color(0xFF22C55E),
          routeName: 'events',
        ),
      ],
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.routeName,
  });

  final IconData icon;
  final String label;
  final Color color;
  final String routeName;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => context.goNamed(routeName),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.26)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 10),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: kCream,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EventChip extends StatelessWidget {
  const _EventChip({required this.event, required this.onTap});

  final Event event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final parts = event.date.split('-');
    final day = parts.length >= 2
        ? _monthName(int.tryParse(parts[1]) ?? 1)
        : '';
    final num = parts.length >= 3 ? parts[2] : '';

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: kBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: kPurple.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '$day $num',
                    style: const TextStyle(
                      color: kPurpleLight,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              event.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: kCream,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              event.venue,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: kMutedText, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    if (month < 1 || month > 12) return '';
    return months[month - 1];
  }
}

const _newsItems = [
  _NewsItem(
    icon: Icons.campaign_outlined,
    title: 'Camp Registration Open',
    body: 'Register for camp accommodation and transport packages.',
    time: '2h ago',
    color: kPurple,
  ),
  _NewsItem(
    icon: Icons.volunteer_activism_outlined,
    title: 'Prayer Drive Tonight',
    body: 'Join the midnight prayer drive at the Old Auditorium.',
    time: '5h ago',
    color: kGold,
  ),
  _NewsItem(
    icon: Icons.info_outline,
    title: 'Gate B Closure Notice',
    body: 'Gate B will be closed for maintenance until 4 PM today.',
    time: '8h ago',
    color: kDanger,
  ),
];

class _NewsItem {
  const _NewsItem({
    required this.icon,
    required this.title,
    required this.body,
    required this.time,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String body;
  final String time;
  final Color color;
}

class _NewsCard extends StatelessWidget {
  const _NewsCard({required this.item});
  final _NewsItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item.icon, color: item.color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    color: kCream,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.body,
                  style: const TextStyle(
                      color: kMutedText, fontSize: 12, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            item.time,
            style: const TextStyle(color: kDimText, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _CityTourCard extends StatelessWidget {
  const _CityTourCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF3B82F6).withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: const Color(0xFF3B82F6).withValues(alpha: 0.25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.explore_outlined,
                    color: Color(0xFF60A5FA), size: 20),
                const SizedBox(width: 8),
                Text(
                  'Guided City Tour',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: kCream,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const Spacer(),
                const Text(
                  '8 stops',
                  style: TextStyle(
                      color: Color(0xFF60A5FA),
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: const [
                _StopChip('New Arena'),
                _StopChip('Old Auditorium'),
                _StopChip('Youth Centre'),
                _StopChip('Medical Centre'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StopChip extends StatelessWidget {
  const _StopChip(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF3B82F6).withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: const Color(0xFF3B82F6).withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF93C5FD),
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ChurchCard extends StatelessWidget {
  const _ChurchCard({required this.place});
  final Place place;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: kPurple.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.account_balance_outlined,
                color: kPurpleLight, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place.name,
                  style: const TextStyle(
                    color: kCream,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: kPurple.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Sun 7:00 AM',
                        style: TextStyle(
                          color: kPurpleLight,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.location_on_outlined,
                        color: kMutedText, size: 12),
                    const SizedBox(width: 2),
                    const Text(
                      '0.2 km',
                      style: TextStyle(color: kMutedText, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AiPreviewCard extends StatelessWidget {
  const _AiPreviewCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: kPurple.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:
                      const Icon(Icons.smart_toy_outlined, color: kPurpleLight),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CityFlow AI',
                      style: TextStyle(
                        color: kCream,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: kSuccess,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Online',
                          style: TextStyle(color: kSuccess, fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: kSurfaceHigh,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Hello! I\'m CityFlow AI. How can I help you navigate Redemption City today?',
                style: TextStyle(
                  color: kCream,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: const [
                _AiChip('Find a restaurant'),
                _AiChip('Book a ride'),
                _AiChip('Emergency help'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AiChip extends StatelessWidget {
  const _AiChip(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: kPurple.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kPurple.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: kPurpleLight,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

const _didYouKnowFacts = [
  'Redemption City spans over 2,500 hectares making it one of the largest planned cities in Africa.',
  'The RCCG New Auditorium seats over one million worshippers.',
  'Redemption City has its own police station, hospital, and university.',
];

class _DidYouKnowCard extends StatefulWidget {
  const _DidYouKnowCard();

  @override
  State<_DidYouKnowCard> createState() => _DidYouKnowCardState();
}

class _DidYouKnowCardState extends State<_DidYouKnowCard> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kPurple.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kPurple.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb_outline, color: kGold, size: 18),
              const SizedBox(width: 6),
              Text(
                'Did You Know?',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: kGold,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _didYouKnowFacts[_index],
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: kCream,
                  height: 1.5,
                ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _didYouKnowFacts.length,
              (i) => GestureDetector(
                onTap: () => setState(() => _index = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: i == _index ? 16 : 6,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: i == _index ? kPurpleLight : kDimText,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
