import 'dart:collection';

import 'package:flutter/widgets.dart';

class Keywords extends ChangeNotifier {
  String _value = '';

  String get value => _value;

  List<String> get valueAsKeywordsList => _value.split(' ');

  UnmodifiableListView<String> get valueListView => UnmodifiableListView([_value]);

  bool get isEmpty => _value.trim().length == 0;

  void set value(dynamic newKeywords) {
    if (newKeywords == null) throw "The keywords cannot be null";

    if (newKeywords is String)
      _value = newKeywords;
    else if (newKeywords is List || newKeywords is Set)
      _value = newKeywords.map((e) => e?.toString() ?? "null").join(' ');
    else
      throw "Couldn't decipher the type of \"$newKeywords\" (type: ${newKeywords.runtimeType}).";

    notifyListeners();
  }

  Keywords([dynamic keywords = '']) {
    this.value = keywords;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Keywords && runtimeType == other.runtimeType && _value == other._value;

  @override
  int get hashCode => _value.hashCode;
}
