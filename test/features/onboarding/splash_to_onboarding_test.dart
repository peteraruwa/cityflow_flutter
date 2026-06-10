import 'package:cityflow_flutter/core/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('splash routes to visible onboarding content', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(routerConfig: appRouter),
      ),
    );

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('Welcome to CityFlow'), findsOneWidget);
    expect(find.text('Choose your language'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });
}
