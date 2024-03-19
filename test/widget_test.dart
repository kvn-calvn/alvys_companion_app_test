// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

//import 'package:alvys3/src/utils/dummy_data.dart';
//import 'package:alvys3/main_common.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:alvys3/qa.dart' as app;

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.\
    app.main();

    await tester.pumpAndSettle();

    // Verify that our counter has incremented.
    expect(find.text('Welcome Drivers!'), findsNothing);
    //expect(find.text('1'), findsOneWidget);
  });

  // test('shouldFormatDate', () {
  //   var data = Uri.parse("mailto:support@alvys.com?subject=Login%20Help");
  //   var data2 = Uri.parse("https://alvys.com/try-for-free-landing-page/");
  //   var k = data;
  // });
}
