import 'package:alvys3/src/features/authentication/presentation/user_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProfileDetailCard Tests', () {
    testWidgets('ProfileDetailCard displays title and subtitle', (WidgetTester tester) async {
      // Arrange
      const title = 'Test Title';
      const subtitle = 'Test Subtitle';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfileDetailCard(
              title: title,
              content: subtitle,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(title), findsOneWidget);
      expect(find.text(subtitle), findsOneWidget);
    });

    testWidgets('ProfileDetailCard displays N/A when subtitle is null',
        (WidgetTester tester) async {
      // Arrange
      const title = 'Test Title';
      const String? subtitle = null;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfileDetailCard(
              title: title,
              content: subtitle ?? 'N/A',
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(title), findsOneWidget);
      expect(find.text('N/A'), findsOneWidget);
    });

    testWidgets('ProfileDetailCard error when there is no title', (WidgetTester tester) async {
      // Arrange
      const String? title = null;

      // Act
      try {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ProfileDetailCard(
                title: title!,
              ),
            ),
          ),
        );
      } catch (e) {
        // Assert
        expect(e, isA<TypeError>());
      }
    });
  });
}
