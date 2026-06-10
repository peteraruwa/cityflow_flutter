import 'package:flutter_riverpod/flutter_riverpod.dart';

final rideServiceProvider = Provider<RideService>((ref) {
  return const RideService();
});

class RideOption {
  const RideOption({
    required this.type,
    required this.waitTime,
    required this.fareEstimate,
  });

  final String type;
  final String waitTime;
  final String fareEstimate;
}

class RideService {
  const RideService();

  List<RideOption> getRideOptions() {
    return const [
      RideOption(
        type: 'Keke Napep',
        waitTime: '5–10 min',
        fareEstimate: '₦100–₦200',
      ),
      RideOption(
        type: 'Bus',
        waitTime: '5–10 min',
        fareEstimate: '₦100–₦200',
      ),
      RideOption(
        type: 'Shuttle',
        waitTime: '5–10 min',
        fareEstimate: '₦100–₦200',
      ),
    ];
  }
}
