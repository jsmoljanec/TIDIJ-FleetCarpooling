import 'package:fleetcarpooling/auth/user_model.dart';
import 'package:fleetcarpooling/auth/user_repository.dart';
import 'package:fleetcarpooling/ui_elements/buttons.dart';
import 'package:fleetcarpooling/ui_elements/colors';
import 'package:fleetcarpooling/ui_elements/custom_toast.dart';
import 'package:flutter/material.dart';

class AllUsersForm extends StatelessWidget {
  List<User> users = List.empty();

  AllUsersForm({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: CircularIconButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: const Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "ALL USERS",
              style: TextStyle(color: AppColors.mainTextColor, fontSize: 25.0),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(right: 10, left: 10, top: 20, bottom: 20),
        child: Container(
          color: Colors.white,
          child: UsersList(),
        ),
      ),
    );
  }
}

class UsersList extends StatelessWidget {
  final UserRepository _userRepository = UserRepository();

  UsersList({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<User>>(
      stream: _userRepository.getUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No users is database.'));
        }

        return SingleChildScrollView(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return CardWidget(user: snapshot.data![index]);
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                  height: 10); // Postavite željeni razmak između kartica
            },
          ),
        );
      },
    );
  }
}

class CardWidget extends StatelessWidget {
  final User user;

  const CardWidget({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: const BorderSide(
          color: AppColors.mainTextColor,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
                height: 10), // Postavite željeni razmak između elemenata
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: user.profileImage.isNotEmpty
                      ? NetworkImage(user.profileImage)
                      : const AssetImage(
                              'assets/images/profile_image_placeholder.jpg')
                          as ImageProvider,
                ),
                const SizedBox(width: 10),
                Text(
                  '${user.firstName} ${user.lastName}',
                  style: const TextStyle(
                    fontSize: 20,
                    color: AppColors.mainTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  user.role,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.mainTextColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              height: 1, // Visina linije
              color: AppColors.mainTextColor,
            ),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundColor,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Padding(
                              padding: EdgeInsets.fromLTRB(80, 28, 80, 28),
                              child: Text(
                                'ARE YOU SURE?',
                                style: TextStyle(
                                  color: AppColors.mainTextColor,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                            const Divider(
                              height: 0.5,
                              color: AppColors.mainTextColor,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();

                                    CustomToast().showFlutterToast(
                                        "You succesfully deleted user");
                                  },
                                  child: const Padding(
                                    padding:
                                        EdgeInsets.only(top: 20, bottom: 20),
                                    child: Text(
                                      'YES',
                                      style: TextStyle(
                                        color: AppColors.mainTextColor,
                                        fontSize: 24,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 70,
                                  width: 0.5,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColors.mainTextColor)),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Padding(
                                    padding:
                                        EdgeInsets.only(top: 20, bottom: 20),
                                    child: Text(
                                      'NO',
                                      style: TextStyle(
                                        color: AppColors.mainTextColor,
                                        fontSize: 24,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                alignment: Alignment
                    .center, // Dodajte ovu liniju za centriranje teksta
                child: const Text(
                  'Delete User',
                  style: TextStyle(
                      fontSize: 20,
                      color: AppColors.mainTextColor,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
