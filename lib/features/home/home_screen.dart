import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/colors.dart';
import '../../core/locations.dart';
import '../../shared/widgets/error_view.dart';
import '../../shared/widgets/loading_view.dart';
import 'home_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        body: SafeArea(
          bottom: false,
          child: ListView(
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            children: [
              const _HomeHeader(),
              const _DividerLine(),
              _NewsTicker(items: _stringList(data.feed['ticker'])),
              _GreetingWeather(
                greeting: _greeting(),
                onWeather: () {},
              ),
              _QuoteCard(quotes: _mapList(data.feed['quotes'])),
              const _LiveServiceCard(),
              const _EmergencyBanner(),
              const _QuickActions(),
              _EventsPreview(events: _mapList(data.feed['events'])),
              const _Announcements(),
              const _CityTour(),
              _FindChurch(churches: _mapList(data.feed['churches'])),
              const _BusinessDirectory(),
              const _AiPreview(),
              _PictureOfTheDay(pic: _mapValue(data.feed['gallery'])),
              _DidYouKnow(fact: _mapValue(data.feed['fact'])),
              const _QuizCard(),
              _OpenHeaven(devotional: _mapValue(data.feed['devotional'])),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  static String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'CityFlow',
                style: TextStyle(
                  color: kCream,
                  fontFamily: 'Cinzel',
                  fontSize: 21,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.26,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 10, color: kGold),
                  const SizedBox(width: 4),
                  Text(
                    '$kRedemptionCityName - 110115',
                    style: const TextStyle(
                      color: kMutedText,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              _HeaderIcon(
                icon: Icons.search,
                onTap: () => context.goNamed('explore'),
              ),
              const SizedBox(width: 10),
              _HeaderIcon(
                icon: Icons.notifications_none,
                showDot: true,
                onTap: () => context.goNamed('profile'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({
    required this.icon,
    required this.onTap,
    this.showDot = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(13),
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: kSurface,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: kBorder),
            ),
            child: Icon(icon, color: kCream, size: 16),
          ),
          if (showDot)
            Positioned(
              top: 9,
              right: 9,
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: kGold,
                  shape: BoxShape.circle,
                  border: Border.all(color: kBackground, width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DividerLine extends StatelessWidget {
  const _DividerLine();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 4),
      color: kWhite.withValues(alpha: 0.055),
    );
  }
}

class _NewsTicker extends StatefulWidget {
  const _NewsTicker({required this.items});

  final List<String> items;

  @override
  State<_NewsTicker> createState() => _NewsTickerState();
}

class _NewsTickerState extends State<_NewsTicker> {
  late final ScrollController _controller;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _timer = Timer.periodic(const Duration(milliseconds: 45), (_) {
      if (!_controller.hasClients) return;
      final next = _controller.offset + 0.6;
      if (next >= _controller.position.maxScrollExtent) {
        _controller.jumpTo(0);
      } else {
        _controller.jumpTo(next);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = [...widget.items, ...widget.items];
    return GestureDetector(
      onTap: () => context.goNamed('profile'),
      child: Container(
        margin: const EdgeInsets.fromLTRB(18, 10, 18, 2),
        height: 34,
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kBorder),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            Container(
              height: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: kGold.withValues(alpha: 0.13),
                border: const Border(right: BorderSide(color: kBorder)),
              ),
              child: const Row(
                children: [
                  _PulseDot(size: 5, color: kGold),
                  SizedBox(width: 5),
                  Text(
                    'NEWS',
                    style: TextStyle(
                      color: kGold,
                      fontSize: 8.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.02,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _controller,
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 13),
                        child: Text(
                          items[index],
                          style: const TextStyle(
                            color: kMutedText,
                            fontSize: 10.5,
                          ),
                        ),
                      ),
                      Container(
                        width: 3.5,
                        height: 3.5,
                        decoration: BoxDecoration(
                          color: kGold.withValues(alpha: 0.7),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GreetingWeather extends StatelessWidget {
  const _GreetingWeather({
    required this.greeting,
    required this.onWeather,
  });

  final String greeting;
  final VoidCallback onWeather;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$greeting,',
                  style: const TextStyle(
                    color: kMutedText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 1),
                const Text(
                  'Peter',
                  style: TextStyle(
                    color: kCream,
                    fontSize: 24,
                    height: 1.2,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Welcome to Redemption City of God',
                  style: TextStyle(
                    color: kDimText,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: onWeather,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
              decoration: BoxDecoration(
                color: kSurface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: kBorder),
              ),
              child: const Row(
                children: [
                  Icon(Icons.wb_sunny_outlined, size: 28, color: kGold),
                  SizedBox(width: 9),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '29°',
                        style: TextStyle(
                          color: kCream,
                          fontSize: 16,
                          height: 1,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Sunny',
                        style: TextStyle(color: kMutedText, fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  const _QuoteCard({required this.quotes});

  final List<Map<String, dynamic>> quotes;

  @override
  Widget build(BuildContext context) {
    final quote = quotes.isEmpty ? <String, dynamic>{} : quotes.first;
    return _SectionPad(
      marginBottom: 22,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              kGold.withValues(alpha: 0.13),
              kDeepInk,
            ],
            stops: const [0, 0.82],
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: kGold.withValues(alpha: 0.22)),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -18,
              right: -6,
              child: Icon(
                Icons.format_quote,
                size: 88,
                color: kGold.withValues(alpha: 0.12),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.auto_awesome, size: 12, color: kGold),
                    SizedBox(width: 6),
                    Text(
                      'Quote of the Day',
                      style: TextStyle(
                        color: kGold,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.62,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  '"${quote['text'] ?? ''}"',
                  style: const TextStyle(
                    color: kCream,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 1.55,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '- ${quote['by'] ?? ''}',
                        style: const TextStyle(
                          color: kGold,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Container(
                          width: 4.5,
                          height: 4.5,
                          margin: const EdgeInsets.only(left: 4),
                          decoration: BoxDecoration(
                            color: index == 0 ? kGold : kDimText,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LiveServiceCard extends StatelessWidget {
  const _LiveServiceCard();

  @override
  Widget build(BuildContext context) {
    return _SectionPad(
      marginBottom: 22,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              kPurpleDark.withValues(alpha: 0.94),
              kPurple.withValues(alpha: 0.36),
              kDeepInk,
            ],
            stops: const [0, 0.55, 1],
          ),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: kPurpleLight.withValues(alpha: 0.3)),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -50,
              right: -30,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: kPurpleLight.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: kDanger.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: kDangerLight.withValues(alpha: 0.28),
                        ),
                      ),
                      child: const Row(
                        children: [
                          _PulseDot(size: 5, color: kDangerLight),
                          SizedBox(width: 5),
                          Text(
                            'LIVE NOW',
                            style: TextStyle(
                              color: kDangerLight,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.08,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        color: kWhite.withValues(alpha: 0.06),
                      ),
                    ),
                    const Text(
                      'Today',
                      style: TextStyle(color: kMutedText, fontSize: 10),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Text(
                  'Sunday Victory Service',
                  style: TextStyle(
                    color: kCream,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                const _MetaLine(
                  icon: Icons.apartment,
                  text: 'Main Auditorium - Redemption City',
                ),
                const SizedBox(height: 5),
                const _MetaLine(
                  icon: Icons.access_time,
                  text: '8:00 AM - 11:30 AM',
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _PrimaryMiniButton(
                        icon: Icons.navigation_outlined,
                        label: 'Get Directions',
                        onTap: () => context.goNamed('map'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _GhostMiniButton(
                        label: 'View Details',
                        onTap: () => context.goNamed('events'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaLine extends StatelessWidget {
  const _MetaLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 11, color: kGold),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(color: kMutedText, fontSize: 11.5),
        ),
      ],
    );
  }
}

class _EmergencyBanner extends StatelessWidget {
  const _EmergencyBanner();

  @override
  Widget build(BuildContext context) {
    return _SectionPad(
      marginBottom: 22,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => context.goNamed('emergency'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: kDanger.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: kDanger.withValues(alpha: 0.32)),
          ),
          child: Row(
            children: [
              const _ColoredIconBox(
                icon: Icons.campaign_outlined,
                color: kDangerLight,
                size: 42,
                radius: 13,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Emergency / SOS',
                      style: TextStyle(
                        color: kDangerLight,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Wrap(
                      spacing: 6,
                      runSpacing: 2,
                      children: const [
                        _EmergencyNumber(num: '199', label: 'Ambulance'),
                        _EmergencyNumber(num: '112', label: 'Police'),
                        _EmergencyNumber(num: '190', label: 'Fire'),
                        _EmergencyNumber(num: '122', label: 'Road'),
                      ],
                    ),
                  ],
                ),
              ),
              const Column(
                children: [
                  _PulseDot(size: 8, color: kDangerLight),
                  SizedBox(height: 6),
                  Icon(Icons.chevron_right, size: 14, color: kDangerLight),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmergencyNumber extends StatelessWidget {
  const _EmergencyNumber({required this.num, required this.label});

  final String num;
  final String label;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: '$num ',
        style: TextStyle(
          color: kDangerLight.withValues(alpha: 0.75),
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(
            text: label,
            style: const TextStyle(
              color: kDimText,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    return _SectionPad(
      marginBottom: 22,
      child: Column(
        children: [
          const _HomeSectionHeader(title: 'Quick Actions', action: null),
          const SizedBox(height: 14),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.43,
            children: const [
              _ActionCard(
                icon: Icons.navigation_outlined,
                label: 'Navigate',
                sub: 'Live city map',
                color: kPurple,
                routeName: 'map',
              ),
              _ActionCard(
                icon: Icons.directions_car_outlined,
                label: 'CityRide',
                sub: 'Book a ride',
                color: kGold,
                routeName: 'cityRide',
              ),
              _ActionCard(
                icon: Icons.apartment,
                label: 'Stay',
                sub: 'Guest houses',
                color: kBlue,
                routeName: 'explore',
              ),
              _ActionCard(
                icon: Icons.calendar_month_outlined,
                label: 'Events',
                sub: "What's on today",
                color: kLeaf,
                routeName: 'events',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.label,
    required this.sub,
    required this.color,
    required this.routeName,
  });

  final IconData icon;
  final String label;
  final String sub;
  final Color color;
  final String routeName;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => context.goNamed(routeName),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: kBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ColoredIconBox(icon: icon, color: color, size: 38, radius: 12),
            const Spacer(),
            Text(
              label,
              style: const TextStyle(
                color: kCream,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              sub,
              style: const TextStyle(color: kMutedText, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class _EventsPreview extends StatelessWidget {
  const _EventsPreview({required this.events});

  final List<Map<String, dynamic>> events;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 22),
      child: Column(
        children: [
          _SectionPad(
            marginBottom: 12,
            child: _HomeSectionHeader(
              title: 'Upcoming Events',
              action: 'See all',
              onAction: () => context.goNamed('events'),
            ),
          ),
          SizedBox(
            height: 86,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final event = events[index];
                final color = _tokenColor(event['color'] as String?);
                return InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => context.goNamed('events'),
                  child: Container(
                    width: 208,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 13,
                    ),
                    decoration: BoxDecoration(
                      color: kSurface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: kBorder),
                    ),
                    child: Row(
                      children: [
                        _EventDateBadge(
                          day: event['day'] as String? ?? '',
                          date: event['date'] as String? ?? '',
                          color: color,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: color.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: color.withValues(alpha: 0.19),
                                      ),
                                    ),
                                    child: Text(
                                      event['tag'] as String? ?? '',
                                      style: TextStyle(
                                        color: color,
                                        fontSize: 8.5,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  if (event['live'] == true) ...[
                                    const SizedBox(width: 6),
                                    const _PulseDot(
                                      size: 5,
                                      color: kDangerLight,
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 5),
                              Text(
                                event['title'] as String? ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: kCream,
                                  fontSize: 13,
                                  height: 1.25,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    size: 9,
                                    color: kGold,
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      '${event['time']} - ${event['venue']}',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: kMutedText,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemCount: events.length,
            ),
          ),
        ],
      ),
    );
  }
}

class _Announcements extends StatelessWidget {
  const _Announcements();

  @override
  Widget build(BuildContext context) {
    return _SectionPad(
      marginBottom: 22,
      child: Column(
        children: [
          const _HomeSectionHeader(title: 'News & Announcements', action: null),
          const SizedBox(height: 14),
          _AnnouncementCard(
            icon: Icons.radio,
            color: kPurple,
            title: 'Monthly Thanksgiving Service',
            body:
                'Join us Saturday at 6PM for a special celebration of praise and worship.',
            time: '2h ago',
          ),
          const SizedBox(height: 10),
          _AnnouncementCard(
            icon: Icons.error_outline,
            color: kDanger,
            title: 'Lost: Black Wallet - Gate B',
            body:
                'A black leather wallet was found at Gate B. Contact security desk to claim.',
            time: '4h ago',
            onTap: () => context.goNamed('lostAndFound'),
            footer: 'View in Lost & Found ->',
          ),
          const SizedBox(height: 10),
          const _AnnouncementCard(
            icon: Icons.navigation_outlined,
            color: kGold,
            title: 'Camp Road Closure',
            body:
                'Main Camp Road closed 10AM-2PM for event. Please use Alternative Route 2.',
            time: '1h ago',
          ),
        ],
      ),
    );
  }
}

class _CityTour extends StatelessWidget {
  const _CityTour();

  @override
  Widget build(BuildContext context) {
    return _SectionPad(
      marginBottom: 22,
      child: Column(
        children: [
          _HomeSectionHeader(
            title: 'Redemption City Tour',
            action: 'Explore',
            onAction: () => context.goNamed('map'),
          ),
          const SizedBox(height: 12),
          InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: () => context.goNamed('map'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    kBlue.withValues(alpha: 0.18),
                    kDeepInk,
                  ],
                  stops: const [0, 0.8],
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: kBlue.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      _ColoredIconBox(
                        icon: Icons.navigation_outlined,
                        color: kBlue,
                        size: 38,
                        radius: 11,
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Guided City Tour',
                            style: TextStyle(
                              color: kCream,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            '8 stops - ~2 hours - Self-paced',
                            style: TextStyle(color: kMutedText, fontSize: 10.5),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: const [
                        _TourChip(
                          icon: Icons.apartment,
                          name: 'Main Auditorium',
                          color: kChurchPurple,
                        ),
                        _TourChip(
                          icon: Icons.eco_outlined,
                          name: 'Prayer Mountain',
                          color: kLeaf,
                        ),
                        _TourChip(
                          icon: Icons.local_cafe_outlined,
                          name: 'Camp Restaurant',
                          color: kGold,
                        ),
                        _TourChip(
                          icon: Icons.menu_book_outlined,
                          name: 'Bookshop',
                          color: kBrown,
                        ),
                        _MoreChip(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FindChurch extends StatelessWidget {
  const _FindChurch({required this.churches});

  final List<Map<String, dynamic>> churches;

  @override
  Widget build(BuildContext context) {
    return _SectionPad(
      marginBottom: 22,
      child: Column(
        children: [
          _HomeSectionHeader(
            title: 'Find a Church',
            action: 'See all',
            onAction: () => context.goNamed('churches'),
          ),
          const SizedBox(height: 12),
          ...churches.map(
            (church) => Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: _ChurchTile(church: church),
            ),
          ),
        ],
      ),
    );
  }
}

class _BusinessDirectory extends StatelessWidget {
  const _BusinessDirectory();

  @override
  Widget build(BuildContext context) {
    return _SectionPad(
      marginBottom: 22,
      child: Column(
        children: [
          _HomeSectionHeader(
            title: 'Business Directory',
            action: 'See all',
            onAction: () => context.goNamed('directory'),
          ),
          const SizedBox(height: 12),
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => context.goNamed('directory'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: kSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: kBorder),
              ),
              child: const Row(
                children: [
                  _ColoredIconBox(
                    icon: Icons.restaurant_outlined,
                    color: kGold,
                    size: 34,
                    radius: 10,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Camp Restaurant',
                          style: TextStyle(
                            color: kCream,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          'Open - 7AM-9PM - Tap to call',
                          style: TextStyle(color: kMutedText, fontSize: 10.5),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.star, size: 9, color: kGold),
                  SizedBox(width: 3),
                  Text(
                    '4.3',
                    style: TextStyle(
                      color: kGold,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AiPreview extends StatelessWidget {
  const _AiPreview();

  @override
  Widget build(BuildContext context) {
    return _SectionPad(
      marginBottom: 22,
      child: Column(
        children: [
          _HomeSectionHeader(
            title: 'CityFlow AI',
            action: 'Open chat',
            onAction: () => context.goNamed('aiGuide'),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: kSurface,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: kBorder),
            ),
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: kBorder)),
                  ),
                  child: const Row(
                    children: [
                      _ColoredIconBox(
                        icon: Icons.smart_toy_outlined,
                        color: kPurpleSoft,
                        size: 30,
                        radius: 9,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CityFlow AI',
                              style: TextStyle(
                                color: kCream,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 2),
                            Row(
                              children: [
                                _PulseDot(size: 5, color: kSuccess),
                                SizedBox(width: 4),
                                Text(
                                  'Online',
                                  style: TextStyle(
                                    color: kSuccess,
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _ColoredIconBox(
                            icon: Icons.smart_toy_outlined,
                            color: kPurpleSoft,
                            size: 24,
                            radius: 7,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 9,
                              ),
                              decoration: BoxDecoration(
                                color: kWhite.withValues(alpha: 0.05),
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(14),
                                  bottomRight: Radius.circular(14),
                                  bottomLeft: Radius.circular(14),
                                  topLeft: Radius.circular(4),
                                ),
                                border: Border.all(color: kBorder),
                              ),
                              child: const Text(
                                "Hi! I'm your CityFlow AI. Ask me anything about Redemption City.",
                                style: TextStyle(
                                  color: kCream,
                                  fontSize: 11.5,
                                  height: 1.55,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: const [
                          _PromptChip(label: 'Find a restaurant'),
                          _PromptChip(label: 'Book a CityRide'),
                          _PromptChip(label: 'Emergency contacts'),
                        ],
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        borderRadius: BorderRadius.circular(13),
                        onTap: () => context.goNamed('aiGuide'),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(12, 9, 9, 9),
                          decoration: BoxDecoration(
                            color: kWhite.withValues(alpha: 0.04),
                            borderRadius: BorderRadius.circular(13),
                            border: Border.all(color: kBorder),
                          ),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Ask me anything about the city...',
                                  style: TextStyle(
                                    color: kDimText,
                                    fontSize: 11.5,
                                  ),
                                ),
                              ),
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [kPurple, kPurpleDark],
                                  ),
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                child: const Icon(
                                  Icons.send_outlined,
                                  color: kWhite,
                                  size: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PictureOfTheDay extends StatelessWidget {
  const _PictureOfTheDay({required this.pic});

  final Map<String, dynamic> pic;

  @override
  Widget build(BuildContext context) {
    return _SectionPad(
      marginBottom: 22,
      child: Column(
        children: [
          _HomeSectionHeader(
            title: 'Picture of the Day',
            action: 'View Gallery',
            onAction: () => context.goNamed('gallery'),
          ),
          const SizedBox(height: 12),
          InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: () => context.goNamed('gallery'),
            child: Container(
              height: 188,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: kBorder),
              ),
              child: Stack(
                children: [
                  const Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [kGold, kPurple],
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            kBackground.withValues(alpha: 0),
                            kBackground.withValues(alpha: 0.85),
                          ],
                          stops: const [0.35, 1],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Icon(
                      Icons.photo_camera_outlined,
                      color: kWhite.withValues(alpha: 0.55),
                      size: 16,
                    ),
                  ),
                  Positioned(
                    left: 14,
                    right: 14,
                    bottom: 13,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: kBackground.withValues(alpha: 0.55),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: kWhite.withValues(alpha: 0.14),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.wb_twilight, size: 10, color: kGold),
                              SizedBox(width: 4),
                              Text(
                                'Prayer Mountain',
                                style: TextStyle(
                                  color: kWhite,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          pic['title'] as String? ?? '',
                          style: const TextStyle(
                            color: kWhite,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'by ${pic['by'] ?? ''}',
                          style: TextStyle(
                            color: kWhite.withValues(alpha: 0.7),
                            fontSize: 10.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DidYouKnow extends StatelessWidget {
  const _DidYouKnow({required this.fact});

  final Map<String, dynamic> fact;

  @override
  Widget build(BuildContext context) {
    return _SectionPad(
      marginBottom: 22,
      child: Column(
        children: [
          _HomeSectionHeader(
            title: 'Did You Know?',
            action: 'See all',
            onAction: () => context.goNamed('profile'),
          ),
          const SizedBox(height: 12),
          InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: () => context.goNamed('profile'),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    kPurple.withValues(alpha: 0.15),
                    kDeepInk,
                  ],
                  stops: const [0, 0.8],
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: kPurple.withValues(alpha: 0.28)),
              ),
              child: Column(
                children: [
                  const Icon(Icons.location_city, color: kGold, size: 36),
                  const SizedBox(height: 10),
                  Text(
                    fact['indexLabel'] as String? ?? '',
                    style: const TextStyle(
                      color: kGold,
                      fontSize: 8.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.7,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    fact['text'] as String? ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: kCream,
                      fontSize: 12.5,
                      height: 1.65,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      8,
                      (index) => Container(
                        width: 5,
                        height: 5,
                        margin: const EdgeInsets.symmetric(horizontal: 2.5),
                        decoration: BoxDecoration(
                          color: index == 0 ? kGold : kDimText,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuizCard extends StatelessWidget {
  const _QuizCard();

  @override
  Widget build(BuildContext context) {
    return _SectionPad(
      marginBottom: 22,
      child: Column(
        children: [
          _HomeSectionHeader(
            title: 'Know Your City Quiz',
            action: 'Play',
            onAction: () => context.goNamed('profile'),
          ),
          const SizedBox(height: 12),
          InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: () => context.goNamed('profile'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    kGold.withValues(alpha: 0.13),
                    kDeepInk,
                  ],
                  stops: const [0, 0.75],
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: kGold.withValues(alpha: 0.25)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const _ColoredIconBox(
                        icon: Icons.emoji_events_outlined,
                        color: kGold,
                        size: 46,
                        radius: 14,
                      ),
                      const SizedBox(width: 13),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Know Your City',
                              style: TextStyle(
                                color: kCream,
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'Test your knowledge of Redemption City - history, places & more.',
                              style: TextStyle(
                                color: kMutedText,
                                fontSize: 11,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [kGold, kGoldDark],
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: kGold.withValues(alpha: 0.3),
                              blurRadius: 18,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          size: 14,
                          color: kBackground,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Row(
                    children: [
                      _QuizInfo(icon: Icons.description_outlined, text: '8 questions'),
                      SizedBox(width: 8),
                      _QuizInfo(icon: Icons.access_time, text: '~3 min'),
                      SizedBox(width: 8),
                      _QuizInfo(icon: Icons.star_outline, text: 'Earn a badge'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OpenHeaven extends StatelessWidget {
  const _OpenHeaven({required this.devotional});

  final Map<String, dynamic> devotional;

  @override
  Widget build(BuildContext context) {
    return _SectionPad(
      marginBottom: 22,
      child: Column(
        children: [
          const _HomeSectionHeader(
            title: 'Open Heaven Devotional',
            action: 'Read Full',
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: kSurface,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: kBorder),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: kBorder)),
                  ),
                  child: Row(
                    children: [
                      const _ColoredIconBox(
                        icon: Icons.menu_book_outlined,
                        color: kPurpleSoft,
                        size: 38,
                        radius: 11,
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${devotional['date']}'s Devotional",
                              style: const TextStyle(
                                color: kGold,
                                fontSize: 8.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.36,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              devotional['topic'] as String? ?? '',
                              style: const TextStyle(
                                color: kCream,
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 13,
                          vertical: 11,
                        ),
                        decoration: BoxDecoration(
                          color: kGold.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(
                            color: kGold.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '"${devotional['verse']}"',
                              style: const TextStyle(
                                color: kCream,
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                height: 1.55,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              devotional['ref'] as String? ?? '',
                              style: const TextStyle(
                                color: kGold,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        devotional['text'] as String? ?? '',
                        style: const TextStyle(
                          color: kMutedText,
                          fontSize: 12,
                          height: 1.65,
                        ),
                      ),
                      const SizedBox(height: 13),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 9,
                              ),
                              decoration: BoxDecoration(
                                color: kSurfaceHigh,
                                borderRadius: BorderRadius.circular(11),
                                border: Border.all(color: kBorder),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.menu_book_outlined,
                                    size: 12,
                                    color: kGold,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Reading: ${devotional['reading']}',
                                    style: const TextStyle(
                                      color: kCream,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: kSurfaceHigh,
                              borderRadius: BorderRadius.circular(11),
                              border: Border.all(color: kBorder),
                            ),
                            child: const Icon(
                              Icons.favorite_border,
                              color: kMutedText,
                              size: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeSectionHeader extends StatelessWidget {
  const _HomeSectionHeader({
    required this.title,
    this.action = 'See all',
    this.onAction,
  });

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: kCream,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (action != null)
          InkWell(
            onTap: onAction,
            borderRadius: BorderRadius.circular(12),
            child: Row(
              children: [
                Text(
                  action!,
                  style: const TextStyle(
                    color: kGold,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Icon(Icons.chevron_right, size: 12, color: kGold),
              ],
            ),
          ),
      ],
    );
  }
}

class _SectionPad extends StatelessWidget {
  const _SectionPad({
    required this.child,
    required this.marginBottom,
  });

  final Widget child;
  final double marginBottom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18, 0, 18, marginBottom),
      child: child,
    );
  }
}

class _ColoredIconBox extends StatelessWidget {
  const _ColoredIconBox({
    required this.icon,
    required this.color,
    required this.size,
    required this.radius,
  });

  final IconData icon;
  final Color color;
  final double size;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Icon(icon, color: color, size: size * 0.48),
    );
  }
}

class _PulseDot extends StatefulWidget {
  const _PulseDot({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.25, end: 1).animate(_controller),
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _PrimaryMiniButton extends StatelessWidget {
  const _PrimaryMiniButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(13),
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: kPurple,
          borderRadius: BorderRadius.circular(13),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: kWhite, size: 12),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: kWhite,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GhostMiniButton extends StatelessWidget {
  const _GhostMiniButton({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(13),
      onTap: onTap,
      child: Container(
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: kWhite.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: kBorder),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: kCream,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _EventDateBadge extends StatelessWidget {
  const _EventDateBadge({
    required this.day,
    required this.date,
    required this.color,
  });

  final String day;
  final String date;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 54,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: TextStyle(
              color: color,
              fontSize: 8.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            date,
            style: const TextStyle(
              color: kCream,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  const _AnnouncementCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
    required this.time,
    this.onTap,
    this.footer,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String body;
  final String time;
  final VoidCallback? onTap;
  final String? footer;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: kBorder),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ColoredIconBox(icon: icon, color: color, size: 34, radius: 10),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: kCream,
                            fontSize: 13,
                            height: 1.3,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        time,
                        style: const TextStyle(
                          color: kDimText,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    body,
                    style: const TextStyle(
                      color: kMutedText,
                      fontSize: 11.5,
                      height: 1.55,
                    ),
                  ),
                  if (footer != null) ...[
                    const SizedBox(height: 5),
                    Text(
                      footer!,
                      style: const TextStyle(
                        color: kGold,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TourChip extends StatelessWidget {
  const _TourChip({
    required this.icon,
    required this.name,
    required this.color,
  });

  final IconData icon;
  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 11),
          const SizedBox(width: 6),
          Text(
            name,
            style: const TextStyle(
              color: kCream,
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _MoreChip extends StatelessWidget {
  const _MoreChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: kSurfaceHigh,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kBorder),
      ),
      child: const Text(
        '+4 more',
        style: TextStyle(color: kMutedText, fontSize: 10.5),
      ),
    );
  }
}

class _ChurchTile extends StatelessWidget {
  const _ChurchTile({required this.church});

  final Map<String, dynamic> church;

  @override
  Widget build(BuildContext context) {
    final color = _tokenColor(church['color'] as String?);
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => context.goNamed('churches'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kBorder),
        ),
        child: Row(
          children: [
            _ColoredIconBox(
              icon: Icons.church_outlined,
              color: color,
              size: 38,
              radius: 11,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    church['name'] as String? ?? '',
                    style: const TextStyle(
                      color: kCream,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${church['service']} - ${church['addr']}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: kMutedText, fontSize: 10.5),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.location_on_outlined, color: kGold, size: 9),
            const SizedBox(width: 3),
            Text(
              church['dist'] as String? ?? '',
              style: const TextStyle(
                color: kGold,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PromptChip extends StatelessWidget {
  const _PromptChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: kSurfaceHigh,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kBorder),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: kCream,
          fontSize: 10.5,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _QuizInfo extends StatelessWidget {
  const _QuizInfo({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: kSurfaceHigh,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: kBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 11, color: kGold),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: kCream,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color _tokenColor(String? name) {
  return switch (name) {
    'gold' => kGold,
    'blue' => kBlue,
    'leaf' => kLeaf,
    'brown' => kBrown,
    'slate' => kSlate,
    'churchPurple' => kChurchPurple,
    _ => kPurple,
  };
}

List<String> _stringList(Object? value) {
  if (value is! List) return const [];
  return value.map((item) => item.toString()).toList();
}

List<Map<String, dynamic>> _mapList(Object? value) {
  if (value is! List) return const [];
  return value
      .whereType<Map>()
      .map((item) => Map<String, dynamic>.from(item))
      .toList();
}

Map<String, dynamic> _mapValue(Object? value) {
  if (value is! Map) return const {};
  return Map<String, dynamic>.from(value);
}
