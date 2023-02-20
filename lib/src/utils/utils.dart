import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final dateFormatterProvider = Provider<DateFormat>((ref) {
  return DateFormat.MMMEd();
});

final currencyFormatterProvider = Provider<NumberFormat>((ref) {
  return NumberFormat.simpleCurrency(locale: 'en_US');
});

/// allows up to mock the date inside our test
final currentDateBuilderProvider = Provider<DateTime Function()>((ref) {
  return () => DateTime.now();
});
