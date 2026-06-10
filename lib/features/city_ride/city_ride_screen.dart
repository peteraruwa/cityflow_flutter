import 'package:flutter/material.dart';

import '../../core/colors.dart';
import '../../shared/widgets/app_screen.dart';

class CityRideScreen extends StatefulWidget {
  const CityRideScreen({super.key});

  @override
  State<CityRideScreen> createState() => _CityRideScreenState();
}

class _CityRideScreenState extends State<CityRideScreen> {
  String _from = 'My Location';
  String _to = '';
  int _selectedRide = 1; // 0=Camp Shuttle, 1=Standard, 2=Premium
  bool _confirmed = false;

  static const _recentDestinations = [
    'New Arena Auditorium',
    'Youth Centre',
    'Medical Centre',
    'Camp Gate A',
    'Old Auditorium',
  ];

  static const _rideTypes = [
    _RideType(
      name: 'Camp Shuttle',
      icon: Icons.airport_shuttle_outlined,
      fare: '₦150',
      eta: '8 min',
      color: kSuccess,
    ),
    _RideType(
      name: 'Standard',
      icon: Icons.directions_car_outlined,
      fare: '₦450',
      eta: '5 min',
      color: kPurple,
    ),
    _RideType(
      name: 'Premium',
      icon: Icons.local_taxi_outlined,
      fare: '₦850',
      eta: '3 min',
      color: kGold,
    ),
  ];

  void _pickDestination(String dest) {
    setState(() => _to = dest);
  }

  void _bookRide() {
    if (_to.isEmpty) return;
    setState(() => _confirmed = true);
  }

  @override
  Widget build(BuildContext context) {
    if (_confirmed) {
      return _SuccessScreen(
        destination: _to,
        ride: _rideTypes[_selectedRide],
        onBookAnother: () => setState(() {
          _confirmed = false;
          _to = '';
        }),
      );
    }

    return AppScreen(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ScreenHeader(
            title: 'CityRide',
            subtitle: 'Move between camp zones quickly.',
          ),
          const SizedBox(height: 16),
          // Route card
          PremiumCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: kSuccess,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _from,
                        style: const TextStyle(
                          color: kCream,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Icon(Icons.my_location_outlined,
                        color: kSuccess, size: 16),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Divider(color: kBorder, height: 20),
                ),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        color: kDanger, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _showDestinationSheet(context),
                        child: Text(
                          _to.isEmpty ? 'Select destination…' : _to,
                          style: TextStyle(
                            color: _to.isEmpty ? kMutedText : kCream,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    if (_to.isNotEmpty)
                      GestureDetector(
                        onTap: () => setState(() => _to = ''),
                        child: const Icon(Icons.close,
                            color: kMutedText, size: 16),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Recent / Ride type
          if (_to.isEmpty) ...[
            const SectionHeader(title: 'Recent destinations'),
            const SizedBox(height: 10),
            ..._recentDestinations.map(
              (dest) => ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                leading: const Icon(Icons.history, color: kMutedText, size: 18),
                title: Text(
                  dest,
                  style: const TextStyle(color: kCream, fontSize: 14),
                ),
                onTap: () => _pickDestination(dest),
              ),
            ),
          ] else ...[
            const SectionHeader(title: 'Choose ride type'),
            const SizedBox(height: 10),
            ..._rideTypes.asMap().entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _RideCard(
                  ride: entry.value,
                  isSelected: _selectedRide == entry.key,
                  onTap: () => setState(() => _selectedRide = entry.key),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _to.isEmpty ? kDimText : kPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _to.isEmpty ? null : _bookRide,
                child: Text(
                  'Book CityRide · ${_rideTypes[_selectedRide].fare}',
                  style: const TextStyle(
                    color: kCream,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showDestinationSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: kBackground,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => _DestinationSheet(
        onSelect: (dest) {
          Navigator.of(ctx).pop();
          _pickDestination(dest);
        },
      ),
    );
  }
}

class _DestinationSheet extends StatefulWidget {
  const _DestinationSheet({required this.onSelect});
  final void Function(String) onSelect;

  @override
  State<_DestinationSheet> createState() => _DestinationSheetState();
}

class _DestinationSheetState extends State<_DestinationSheet> {
  String _query = '';

  static const _allPlaces = [
    'New Arena Auditorium',
    'Old Auditorium',
    'Youth Centre',
    'Medical Centre',
    'Camp Gate A',
    'Camp Gate B',
    'Camp Store',
    'University (RCCG)',
    'Prayer City',
    'Faith Chapel',
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _allPlaces
        .where((p) => p.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SizedBox(
        height: 480,
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: kBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                autofocus: true,
                onChanged: (v) => setState(() => _query = v),
                style: const TextStyle(color: kCream),
                cursorColor: kPurple,
                decoration: InputDecoration(
                  hintText: 'Search destination…',
                  hintStyle: const TextStyle(color: kMutedText),
                  prefixIcon: const Icon(Icons.search, color: kMutedText),
                  filled: true,
                  fillColor: kSurface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: kBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: kBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: kPurpleLight, width: 1.5),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.location_on_outlined,
                        color: kMutedText, size: 18),
                    title: Text(
                      filtered[index],
                      style: const TextStyle(color: kCream),
                    ),
                    onTap: () => widget.onSelect(filtered[index]),
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

class _RideCard extends StatelessWidget {
  const _RideCard({
    required this.ride,
    required this.isSelected,
    required this.onTap,
  });

  final _RideType ride;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? ride.color.withValues(alpha: 0.14) : kSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? ride.color.withValues(alpha: 0.5) : kBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: ride.color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(ride.icon, color: ride.color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ride.name,
                    style: const TextStyle(
                      color: kCream,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '${ride.eta} away',
                    style: const TextStyle(color: kMutedText, fontSize: 12),
                  ),
                ],
              ),
            ),
            Text(
              ride.fare,
              style: TextStyle(
                color: ride.color,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Icon(Icons.check_circle, color: ride.color, size: 18),
            ],
          ],
        ),
      ),
    );
  }
}

class _RideType {
  const _RideType({
    required this.name,
    required this.icon,
    required this.fare,
    required this.eta,
    required this.color,
  });

  final String name;
  final IconData icon;
  final String fare;
  final String eta;
  final Color color;
}

class _SuccessScreen extends StatelessWidget {
  const _SuccessScreen({
    required this.destination,
    required this.ride,
    required this.onBookAnother,
  });

  final String destination;
  final _RideType ride;
  final VoidCallback onBookAnother;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(26),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: kSuccess.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: kSuccess.withValues(alpha: 0.4), width: 2),
                ),
                child: const Icon(Icons.check, color: kSuccess, size: 40),
              ),
              const SizedBox(height: 22),
              Text(
                'Ride Confirmed!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: kCream,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your driver is on the way.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: kMutedText),
              ),
              const SizedBox(height: 32),
              _StatRow(label: 'Destination', value: destination),
              _StatRow(label: 'Fare', value: ride.fare),
              _StatRow(label: 'ETA', value: ride.eta),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: kCream,
                    side: const BorderSide(color: kBorder),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: onBookAnother,
                  child: const Text('Book Another'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: kMutedText)),
          Text(
            value,
            style: const TextStyle(
              color: kCream,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
