import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mhj_maps/mhj_maps.dart';

import '../../core/colors.dart';
import '../../core/locations.dart';
import '../../shared/models/place.dart';
import '../../shared/widgets/error_view.dart';
import '../../shared/widgets/loading_view.dart';
import 'map_controller.dart';
import 'place_details_screen.dart';
import 'widgets/map_search_bar.dart';
import 'widgets/place_marker.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  MhjMapsMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapControllerProvider);

    ref.listen<AsyncValue<CityMapState>>(mapControllerProvider, (_, next) {
      next.whenData((state) => _syncMarkers(state.filteredPlaces));
    });

    return Scaffold(
      body: mapState.when(
        loading: () => const ColoredBox(
          color: kBackground,
          child: LoadingView(),
        ),
        error: (error, _) => ColoredBox(
          color: kBackground,
          child: ErrorView(
            message: error.toString(),
            onRetry: () => ref.invalidate(mapControllerProvider),
          ),
        ),
        data: (state) => Stack(
          children: [
            MhjMapsMap(
              center: const MhjMapsLatLng(
                lat: kRedemptionCityLat,
                lng: kRedemptionCityLon,
              ),
              zoom: 15,
              theme: MhjMapsMapThemes.darkElegant,
              showAttribution: false,
              onMapCreated: (controller) {
                _mapController = controller;
                _syncMarkers(state.filteredPlaces);
              },
            ),
            Positioned(
              left: 16,
              right: 16,
              top: MediaQuery.paddingOf(context).top + 14,
              child: MapSearchBar(
                initialValue: state.searchText,
                onChanged:
                    ref.read(mapControllerProvider.notifier).setSearchText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _syncMarkers(List<Place> places) {
    final controller = _mapController;
    if (controller == null) return;

    controller.clearMarkers();
    for (final place in places) {
      controller.addCustomMarker(
        position: MhjMapsLatLng(lat: place.lat, lng: place.lng),
        width: 44,
        height: 44,
        child: PlaceMarker(
          onTap: () {
            ref.read(mapControllerProvider.notifier).selectPlace(place);
            _showPlaceDetails(place);
          },
        ),
      );
    }
  }

  void _showPlaceDetails(Place place) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: kBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      builder: (_) => PlaceDetailsScreen(place: place),
    ).whenComplete(() {
      ref.read(mapControllerProvider.notifier).clearSelectedPlace();
    });
  }
}
