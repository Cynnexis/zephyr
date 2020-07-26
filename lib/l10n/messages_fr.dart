// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fr locale. All the
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
  String get localeName => 'fr';

  static m0(suffix) => "Chargement${suffix}";

  static m1(numResults, keywords) =>
      "${Intl.plural(numResults, zero: 'Aucun résultats pour \"${keywords}\"', one: 'Résultat pour \"${keywords}\"', other: 'Résultats pour \"${keywords}\"')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "addToFavorites": MessageLookupByLibrary.simpleMessage("Ajouter aux favoris"),
        "appName": MessageLookupByLibrary.simpleMessage("Zéphyr"),
        "clearTextField": MessageLookupByLibrary.simpleMessage("Effacer le texte"),
        "favorite": MessageLookupByLibrary.simpleMessage("Favoris"),
        "loading": m0,
        "no": MessageLookupByLibrary.simpleMessage("Non"),
        "noSigns": MessageLookupByLibrary.simpleMessage("Aucun signes"),
        "openDrawer": MessageLookupByLibrary.simpleMessage("Ouvrir la navigation"),
        "removeFromFavorites": MessageLookupByLibrary.simpleMessage("Supprimer des favoris"),
        "removeSearchHistory": MessageLookupByLibrary.simpleMessage("Supprimer l\'historique de recherche"),
        "removeSearchHistoryConfirmation":
            MessageLookupByLibrary.simpleMessage("Êtes-vous sûr de vouloir supprimer votre historique de recherche ?"),
        "resultsFor": m1,
        "searchButton": MessageLookupByLibrary.simpleMessage("Bouton de recherche"),
        "searchSign": MessageLookupByLibrary.simpleMessage("Rechercher un signe"),
        "searchSigns": MessageLookupByLibrary.simpleMessage("Rechercher des Signes"),
        "triggerVideoExplanation": MessageLookupByLibrary.simpleMessage(
            "Cliquez sur la video pour la jouer, et cliquez à nouveau pour la mettre en pause."),
        "yes": MessageLookupByLibrary.simpleMessage("Oui")
      };
}
