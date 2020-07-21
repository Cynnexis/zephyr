import 'dart:collection';

import 'package:flutter/widgets.dart';

class Keywords extends ChangeNotifier {
  String _value = '';

  String get value => _value;

  List<String> get valueAsKeywordsList => _value.split(' ');

  UnmodifiableListView<String> get valueListView => UnmodifiableListView([_value]);

  bool get isEmpty => _value.trim().length == 0;

  void set value(dynamic newKeywords) {
    if (newKeywords == null) throw ArgumentError.notNull("keywords");

    int oldHash = _value.hashCode;
    if (newKeywords is String)
      _value = newKeywords;
    else if (newKeywords is Iterable)
      _value = newKeywords.map((e) => e?.toString() ?? "null").join(' ');
    else
      throw "Couldn't decipher the type of \"$newKeywords\" (type: ${newKeywords.runtimeType}).";

    // Notify listeners only if value changed
    if (oldHash != _value.hashCode) notifyListeners();
  }

  Keywords([dynamic keywords = '']) {
    this.value = keywords;
  }

  void clear() => value = '';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Keywords && runtimeType == other.runtimeType && _value == other._value;

  @override
  int get hashCode => _value.hashCode;
}
