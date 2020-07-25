import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

Timeout timeout = Timeout(Duration(minutes: 1));
Duration sleepingTime = Duration(seconds: 1);

ByValueKey drawerButton = find.byValueKey("drawer_button");
ByValueKey searchFinder = find.byValueKey("search_signs");
ByValueKey searchButtonFinder = find.byValueKey("search_button");
ByValueKey clearButtonFinder = find.byValueKey("clear_search_button");
ByValueKey loadingBar = find.byValueKey("loading_signs_results");

FlutterDriver driver;

void main() {
  group("Search Signs", () {
    setUpAll(setUpAllForGroup);
    tearDownAll(tearDownAllForGroup);

    test("Search \"test\"", () async {
      await searchSigns("test");

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
    }, timeout: timeout);
  }, timeout: timeout);

  group("Favorites", () {
    setUpAll(setUpAllForGroup);
    tearDownAll(tearDownAllForGroup);

    test("Add \"bleu\" to Favorite & remove it", () async {
      // Go to the favorite page
      await goToDrawer(1);

      // Check that its empty
      expect(find.byValueKey("favorite_no_signs"), isNotNull);

      // Go back to the main activity and search "bleu"
      await goToDrawer(0);
      await searchSigns("bleu");
      // Expand the first result and add it to the favorites
      await triggerFavoriteSign(2);

      // Go to the favorite page
      await goToDrawer(1);
      expect(find.text("bleu"), isNotNull);
      sleep(sleepingTime);

      // Remove the favorite
      await triggerFavoriteSign(0);
      expect(find.byValueKey("favorite_no_signs"), isNotNull);

      // Go back to the main page and search for "rouge"
      await goToDrawer(0);
      await searchSigns("rouge");
      await triggerFavoriteSign(5);

      // Search for "vert"
      await searchSigns("vert");
      await triggerFavoriteSign(2);

      // Go to the Favorites page and check that "rouge" and "vert" are there
      await goToDrawer(1);
      expect(find.text("rouge"), isNotNull);
      expect(find.text("vert"), isNotNull);
      sleep(sleepingTime);

      // Search among the favorites
      await searchSigns("vert");
      expect(find.text("vert"), isNotNull);
      sleep(sleepingTime);

      // Go back to the main activity, and remove "rouge" and "vert" from there
      await goToDrawer(0);
      await searchSigns("rouge");
      await triggerFavoriteSign(5);

      await searchSigns("vert");
      await triggerFavoriteSign(2);

      // Go to the favorite page, and check that it's empty
      await goToDrawer(1);
      expect(find.byValueKey("favorite_no_signs"), isNotNull);
    }, timeout: timeout);
  }, timeout: timeout);
}

/// Connect to the Flutter driver before running any tests.
void setUpAllForGroup() async {
  driver = await FlutterDriver.connect();
}

/// Close the connection to the driver after the tests have completed.
void tearDownAllForGroup() {
  if (driver != null) {
    driver.close();
  }
}

/// Enter a text in the search bar. Wait for the text to be in the field.
void enterTextInSearchBar(String text) async {
  // Clear the field if needed
  String searchFieldText = await driver.getText(searchFinder);
  if (searchFieldText.length > 0) {
    await driver.tap(clearButtonFinder);
    sleep(sleepingTime);
  }

  await driver.tap(searchFinder);
  await driver.enterText(text);
  await driver.waitFor(find.text(text));
  expect(await driver.getText(searchFinder), text);
}

/// Search signs using the search bar by entering the given [keywords] and then clicking on the search button. The
/// function will wait for the result to be fully loaded.
void searchSigns(String keywords) async {
  await enterTextInSearchBar(keywords);

  await driver.tap(searchButtonFinder);
  expect(find.byType("CircularProgressIndicator"), isNotNull);
  await driver.waitForAbsent(loadingBar);
}

/// Open the drawer and go to the activity number [itemIndex] (0-indexed).
void goToDrawer(int itemIndex) async {
  await driver.tap(drawerButton);
  await driver.tap(find.byValueKey("drawer_item_$itemIndex"));
  await driver.waitForAbsent(loadingBar);
  sleep(sleepingTime);
}

/// Add/remove a sign from favorites from the search page or favorite page.
void triggerFavoriteSign(int indexInList) async {
  await driver.scrollUntilVisible(find.byValueKey("signs_list"), find.byValueKey("sign_result_$indexInList"),
      dyScroll: -50.0);
  await driver.tap(find.byValueKey("sign_result_$indexInList"));
  final ByValueKey favoriteButton = find.byValueKey("sign_result_favorite_$indexInList");
  expect(favoriteButton, isNotNull);
  await driver.tap(favoriteButton);
  sleep(sleepingTime);
}
