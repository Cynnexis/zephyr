import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zephyr/model/sign.dart';
import 'package:zephyr/page/favorite_page.dart';

/// List of favorites signs. It is also a [ChangeNotifier] that notifies all its listeners every time the list is
/// modified.
class Favorites extends ChangeNotifier {
  Set<Sign> _values = Set();

  //region PROPERTIES

  int get length => _values.length;

  bool get isEmpty => length == 0;

  List<Sign> get values => List.unmodifiable(_values);

  void set values(dynamic signs) {
    if (signs == null) throw "signs cannot be null.";

    int oldHash = _values.hashCode;
    if (signs is Set<Sign>)
      _values = signs;
    else if (signs is Iterable<Sign>)
      _values = Set<Sign>.of(signs);
    else
      throw TypeError();

    // Notify listeners only if the hash of the set has changed
    if (_values.hashCode != oldHash) notifyListeners();
  }

  //endregion

  //region CONSTRUCTORS

  /// Default constructors for [Favorites].
  ///
  /// Construct a list of favorites signs from [signs]. The listeners will be notify at the end.
  Favorites([dynamic signs]) {
    if (signs != null) this.values = signs;
  }

  /// Construct a copy of [favorites].
  Favorites.from(Favorites favorites) {
    this.values = favorites.values;
  }

  /// Create a [Favorites] instance by loading the value from the internal storage. Note that this operations is
  /// asynchronous, and that the listeners will be notified if the loading operation succeeds.
  ///
  /// The [onSuccess] callback will be called if the loading operation succeeded and the values are loaded. It takes a
  /// [Favorites] (this instance) as an argument. The [onError] will be called if an error occurred, and the error will
  /// be passed as an argument (note that if [onError] is ignored and an error occurred, the exception will be raised
  /// instead). Finally, [onComplete] will be called at the end of the operation.
  Favorites.load([void Function(Favorites) onSuccess, void Function(Error) onError, void Function() onComplete]) {
    loadFavorites().then((fav) {
      this.values = fav.values;
      if (onSuccess != null) onSuccess(this);
    }).catchError((e) {
      if (onError != null)
        onError(e);
      else
        throw e;
    }).whenComplete(() {
      if (onComplete != null) onComplete();
    });
  }

  //endregion

  bool add(Sign sign) {
    if (sign == null) throw "sign cannot be null";
    bool result = _values.add(sign);
    if (result) notifyListeners();

    return result;
  }

  void addAll(Iterable<Sign> signs) {
    for (Sign sign in signs) add(sign);
  }

  void clear() {
    if (length > 0) {
      _values.clear();
      notifyListeners();
    }
  }

  bool contains(Sign sign) => _values.contains(sign);

  bool remove(Sign sign) {
    bool result = _values.remove(sign);
    if (result) notifyListeners();

    return result;
  }
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
      signs = Set<Sign>.of(signs.values);
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
