import 'package:cityflow_flutter/features/gallery/gallery_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('daily image index stays in range', () {
    expect(
      dailyImageIndex(6, DateTime(2026, 6, 10)),
      inInclusiveRange(0, 5),
    );
  });
}
