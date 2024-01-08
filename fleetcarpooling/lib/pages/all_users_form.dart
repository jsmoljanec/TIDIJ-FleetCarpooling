import 'package:fleetcarpooling/Modularity/models/vehicle.dart';
import 'package:fleetcarpooling/VehicleManagamentService/vehicle_managament_service.dart';
import 'package:fleetcarpooling/auth/user_model.dart';
import 'package:fleetcarpooling/auth/user_repository.dart';
import 'package:fleetcarpooling/ui_elements/buttons.dart';
import 'package:fleetcarpooling/ui_elements/colors';
import 'package:flutter/material.dart';

class AllUsersForm extends StatelessWidget {
  List<User> users = List.empty();
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
            Text("Here you can manage all users",
                style:
                    TextStyle(color: AppColors.mainTextColor, fontSize: 25.0)),
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
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<User>>(
      stream: _userRepository.getUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No users is database.'));
        }

        return SingleChildScrollView(
          child: ListView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return CardWidget(user: snapshot.data![index]);
            },
          ),
        );
      },
    );
  }
}

class CardWidget extends StatelessWidget {
  final User user;

  CardWidget({required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: user.profileImage.isNotEmpty ? NetworkImage(user.profileImage) : const AssetImage('assets/images/profile_image_placeholder.jpg') as ImageProvider,
          ),
          title: Text(
            user.firstName + ' ' + user.lastName,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            user.email,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
            ],
          ),
        ),
      ),
    );
  }
}
