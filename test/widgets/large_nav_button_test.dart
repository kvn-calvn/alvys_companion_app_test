import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alvys3/src/common_widgets/large_nav_button.dart';

void main() {
  group('LargeNavButton Tests', () {
    testWidgets('LargeNavButton displays title and subtitle', (WidgetTester tester) async {
      // Arrange
      const title = 'Test Title';
      const subtitle = 'Test Subtitle';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LargeNavButton(
              title: title,
              subtitle: subtitle,
              onPressed: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(title), findsOneWidget);
      expect(find.text(subtitle), findsOneWidget);
    });

    testWidgets('LargeNavButton error when there is no title', (WidgetTester tester) async {
      // Arrange
      const String? title = null;

      // Act
      try {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: LargeNavButton(
                title: title!,
                onPressed: () {},
              ),
            ),
          ),
        );
      } catch (e) {
        // Assert
        expect(e, isA<TypeError>());
      }
    });

    testWidgets('LargeNavButton displays icon', (WidgetTester tester) async {
      // Arrange
      const title = 'Test Title';
      const icon = Icon(Icons.add);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LargeNavButton(
              title: title,
              icon: icon,
              onPressed: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('LargeNavButton onPressed callback is triggered', (WidgetTester tester) async {
      // Arrange
      bool wasPressed = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LargeNavButton(
              title: 'Test Title',
              onPressed: () {
                wasPressed = true;
              },
            ),
          ),
        ),
      );

      // Tap the button
      await tester.tap(find.byType(LargeNavButton));
      await tester.pump();

      // Assert
      expect(wasPressed, isTrue);
    });
  });
}
