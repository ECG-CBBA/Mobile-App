import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/main.dart';
import 'package:mobile/injection_container.dart';

void main() {
  setUpAll(() {
    setupDependencies();
  });

  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ECGApp());
    await tester.pumpAndSettle();

    expect(find.text('ECG Monitor'), findsOneWidget);
    expect(find.text('Nueva Detección'), findsOneWidget);
    expect(find.text('Historial'), findsOneWidget);
  });
}