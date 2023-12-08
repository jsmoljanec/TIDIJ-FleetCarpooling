import 'package:fleetcarpooling/Modularity/models/vehicle.dart';
import 'package:fleetcarpooling/VehicleManagamentService/vehicle_managament_service.dart';
import 'package:fleetcarpooling/ui_elements/colors';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Stream<List<Vehicle>> vehicles = getVehicles();
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double padding2 = screenHeight * 0.02;
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                width: screenWidth,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: padding2, bottom: padding2, left: 24, right: 24),
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
                        child: SizedBox(
                          child: Image.asset("icons/profile.png"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: screenWidth,
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: SizedBox(
                  height: 43,
                  child: TextField(
                    style: const TextStyle(
                        color: AppColors.mainTextColor, fontSize: 16),
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 12.0),
                      filled: false,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide:
                            const BorderSide(color: AppColors.mainTextColor),
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
              Container(
                // decoration: const BoxDecoration(
                //   image: DecorationImage(
                //     image: AssetImage('images/logo.png'),
                //     fit: BoxFit.cover,
                //   ),
                // ),
                child: StreamBuilder<List<Vehicle>>(
                  stream: getVehicles(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
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
                        return Text(snapshot.data![index].model);
                      },
                    );
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
