import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final galleryControllerProvider =
    AsyncNotifierProvider<GalleryController, GalleryState>(
  GalleryController.new,
);

class GalleryState {
  const GalleryState({
    required this.images,
    required this.featuredIndex,
  });

  final List<String> images;
  final int featuredIndex;

  String get featuredImage => images[featuredIndex];
}

class GalleryController extends AsyncNotifier<GalleryState> {
  @override
  Future<GalleryState> build() async {
    final imagesJson =
        await rootBundle.loadString('assets/data/gallery_images.json');
    final images = (json.decode(imagesJson) as List<dynamic>)
        .map((item) => item as String)
        .toList();
    if (images.isEmpty) {
      return const GalleryState(images: [], featuredIndex: 0);
    }

    final featuredIndex = dailyImageIndex(images.length, DateTime.now());

    return GalleryState(
      images: images,
      featuredIndex: featuredIndex,
    );
  }
}

int dailyImageIndex(int imageCount, DateTime date) {
  if (imageCount <= 0) return 0;

  final dayOfYear = int.parse(DateFormat('D').format(date));
  return dayOfYear % imageCount;
}
