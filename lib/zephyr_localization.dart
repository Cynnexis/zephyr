import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zephyr/l10n/messages_all.dart';

List<Locale> supportedLocales = [
  const Locale("en", ''),
  const Locale("fr", ''),
  const Locale("es", ''),
];

class ZephyrLocalization {
  final String localeName;

  ZephyrLocalization(this.localeName);

  static ZephyrLocalization of(BuildContext context) {
    return Localizations.of<ZephyrLocalization>(context, ZephyrLocalization);
  }

  static Future<ZephyrLocalization> load(Locale locale) async {
    final String name = locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      return ZephyrLocalization(localeName);
    });
  }

  //#region STRINGS

  String appName() {
    return Intl.message(
      "Zéphyr",
      name: "appName",
      desc: "The application name.",
      locale: localeName,
    );
  }

  String searchSign() {
    return Intl.message(
      "Search a sign",
      name: "searchSign",
      desc: "Indicates what the user must put in the search field.",
      locale: localeName,
    );
  }

  String loading([String suffix = "..."]) {
    return Intl.message(
      "Loading$suffix",
      name: "loading",
      args: [suffix],
      desc: "Loading text.",
      examples: const {"suffix": " program..."},
      locale: localeName,
    );
  }

  String resultsFor(int numResults, String keywords) {
    return Intl.plural(
      numResults,
      zero: "No results for \"$keywords\"",
      one: "Result for \"$keywords\"",
      other: "Results for \"$keywords\"",
      name: "resultsFor",
      args: [numResults, keywords],
      desc: "Title for the results page.",
      examples: const {"numResults": 8, "keywords": "minute"},
      locale: localeName,
    );
  }

  String noSigns() {
    return Intl.message(
      "No signs",
      name: "noSigns",
      desc: "When no signs was given in the list of signs to show.",
      locale: localeName,
    );
  }

  String searchSigns() {
    return Intl.message(
      "Search Signs",
      name: "searchSigns",
      desc: "Name fo the first page, where the user can search for signs.",
      locale: localeName,
    );
  }

  String favorite() {
    return Intl.message(
      "Favorite",
      name: "favorite",
      desc: "Name fo the second page, where the user can see their favorite signs.",
      locale: localeName,
    );
  }

  //#endregion
}

class ZephyrLocalizationDelegate extends LocalizationsDelegate<ZephyrLocalization> {
  const ZephyrLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => [for (Locale l in supportedLocales) l.languageCode].contains(locale.languageCode);

  @override
  Future<ZephyrLocalization> load(Locale locale) => ZephyrLocalization.load(locale);

  @override
  bool shouldReload(ZephyrLocalizationDelegate old) => false;
}

/// Extension of [String] that add unitary string operations.
extension StringExtension on String {
  /// Return the capitalize version of the string.
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }

  /// Remove the accents from the string.
  String removeAccents() {
    return removeDiacritics(this);
  }
}
