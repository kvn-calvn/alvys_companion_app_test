import 'package:flutter_test/flutter_test.dart';

import 'widgets/large_nav_button_test.dart' as large_nav_button_tests;
import 'widgets/user_details_test.dart' as user_details_tests;

void main() {
  group('Widget Tests', () {
    large_nav_button_tests.main();
    user_details_tests.main();
  });
}
