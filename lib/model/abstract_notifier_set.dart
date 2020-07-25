import 'package:flutter/widgets.dart';

abstract class AbstractNotifierSet<E> extends ChangeNotifier implements Set<E> {
  Set<E> _values = Set();

  //region PROPERTIES

  int get length => _values.length;

  bool get isEmpty => length == 0;

  List<E> get values => List.unmodifiable(_values);

  void set values(dynamic elements) {
    if (elements == null) throw "elements cannot be null.";

    int oldHash = _values.hashCode;
    if (elements is Set<E>)
      _values = elements;
    else if (elements is Iterable<E>)
      _values = Set<E>.of(elements);
    else
      throw TypeError();

    // Notify listeners only if the hash of the set has changed
    if (_values.hashCode != oldHash) notifyListeners();
  }

  //endregion

  @override
  bool add(E element) {
    if (element == null) throw "element cannot be null";
    bool result = _values.add(element);
    if (result) notifyListeners();

    return result;
  }

  @override
  void addAll(Iterable<E> elements) {
    for (E element in elements) add(element);
  }

  @override
  void clear() {
    if (length > 0) {
      _values.clear();
      notifyListeners();
    }
  }

  @override
  bool contains(Object E) => _values.contains(E);

  @override
  bool remove(Object E) {
    bool result = _values.remove(E);
    if (result) notifyListeners();

    return result;
  }

  @override
  void forEach(void Function(E element) f) {
    _values.forEach(f);
    notifyListeners();
  }

  @override
  void retainWhere(bool test(E element)) {
    _values.retainWhere(test);
    notifyListeners();
  }

  @override
  void removeWhere(bool test(E element)) {
    _values.removeWhere(test);
    notifyListeners();
  }

  @override
  void retainAll(Iterable<Object> elements) {
    _values.retainAll(elements);
    notifyListeners();
  }

  @override
  void removeAll(Iterable<Object> elements) {
    _values.removeAll(elements);
    notifyListeners();
  }

  //region SET OVERRIDES

  @override
  Set<E> toSet() => Set<E>.of(_values);

  @override
  Set<E> difference(Set<Object> other) => _values.difference(other);

  @override
  Set<E> union(Set<E> other) => _values.union(other);

  @override
  Set<E> intersection(Set<Object> other) => _values.intersection(other);

  @override
  bool containsAll(Iterable<Object> other) => _values.containsAll(other);

  @override
  E lookup(Object object) => _values.lookup(object);

  @override
  Iterator<E> get iterator => _values.iterator;

  @override
  Set<R> cast<R>() => _values.cast<R>();

  @override
  bool any(bool Function(E element) test) => _values.any(test);

  @override
  E elementAt(int index) => _values.elementAt(index);

  @override
  bool every(bool Function(E element) test) => _values.every(test);

  @override
  Iterable<T> expand<T>(Iterable<T> Function(E element) f) => _values.expand<T>(f);

  @override
  E get first => _values.first;

  @override
  E firstWhere(bool Function(E element) test, {E Function() orElse}) => _values.firstWhere(test, orElse: orElse);

  @override
  T fold<T>(T initialValue, T Function(T previousValue, E element) combine) => _values.fold<T>(initialValue, combine);

  @override
  Iterable<E> followedBy(Iterable<E> other) => _values.followedBy(other);

  @override
  bool get isNotEmpty => _values.isNotEmpty;

  @override
  String join([String separator = ""]) => _values.join(separator);

  @override
  E get last => _values.last;

  @override
  E lastWhere(bool Function(E element) test, {E Function() orElse}) => _values.lastWhere(test, orElse: orElse);

  @override
  Iterable<T> map<T>(T Function(E e) f) => _values.map<T>(f);

  @override
  E reduce(E Function(E value, E element) combine) => _values.reduce(combine);

  @override
  E get single => _values.single;

  @override
  E singleWhere(bool Function(E element) test, {E Function() orElse}) => _values.singleWhere(test, orElse: orElse);

  @override
  Iterable<E> skip(int count) => _values.skip(count);

  @override
  Iterable<E> skipWhile(bool Function(E value) test) => _values.skipWhile(test);

  @override
  Iterable<E> take(int count) => _values.take(count);

  @override
  Iterable<E> takeWhile(bool Function(E value) test) => _values.takeWhile(test);

  @override
  List<E> toList({bool growable = true}) => List.unmodifiable(_values);

  @override
  Iterable<E> where(bool Function(E element) test) => _values.where(test);

  @override
  Iterable<T> whereType<T>() => _values.whereType<T>();

  //endregion
}
