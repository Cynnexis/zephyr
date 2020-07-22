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

  /// Check if the given [string] is contained in the keywords.
  ///
  /// If a non-null [separator] is given, [string] will be split and every bit will be tested against the keywords.
  /// If [trim] is `true`, both the keywords and [string] will be trimmed (the spaces around the strings will be
  /// removed), and if [lower] is `true`, both strings will be converted into lower cases
  bool contains(final String string,
      {final Pattern separator = null, final bool trim = false, final bool lower = false}) {
    String a = _value;
    String b = string;

    if (trim) {
      a = a.trim();
      b = b.trim();
    }

    if (lower) {
      a = a.toLowerCase();
      b = b.toLowerCase();
    }

    if (separator == null)
      return a.contains(b);
    else
      for (final String word in b.split(separator)) {
        if (a.contains(word) || word.contains(a)) return true;
      }
    return false;
  }

  /// Test if [string] matches the keywords.
  ///
  /// It is identical to [contains], but with `separator = ' '`, `trim = true`
  /// and `lower = true`.
  bool matches(final String string) => contains(string, separator: ' ', trim: true, lower: true);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Keywords && runtimeType == other.runtimeType && _value == other._value;

  @override
  int get hashCode => _value.hashCode;
}
