import 'package:rxdart/rxdart.dart';

class InMemoryStore<T> {
  InMemoryStore(T initial) : _subject = BehaviorSubject<T>.seeded(initial);

  /// subject holding the dats
  final BehaviorSubject<T> _subject;

  /// output stream that can be used to listen to the data
  Stream<T> get stream => _subject.stream;

  /// synchronously get the current value
  T get value => _subject.value;

  /// setter for updating the data
  set value(T newValue) => _subject.add(newValue);

  /// dispose the subject
  void close() => _subject.close();
}
