import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fleetcarpooling/auth/UserModel.dart' as usermod;
import 'package:fleetcarpooling/pages/changePasswordForm.dart';
import 'package:fleetcarpooling/pages/loginForm.dart';
import 'package:fleetcarpooling/ui_elements/buttons.dart';
import 'package:fleetcarpooling/ui_elements/colors';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late usermod.User userProfile = usermod.User(
    firstName: '',
    lastName: '',
    email: '',
    username: '',
    role: '',
  );

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = user.uid;

        DatabaseReference ref = FirebaseDatabase.instance.ref("Users/$uid");

        DatabaseEvent event = await ref.once();

        Map<dynamic, dynamic>? userData =
            event.snapshot.value as Map<dynamic, dynamic>?;
        setState(() {
          userProfile = usermod.User(
            firstName: userData?['firstName'] ?? '',
            lastName: userData?['lastName'] ?? '',
            email: userData?['email'] ?? '',
            username: userData?['username'] ?? '',
            role: userData?['role'] ?? '',
          );
        });
      }
    } catch (e) {
      print("Error: $e");
    }
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
          ),
        ),
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
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ChangePasswordForm();
                }));
              },
              label: "Change password",
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MyElevatedButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginForm()),
                      );
                    },
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
