import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group("Search Signs", () {
    final ByValueKey searchFinder = find.byValueKey("search_signs");
    final ByValueKey searchButtonFinder = find.byValueKey("search_button");
    final ByValueKey loadingBar = find.byValueKey("loading_signs_results");

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async => driver = await FlutterDriver.connect());

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test("Search \"test\"", () async {
      await driver.tap(searchFinder);
      await driver.enterText("test");
      await driver.waitFor(find.text("test"));
      expect(await driver.getText(searchFinder), "test");

      await driver.tap(searchButtonFinder);
      expect(find.byType("CircularProgressIndicator"), isNotNull);
      await driver.waitForAbsent(loadingBar);

      final ByValueKey signResult0 = find.byValueKey("sign_result_0");
      final ByValueKey signResult1 = find.byValueKey("sign_result_1");
      final ByValueKey signResult2 = find.byValueKey("sign_result_2");

      expect(signResult0, isNotNull);
      expect(signResult1, isNotNull);
      expect(signResult2, isNotNull);
      expect(find.text("test (n.m.)"), isNotNull);
      expect(
          find.text(
              "1. procédé qui permet d'évaluer les aptitudes ou les possibilités d'un individu, d'un corps, d'une substance, d'un système."),
          isNotNull);
      expect(find.text("2. épreuve qui sert de base à un jugement."), isNotNull);
      expect(find.text("3. petit récipient en terre réfractaire utilisé pour les calcinations en laboratoire."),
          isNotNull);
    });

    // TODO: Test favorite
  });
}
