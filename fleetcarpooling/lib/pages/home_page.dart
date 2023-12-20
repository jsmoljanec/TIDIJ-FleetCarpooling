import 'package:fleetcarpooling/Modularity/models/vehicle.dart';
import 'package:fleetcarpooling/VehicleManagamentService/vehicle_managament_service.dart';
import 'package:fleetcarpooling/pages/profileForm.dart';
import 'package:fleetcarpooling/ui_elements/colors';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  late Stream<List<Vehicle>> _vehiclesStream;

  Stream<List<Vehicle>> vehicles = getVehicles();
  void _handleSearch(String input) {
    setState(() {
      _vehiclesStream = getVehicles().map((vehicles) => vehicles
          .where((vehicle) =>
              vehicle.model.toLowerCase().contains(input.toLowerCase()))
          .toList());
    });
  }

  @override
  void initState() {
    super.initState();
    _vehiclesStream = getVehicles();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double padding2 = screenHeight * 0.02;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 25.0),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 450),
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/logo.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      width: screenWidth,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: padding2,
                            bottom: padding2,
                            left: 24,
                            right: 24),
                        child: Stack(
                          fit: StackFit.loose,
                          children: [
                            const Align(
                              alignment: Alignment.center,
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        "Thu, 26 Oct",
                                        style: TextStyle(
                                            color: AppColors.mainTextColor,
                                            fontSize: 24),
                                      ),
                                      Text(
                                        "11:00",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w100,
                                            color: AppColors.mainTextColor,
                                            fontSize: 24),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Icon(
                                        Icons.arrow_forward,
                                        color: AppColors.buttonColor,
                                      ),
                                      Text(
                                        " ",
                                        style: TextStyle(fontSize: 24),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "Fri, 27 Oct",
                                        style: TextStyle(
                                            color: AppColors.mainTextColor,
                                            fontSize: 24),
                                      ),
                                      Text(
                                        "17:30",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w100,
                                            color: AppColors.mainTextColor,
                                            fontSize: 24),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Align(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ProfilePage()),
                                    );
                                  },
                                  child: SizedBox(
                                    child:
                                        Image.asset("assets/icons/profile.png"),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: screenWidth,
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, bottom: 20),
                      child: SizedBox(
                        height: 43,
                        child: TextField(
                          controller: _searchController,
                          onChanged: _handleSearch,
                          style: const TextStyle(
                              color: AppColors.mainTextColor, fontSize: 16),
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 12.0),
                            filled: false,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: const BorderSide(
                                  color: AppColors.mainTextColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: const BorderSide(
                                color: AppColors.buttonColor,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: const BorderSide(
                                color: AppColors.buttonColor,
                              ),
                            ),
                            hintText: "Search..",
                            hintStyle: const TextStyle(
                              color: AppColors.unavailableColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w100,
                              letterSpacing: 0.5,
                            ),
                            prefixIcon: const Icon(Icons.search),
                            prefixIconColor: AppColors.mainTextColor,
                          ),
                        ),
                      ),
                    ),
                    StreamBuilder<List<Vehicle>>(
                      stream: _vehiclesStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('No vehicles available.'));
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(30.0),
                                  border: Border.all(
                                    color: AppColors.mainTextColor,
                                    width: 0.5,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: Image.network(
                                        snapshot.data![index].imageUrl,
                                        fit: BoxFit.cover,
                                        height: 122,
                                        width: 209,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          24, 20, 24, 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            snapshot.data![index].model,
                                            style: const TextStyle(
                                                color: AppColors.mainTextColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24),
                                          ),
                                          Text(
                                            snapshot.data![index].transType,
                                            style: const TextStyle(
                                                color: AppColors.mainTextColor,
                                                fontSize: 18),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
