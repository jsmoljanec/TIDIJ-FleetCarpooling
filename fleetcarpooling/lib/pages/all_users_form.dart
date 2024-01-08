import 'package:fleetcarpooling/auth/user_model.dart';
import 'package:fleetcarpooling/auth/user_repository.dart';
import 'package:fleetcarpooling/ui_elements/buttons.dart';
import 'package:fleetcarpooling/ui_elements/colors';
import 'package:fleetcarpooling/ui_elements/custom_toast.dart';
import 'package:flutter/material.dart';

class AllUsersForm extends StatefulWidget {
  const AllUsersForm({Key? key}) : super(key: key);

  @override
  _AllUsersFormState createState() => _AllUsersFormState();
}

class _AllUsersFormState extends State<AllUsersForm> {
  late List<User> users;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    users = List.empty();
  }

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
            const EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 20),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration: const InputDecoration(
                labelText: 'Search..',
                labelStyle: TextStyle(color: AppColors.mainTextColor),
                prefixIcon: Icon(Icons.search, color: AppColors.mainTextColor),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color:
                        AppColors.mainTextColor, // Set the border color to blue
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors
                        .mainTextColor, // Set the focused border color to blue
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                color: Colors.white,
                child: UsersList(searchQuery: searchQuery),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UsersList extends StatelessWidget {
  final UserRepository _userRepository = UserRepository();
  final String searchQuery;

  UsersList({Key? key, required this.searchQuery}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<User>>(
      stream: _userRepository.getUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No users in the database.'));
        }

        var filteredUsers = snapshot.data!
            .where((user) =>
                user.firstName.toLowerCase().contains(searchQuery) ||
                user.lastName.toLowerCase().contains(searchQuery))
            .toList();

        return SingleChildScrollView(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: filteredUsers.length,
            itemBuilder: (context, index) {
              return CardWidget(user: filteredUsers[index]);
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 10);
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
    final UserRepository _userRepository = UserRepository();

    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        side: BorderSide(
          color: AppColors.mainTextColor,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
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
              margin: EdgeInsets.symmetric(horizontal: 20),
              height: 1,
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
                        decoration: const BoxDecoration(
                          color: AppColors.backgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
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
                                    _userRepository
                                        .deleteUser(user.email)
                                        .then((value) {
                                      Navigator.of(context).pop();
                                      if (value == true) {
                                        CustomToast().showFlutterToast(
                                            "You succesfully deleted user");
                                      } else {
                                        CustomToast().showFlutterToast(
                                            "Something went wrong, it wasnt possible to delete user");
                                      }
                                    });
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
                alignment: Alignment.center,
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
