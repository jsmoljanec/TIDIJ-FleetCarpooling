import 'package:flutter_test/flutter_test.dart';
import 'package:fleetcarpooling/utils/datetime_utils.dart';

void main() {
  test('getShortWeekday returns correct value for each weekday', () {
    final dateTimeUtils = DateTimeUtils();

    final mondayShortWeekday = dateTimeUtils.getShortWeekday(DateTime(2024, 1, 27));
    expect(mondayShortWeekday, equals('Sat'));

    final tuesdayShortWeekday = dateTimeUtils.getShortWeekday(DateTime(2024, 1, 28));
    expect(tuesdayShortWeekday, equals('Sun'));

    final wednesdayShortWeekday = dateTimeUtils.getShortWeekday(DateTime(2024, 1, 29));
    expect(wednesdayShortWeekday, equals('Mon'));
  });
}