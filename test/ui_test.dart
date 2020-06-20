import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zephyr/main.dart';

void main() {
  Duration d100ms = Duration(milliseconds: 100);
  Duration d500ms = Duration(milliseconds: 500);

  testWidgets("Search Bar", (WidgetTester tester) async {
    await tester.pumpWidget(ZephyrApp(), d500ms);
    await tester.pumpAndSettle(d500ms);

    // Search for the main widgets
    Finder searchFinder = find.byKey(Key("search_signs"));
    expect(searchFinder, findsOneWidget);

    Finder clearButtonFinder = find.byKey(Key("clear_search_button"));
    expect(clearButtonFinder, findsNothing);

    Finder resultsFinder = find.byKey(Key("results_list"));
    expect(resultsFinder, findsNothing);

    // Tap the word "test" in the search bar
    await tester.pumpAndSettle(d500ms);
    await tester.tap(searchFinder);
    await tester.enterText(searchFinder, "test");
    await tester.pumpAndSettle(d100ms);
    expect((tester.widget(searchFinder) as TextField).controller.text, "test");

    // Check the keyboard, and close it
    expect(tester.testTextInput.isVisible, true);
    await tester.testTextInput.hide();
    await tester.pumpAndSettle(d100ms);
    expect(tester.testTextInput.isVisible, false);

    // Send the query
    await tester.tap(searchFinder);
    expect(tester.testTextInput.isVisible, true);
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle(d100ms);

    // Clear the field
    expect((tester.widget(searchFinder) as TextField).controller.text, "test");
    clearButtonFinder = find.byKey(Key("clear_search_button"));
    expect(clearButtonFinder, findsOneWidget);
    await tester.tap(clearButtonFinder);
    expect((tester.widget(searchFinder) as TextField).controller.text, "");

    // Tap the word "minute" in the search bar
    await tester.pumpAndSettle(d500ms);
    await tester.tap(searchFinder);
    await tester.enterText(searchFinder, "minute");
    await tester.pumpAndSettle(d100ms);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle(d500ms);
  });
}
