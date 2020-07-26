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
        "addToFavorites": MessageLookupByLibrary.simpleMessage("Add to favorites"),
        "appName": MessageLookupByLibrary.simpleMessage("Zéphyr"),
        "clearTextField": MessageLookupByLibrary.simpleMessage("Clear text field"),
        "favorite": MessageLookupByLibrary.simpleMessage("Favorite"),
        "loading": m0,
        "no": MessageLookupByLibrary.simpleMessage("No"),
        "noSigns": MessageLookupByLibrary.simpleMessage("No signs"),
        "openDrawer": MessageLookupByLibrary.simpleMessage("Open drawer"),
        "removeFromFavorites": MessageLookupByLibrary.simpleMessage("Remove from favorites"),
        "removeSearchHistory": MessageLookupByLibrary.simpleMessage("Remove search history"),
        "removeSearchHistoryConfirmation":
            MessageLookupByLibrary.simpleMessage("Are you sure you want to remove your search history?"),
        "resultsFor": m1,
        "searchButton": MessageLookupByLibrary.simpleMessage("Search button"),
        "searchSign": MessageLookupByLibrary.simpleMessage("Search a sign"),
        "searchSigns": MessageLookupByLibrary.simpleMessage("Search Signs"),
        "triggerVideoExplanation":
            MessageLookupByLibrary.simpleMessage("Click on the video to play it, and click it again to pause it."),
        "yes": MessageLookupByLibrary.simpleMessage("Yes")
      };
}
