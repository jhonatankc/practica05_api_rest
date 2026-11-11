
import 'package:flutter_test/flutter_test.dart';

import 'package:practica05_api_rest/main.dart';

void main() {
  testWidgets(
    'La pantalla principal muestra el título',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MiAplicacion());

      expect(find.text('Publicaciones'), findsOneWidget);
    },
  );
}
