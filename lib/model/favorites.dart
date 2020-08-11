import 'package:flutter/widgets.dart';
import 'package:notifiable_iterables/notifiable_iterables.dart';
import 'package:zephyr/model/sign.dart';
import 'package:zephyr/service/preferences.dart';

/// List of favorites signs. It is also a [ChangeNotifier] that notifies all its listeners every time the list is
/// modified.
class Favorites extends NotifiableSet<Sign> {
  /// Default constructors for [Favorites].
  ///
  /// Construct a list of favorites signs from [signs]. The listeners will be notify at the end.
  Favorites([dynamic signs]) {
    if (signs != null) addAll(signs);
  }

  /// Construct a copy of [favorites].
  Favorites.from(Favorites favorites) {
    addAll(favorites);
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
      clear();
      addAll(fav);
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
}
