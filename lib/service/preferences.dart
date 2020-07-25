import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:zephyr/model/favorites.dart';
import 'package:zephyr/model/sign.dart';

/// Get the path to the file containing all the favorite signs.
Future<String> _getFavoriteFilePath() async {
  final Directory dir = await getApplicationDocumentsDirectory();
  return "${dir.path}/favorites.json";
}

/// Get the file containing all the favorite signs.
Future<File> _getFavoriteFile() async {
  final String filepath = await _getFavoriteFilePath();
  return File(filepath);
}

/// Save the favorite [signs] to an external file.
///
/// [signs] will be saved to an external file. If [append] is `true`, the file won't be overwritten, but the content
/// will simply be appended. If there are incomplete signs in [signs] (such as no `word` field), they won't be saved.
/// Note that duplicated elements are not permitted.
Future<File> saveFavorites(dynamic signs, {bool append = false}) async {
  if (!(signs is Set<Sign>)) {
    if (signs is Iterable<Sign>)
      signs = Set<Sign>.of(signs);
    else if (signs is Favorites)
      signs = signs.toSet();
    else
      throw ArgumentError.value(signs, "signs");
  }

  Set<Sign> allSigns = Set();

  // If in "append" mode, add the favorites already in the file
  if (append) {
    final Favorites loadedSigns = await loadFavorites();
    allSigns.addAll(loadedSigns.values);
  }

  // Add the given signs (after adding the loaded values if `append` is true)
  allSigns.addAll(signs);

  // Filter `jsonSigns` to remove empty signs (without `word` field).
  allSigns = allSigns.where((sign) => sign.word != null && sign.word != '').toSet();

  // Create a list that contains all the JSON values of the signs in `allSigns`
  final List<String> jsonSigns = List.of([for (Sign sign in allSigns) jsonEncode(sign)]);

  final String json = '[' + jsonSigns.join(", ") + ']';
  final File file = await _getFavoriteFile();
  return file.writeAsString(json, mode: FileMode.writeOnly);
}

/// Load the favorites signs from an external file.
///
/// Note that duplicated signs are not permitted.
Future<Favorites> loadFavorites() async {
  final Favorites favorites = Favorites();

  final File file = await _getFavoriteFile();
  if (!file.existsSync()) return favorites;
  final String json = await file.readAsString();
  final List<dynamic> decodedJson = jsonDecode(json);
  for (dynamic entry in decodedJson) favorites.add(Sign.fromJson(entry));

  return favorites;
}
