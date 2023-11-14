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

  String userName = '$firstLetter$newLastName';

  return userName;
}
