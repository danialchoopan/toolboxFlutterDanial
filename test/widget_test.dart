import 'package:flutter_test/flutter_test.dart';

import 'package:danialflutter_toolbox/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ToolboxApp());
    await tester.pump();
  });
}
