import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/main.dart';

void main() {
  testWidgets('Movie catalog displays movie list', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MovieCatalog()));

    expect(find.text('Movie Catalog'), findsOneWidget);
    expect(find.text('Swallowed Star'), findsOneWidget);
    expect(find.text('Renegade Immortal'), findsOneWidget);
  });
}
