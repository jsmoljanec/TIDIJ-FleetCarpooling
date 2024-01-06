import 'package:fleetcarpooling/profileService/profileService.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fleetcarpooling/auth/auth_login.dart';
import 'package:fleetcarpooling/auth/user_model.dart' as usermod;
import 'package:fleetcarpooling/auth/user_repository.dart';
import 'package:fleetcarpooling/pages/changePasswordForm.dart';
import 'package:fleetcarpooling/pages/login_form.dart';
import 'package:fleetcarpooling/ui_elements/buttons.dart';
import 'package:fleetcarpooling/ui_elements/colors';
import 'package:image_picker/image_picker.dart';

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
    profileImage: '',
    statusActivity: '',
  );
  final UserRepository userRepository = UserRepository();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      usermod.User user = await userRepository.fetchUserData();
      setState(() {
        userProfile = user;
      });
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  Future<void> selectImage() async {
    setState(() {
      isLoading = true;
    });

    ImagePicker imagePickerGallery = ImagePicker();
    XFile? file =
        await imagePickerGallery.pickImage(source: ImageSource.gallery);

    if (file != null) {
      ProfileService profileService = ProfileService();
      await profileService.addStorage(file: file);
      await fetchUserData();
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteProfileImage() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 70,
        title: const Padding(
          padding: EdgeInsets.only(top: 15.0),
          child: Text(
            "MY PROFILE",
            style: TextStyle(
                color: AppColors.mainTextColor, fontWeight: FontWeight.w400),
          ),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: CircularIconButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.black,
            height: 0.5,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              child: Stack(
                children: [
                  CircleAvatar(
                    backgroundImage: userProfile.profileImage != ''
                        ? NetworkImage(userProfile.profileImage)
                        : null,
                    backgroundColor: Colors.white,
                    radius: 65,
                    child: userProfile.profileImage == ''
                        ? Image.asset("assets/images/profileImage.png")
                        : null,
                  ),
                  if (isLoading)
                    const Positioned.fill(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo),
                      color: Colors.grey,
                    ),
                  ),
                  if (userProfile.profileImage != '')
                    Positioned(
                      bottom: -10,
                      child: IconButton(
                        onPressed: deleteProfileImage,
                        icon: const Icon(Icons.delete),
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
            const Text(
              "Name",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: AppColors.mainTextColor,
              ),
            ),
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
            Text(
              userProfile.email,
              style: const TextStyle(
                  fontSize: 20,
                  color: AppColors.mainTextColor,
                  fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 24),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 0.0),
              child: const Divider(
                color: AppColors.backgroundColor,
              ),
            ),
            const SizedBox(height: 20),
            MyElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const ChangePasswordForm(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.easeInOut;
                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);
                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                  ),
                );
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
                      AuthLogin().updateOnlineStatus(
                          FirebaseAuth.instance.currentUser?.uid, "offline");
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginForm()),
                        (route) => false,
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
