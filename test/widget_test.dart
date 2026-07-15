import 'package:flutter_test/flutter_test.dart';

import 'package:toolbox_persian/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ToolboxApp());
    await tester.pump();
    // Basic smoke test - app should build without errors
  });
}
