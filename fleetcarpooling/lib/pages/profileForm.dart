import 'package:fleetcarpooling/ui_elements/buttons.dart';
import 'package:fleetcarpooling/ui_elements/colors';
import 'package:flutter/material.dart';

class UserProfile {
  final String firstName;
  final String lastName;
  final String email;

  UserProfile({
    required this.firstName,
    required this.lastName,
    required this.email,
  });
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late UserProfile userProfile;

  @override
  void initState() {
    super.initState();
    //mock podaci koji služe za prikaz
    userProfile = UserProfile(
      firstName: "John",
      lastName: "Doe",
      email: "john.doe@example.com",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("My Profile"),
        toolbarHeight: 70,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: Colors.black,
              height: 1.0,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Name",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: AppColors.mainTextColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "${userProfile.firstName} ${userProfile.lastName}",
              style: const TextStyle(
                  fontSize: 20,
                  color: AppColors.mainTextColor,
                  fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 16),
            const Text(
              "Email",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: AppColors.mainTextColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              userProfile.email,
              style: const TextStyle(
                  fontSize: 20,
                  color: AppColors.mainTextColor,
                  fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              child: const Divider(
                color: AppColors.backgroundColor,
              ),
            ),
            const SizedBox(height: 24),
            MyElevatedButton(
              onPressed: () {
                //implement
              },
              label: "Change password",
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MyElevatedButton(
                    onPressed: () {},
                    label: "LOG OUT",
                    backgroundColor: AppColors.backgroundColor,
                    textColor: AppColors.buttonColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
