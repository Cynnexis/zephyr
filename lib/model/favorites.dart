import 'package:flutter/widgets.dart';
import 'package:zephyr/model/sign.dart';
import 'package:zephyr/service/preferences.dart';

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
