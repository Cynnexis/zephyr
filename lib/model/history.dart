import 'package:flutter/widgets.dart';
import 'package:zephyr/model/abstract_notifier_set.dart';
import 'package:zephyr/service/preferences.dart';

import 'keywords.dart';

/// List of keywords. It is also a [ChangeNotifier] that notifies all its listeners every time the list is
/// modified.
class History extends AbstractNotifierSet<Keywords> {
  /// Default constructors for [History].
  ///
  /// Construct a list of keywords from [keywords]. The listeners will be notify at the end.
  History([dynamic keywords]) {
    if (keywords != null) this.values = keywords;
  }

  /// Construct a copy of [History].
  History.from(History history) {
    this.values = history.values;
  }

  /// Create a [History] instance by loading the value from the internal storage. Note that this operations is
  /// asynchronous, and that the listeners will be notified if the loading operation succeeds.
  ///
  /// The [onSuccess] callback will be called if the loading operation succeeded and the values are loaded. It takes a
  /// [History] (this instance) as an argument. The [onError] will be called if an error occurred, and the error will
  /// be passed as an argument (note that if [onError] is ignored and an error occurred, the exception will be raised
  /// instead). Finally, [onComplete] will be called at the end of the operation.
  History.load([void Function(History) onSuccess, void Function(Error) onError, void Function() onComplete]) {
    loadHistory().then((history) {
      this.values = history.values;
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
