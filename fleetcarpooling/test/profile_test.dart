import 'package:fleetcarpooling/pages/profile_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fleetcarpooling/auth/user_model.dart';
import 'package:fleetcarpooling/auth/user_repository.dart';

void main() {
  late UserRepository userRepository;

  setUp(() {
    userRepository = UserRepository();
  });

  test('userProfile is initialized with default values', () {
    late User userProfile;

    userProfile = User(
      firstName: '',
      lastName: '',
      email: '',
      username: '',
      role: '',
      profileImage: '',
      statusActivity: '',
    );

    expect(userProfile.firstName, '');
    expect(userProfile.lastName, '');
    expect(userProfile.email, '');
    expect(userProfile.username, '');
    expect(userProfile.role, '');
    expect(userProfile.profileImage, '');
    expect(userProfile.statusActivity, '');
  });

  test('userRepository is initialized', () {
    expect(userRepository, isNotNull);
  });

  testWidgets('ProfilePage has a title', (WidgetTester tester) async {

    await tester.pumpWidget(MaterialApp(
      home: ProfilePage(),
    ));

    await tester.pumpAndSettle();
    expect(find.text('MY PROFILE'), findsOneWidget);
  });
}
