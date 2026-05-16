import 'package:flutter_test/flutter_test.dart';
import 'package:japan_learn/main.dart';

void main() {
  testWidgets('App renders home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const JapanLearnApp());
    expect(find.text('Japan Learn'), findsOneWidget);
    expect(find.text('Welcome to Japan Learn!'), findsOneWidget);
  });
}
