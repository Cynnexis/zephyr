import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:zephyr/model/favorites.dart';
import 'package:zephyr/model/sign.dart';

Future<E> _load<E extends Set<S>, S>(
    dynamic file, E Function() constructor, S Function(Map<String, dynamic>) jsonToS) async {
  if (file is Future<File>)
    file = await file;
  else if (!(file is File))
    throw ArgumentError("file is neither a Future<File> nor a File.\nfile type: ${file.runtimeType}");

  final E elements = constructor();

  if (!file.existsSync()) return elements;
  final String json = await file.readAsString();
  final List<dynamic> decodedJson = jsonDecode(json);
  for (dynamic entry in decodedJson) elements.add(jsonToS(entry));

  return elements;
}

Future<File> _save<E extends Set<S>, S>(
    dynamic elements, dynamic file, Future<E> Function() load, bool Function(S) filter,
    {bool append = false}) async {
  if (file is Future<File>)
    file = await file;
  else if (!(file is File))
    throw ArgumentError("file is neither a Future<File> nor a File.\nfile type: ${file.runtimeType}");

  if (!(elements is Set<S>)) {
    if (elements is Iterable<S>)
      elements = Set<S>.of(elements);
    else if (elements is E)
      elements = elements.toSet();
    else
      throw ArgumentError("file is neither a Set nor an Iterable nor E.\nfile type: ${file.runtimeType}");
  }

  Set<S> allElements = Set();

  // If in "append" mode, add the elements already in the file
  if (append) {
    final E loadedElements = await load();
    allElements.addAll(loadedElements);
  }

  // Add the given elements (after adding the loaded values if `append` is true)
  allElements.addAll(elements);

  // Remove empty elements.
  allElements = allElements.where(filter).toSet();

  // Create a list that contains all the JSON values of the elements in `allElements`
  final List<String> jsonElements = List.of([for (S sub_element in allElements) jsonEncode(sub_element)]);

  final String json = '[' + jsonElements.join(", ") + ']';
  return file.writeAsString(json, mode: FileMode.writeOnly);
}

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

/// Load the favorites signs from an external file.
///
/// Note that duplicated signs are not permitted.
Future<Favorites> loadFavorites() async {
  return _load<Favorites, Sign>(_getFavoriteFile(), () => Favorites(), (mapping) => Sign.fromJson(mapping));
}

/// Save the favorite [signs] to an external file.
///
/// [signs] will be saved to an external file. If [append] is `true`, the file won't be overwritten, but the content
/// will simply be appended. If there are incomplete signs in [signs] (such as no `word` field), they won't be saved.
/// Note that duplicated elements are not permitted.
Future<File> saveFavorites(dynamic signs, {bool append = false}) async {
  return _save<Favorites, Sign>(
    signs,
    _getFavoriteFile(),
    loadFavorites,
    (sign) => sign.word != null && sign.word != '',
    append: append,
  );
}
