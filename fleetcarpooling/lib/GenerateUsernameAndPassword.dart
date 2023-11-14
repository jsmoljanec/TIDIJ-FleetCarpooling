import 'dart:math';

String generateUsername(String firstName, String lastName) {
  String firstLetter = firstName.substring(0, 1).toLowerCase();

  Map<String, String> change = {
    'š': 's',
    'č': 'c',
    'ć': 'c',
    'đ': 'dj',
    'ž': 'z'
  };

  String newLastName = lastName.toLowerCase();
  change.forEach((key, value) {
    newLastName = newLastName.replaceAll(key, value);
  });
  int year = DateTime.now().year % 100;
  String userName = '$firstLetter$newLastName$year';

  return userName;
}
