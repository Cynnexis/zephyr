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

  String openDrawer() {
    return Intl.message(
      "Open drawer",
      name: "openDrawer",
      desc: "Name fo the button to open the drawer.",
      locale: localeName,
    );
  }

  String searchButton() {
    return Intl.message(
      "Search button",
      name: "searchButton",
      desc: "Name fo the button to search for signs.",
      locale: localeName,
    );
  }

  String clearTextField() {
    return Intl.message(
      "Clear text field",
      name: "clearTextField",
      desc: "Name fo the button to clear the text field.",
      locale: localeName,
    );
  }

  String addToFavorites() {
    return Intl.message(
      "Add to favorites",
      name: "addToFavorites",
      desc: "Name fo the button to add a sign to the list of favorite signs.",
      locale: localeName,
    );
  }

  String removeFromFavorites() {
    return Intl.message(
      "Remove from favorites",
      name: "removeFromFavorites",
      desc: "Name fo the button to remove a sign from the list of favorite signs.",
      locale: localeName,
    );
  }

  String triggerVideoExplanation() {
    return Intl.message(
      "Click on the video to play it, and click it again to pause it.",
      name: "triggerVideoExplanation",
      desc: "Description of the tooltip for the video showing a sign.",
      locale: localeName,
    );
  }

  String removeSearchHistory() {
    return Intl.message(
      "Remove search history",
      name: "removeSearchHistory",
      desc: "Name of the drawer item and title of the alert dialog box that will ask if the user is sure about "
          "deleting their search history.",
      locale: localeName,
    );
  }

  String removeSearchHistoryConfirmation() {
    return Intl.message(
      "Are you sure you want to remove your search history?",
      name: "removeSearchHistoryConfirmation",
      desc: "Confirmation box about the user removing their search history.",
      locale: localeName,
    );
  }

  String no() {
    return Intl.message(
      "No",
      name: "no",
      desc: "Button saying \"No\".",
      locale: localeName,
    );
  }

  String yes() {
    return Intl.message(
      "Yes",
      name: "yes",
      desc: "Button saying \"Yes\".",
      locale: localeName,
    );
  }

  //region LOADING MESSAGES

  String loadingFingers() {
    return Intl.message(
      "Loading fingers 🖐...",
      name: "loadingFingers",
      desc: "Loading message.",
      locale: localeName,
    );
  }

  String makingItRock() {
    return Intl.message(
      "Making it rock 🤘...",
      name: "makingItRock",
      desc: "Loading message.",
      locale: localeName,
    );
  }

  String huggingContributors() {
    return Intl.message(
      "Hugging contributors 🤗...",
      name: "huggingContributors",
      desc: "Loading message.",
      locale: localeName,
    );
  }

  String connectingToElix() {
    return Intl.message(
      "Connecting to Elix 🤝...",
      name: "connectingToElix",
      desc: "Loading message.",
      locale: localeName,
    );
  }

  String downloadingEmojis() {
    return Intl.message(
      "Downloading emojis for facial expressions 🥳",
      name: "downloadingEmojis",
      desc: "Loading message.",
      locale: localeName,
    );
  }

  String errorOnlyCatsEmojis() {
    return Intl.message(
      "Error: Only cats emojis were found 😺",
      name: "errorOnlyCatsEmojis",
      desc: "Loading message.",
      locale: localeName,
    );
  }

  String catsEmojis() {
    return Intl.message(
      "🙀😸😻🐱",
      name: "catsEmojis",
      desc: "Loading message.",
      locale: localeName,
    );
  }

  String addingMilkAnotherRoom() {
    return Intl.message(
      "Adding milk in another room 🥛...",
      name: "addingMilkAnotherRoom",
      desc: "Loading message.",
      locale: localeName,
    );
  }

  String catGoingToRoom() {
    return Intl.message(
      "🥛🐈🚪",
      name: "catGoingToRoom",
      desc: "Loading message.",
      locale: localeName,
    );
  }

  String problemSolvedHumanEmojisRetrieved() {
    return Intl.message(
      "Problem solved: Human-emojis retrieved 🤓",
      name: "problemSolvedHumanEmojisRetrieved",
      desc: "Loading message.",
      locale: localeName,
    );
  }

  List<String> emojisConversation() => <String>[
        downloadingEmojis(),
        errorOnlyCatsEmojis(),
        catsEmojis(),
        addingMilkAnotherRoom(),
        catGoingToRoom(),
        problemSolvedHumanEmojisRetrieved(),
      ];

  String downloadingSignPuns() {
    return Intl.message(
      "Downloading sign-puns 🙌...",
      name: "downloadingSignPuns",
      desc: "Loading message.",
      locale: localeName,
    );
  }

  String lameSignPunsDetected() {
    return Intl.message(
      "Lame puns detected... Removing them 👎...",
      name: "lameSignPunsDetected",
      desc: "Loading message.",
      locale: localeName,
    );
  }

  List<String> signPunsConversation() => <String>[downloadingSignPuns(), lameSignPunsDetected()];

  String balancingRightHandedLeftHanded() {
    return Intl.message(
      "Balancing right-handed and left-handed contributors 👐...",
      name: "balancingRightHandedLeftHanded",
      desc: "Loading message.",
      locale: localeName,
    );
  }

  String makingShadowPuppets() {
    return Intl.message(
      "Making shadow puppets... Just for fun 🤏",
      name: "makingShadowPuppets",
      desc: "Loading message.",
      locale: localeName,
    );
  }

  String settingAccessibilityF() {
    return Intl.message(
      "Setting accessibility 🧏‍♀️...",
      name: "settingAccessibilityF",
      desc: "Loading message.",
      locale: localeName,
    );
  }

  String settingAccessibilityM() {
    return Intl.message(
      "Setting accessibility 🧏‍♂️...",
      name: "settingAccessibilityM",
      desc: "Loading message.",
      locale: localeName,
    );
  }

  String cuttingNails() {
    return Intl.message(
      "Cutting nails 💅...",
      name: "cuttingNails",
      desc: "Loading message.",
      locale: localeName,
    );
  }

  List<List<String>> allLoadingMessages() {
    return <List<String>>[
      <String>[loadingFingers()],
      <String>[makingItRock()],
      <String>[huggingContributors()],
      <String>[connectingToElix()],
      emojisConversation(),
      signPunsConversation(),
      <String>[balancingRightHandedLeftHanded()],
      <String>[makingShadowPuppets()],
      <String>[settingAccessibilityF()],
      <String>[settingAccessibilityM()],
      <String>[cuttingNails()],
    ];
  }

  //endregion

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
