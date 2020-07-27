// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static m0(suffix) => "Loading${suffix}";

  static m1(numResults, keywords) =>
      "${Intl.plural(numResults, zero: 'No results for \"${keywords}\"', one: 'Result for \"${keywords}\"', other: 'Results for \"${keywords}\"')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "settingAccessibilityM": MessageLookupByLibrary.simpleMessage("Setting accessibility 🧏‍♂️..."),
        "addToFavorites": MessageLookupByLibrary.simpleMessage("Add to favorites"),
        "addingMilkAnotherRoom": MessageLookupByLibrary.simpleMessage("Adding milk in another room 🥛..."),
        "appName": MessageLookupByLibrary.simpleMessage("Zéphyr"),
        "balancingRightHandedLeftHanded":
            MessageLookupByLibrary.simpleMessage("Balancing right-handed and left-handed contributors 👐..."),
        "catGoingToRoom": MessageLookupByLibrary.simpleMessage("🥛🐈🚪"),
        "catsEmojis": MessageLookupByLibrary.simpleMessage("🙀😸😻🐱"),
        "clearTextField": MessageLookupByLibrary.simpleMessage("Clear text field"),
        "connectingToElix": MessageLookupByLibrary.simpleMessage("Connecting to Elix 🤝..."),
        "cuttingNails": MessageLookupByLibrary.simpleMessage("Cutting nails 💅..."),
        "downloadingEmojis": MessageLookupByLibrary.simpleMessage("Downloading emojis for facial expressions 🥳"),
        "downloadingSignPuns": MessageLookupByLibrary.simpleMessage("Downloading sign-puns 🙌..."),
        "errorOnlyCatsEmojis": MessageLookupByLibrary.simpleMessage("Error: Only cats emojis were found 😺"),
        "favorite": MessageLookupByLibrary.simpleMessage("Favorite"),
        "huggingContributors": MessageLookupByLibrary.simpleMessage("Hugging contributors 🤗..."),
        "lameSignPunsDetected": MessageLookupByLibrary.simpleMessage("Lame puns detected... Removing them 👎..."),
        "loading": m0,
        "loadingFingers": MessageLookupByLibrary.simpleMessage("Loading fingers 🖐..."),
        "makingItRock": MessageLookupByLibrary.simpleMessage("Making it rock 🤘..."),
        "makingShadowPuppets": MessageLookupByLibrary.simpleMessage("Making shadow puppets... Just for fun 🤏"),
        "no": MessageLookupByLibrary.simpleMessage("No"),
        "noSigns": MessageLookupByLibrary.simpleMessage("No signs"),
        "openDrawer": MessageLookupByLibrary.simpleMessage("Open drawer"),
        "problemSolvedHumanEmojisRetrieved":
            MessageLookupByLibrary.simpleMessage("Problem solved: Human-emojis retrieved 🤓"),
        "removeFromFavorites": MessageLookupByLibrary.simpleMessage("Remove from favorites"),
        "removeSearchHistory": MessageLookupByLibrary.simpleMessage("Remove search history"),
        "removeSearchHistoryConfirmation":
            MessageLookupByLibrary.simpleMessage("Are you sure you want to remove your search history?"),
        "resultsFor": m1,
        "searchButton": MessageLookupByLibrary.simpleMessage("Search button"),
        "searchSign": MessageLookupByLibrary.simpleMessage("Search a sign"),
        "searchSigns": MessageLookupByLibrary.simpleMessage("Search Signs"),
        "settingAccessibilityF": MessageLookupByLibrary.simpleMessage("Setting accessibility 🧏‍♀️..."),
        "triggerVideoExplanation":
            MessageLookupByLibrary.simpleMessage("Click on the video to play it, and click it again to pause it."),
        "yes": MessageLookupByLibrary.simpleMessage("Yes")
      };
}
