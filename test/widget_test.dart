// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bailgada/main.dart';
import 'package:bailgada/services/translation_service.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Initialize translation service for testing
    final translationService = TranslationService();
    await translationService.initialize();
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(translationService: translationService));

    // Verify that the app builds successfully
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
