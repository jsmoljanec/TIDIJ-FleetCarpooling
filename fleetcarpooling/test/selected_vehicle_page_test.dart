import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart'; 

void main() {

  test('_formatDate test', () {
    expect(_formatDate('2022-01-15'), '2022-01-15');
    expect(_formatDate('2023-05-02'), '2023-05-02');
  });

  test('_formatTime test', () {
    expect(_formatTime('2022-01-15 08:30'), '08:30');
    expect(_formatTime('2023-05-02 15:45'), '15:45');
  });

  test('_formatNumber test', () {
    expect(_formatNumber(5), '05');
    expect(_formatNumber(12), '12');
    expect(_formatNumber(0), '00');
    expect(_formatNumber(9), '09');
  });
}

String _formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('yyyy-MM-dd').format(parsedDate);
  }

  String _formatTime(String time) {
    DateTime parsedTime = DateFormat('yyyy-MM-dd HH:mm').parse(time);
    return DateFormat('HH:mm').format(parsedTime);
  }

String _formatNumber(int number) {
    return number.toString().padLeft(2, '0');
  }
