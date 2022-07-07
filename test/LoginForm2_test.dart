import 'package:account_ledger_flutter/LoginForm2.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Run LoginForm2', (WidgetTester widgetTester) async {
    await widgetTester.pumpWidget(LoginForm2());
  });
}