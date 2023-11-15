class User {
  late String username;
  late String email;
  late String firstName;
  late String lastName;
  late String role;

  User({
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        username: map['username'],
        email: map['email'],
        firstName: map['firstName'],
        lastName: map['lastName'],
        role: map['role']);
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
    };
  }
}
