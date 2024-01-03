import 'package:core/ui_elements/buttons.dart';
import 'package:core/vehicle.dart';
import 'package:fleetcarpooling/VehicleManagamentService/vehicle_managament_service.dart';
import 'package:fleetcarpooling/pages/admin_selected_vehicle_page.dart';
import 'package:core/ui_elements/colors';
import 'package:flutter/material.dart';

class DeleteDisableForm extends StatelessWidget {
  List<Vehicle> cars = List.empty();

  DeleteDisableForm({super.key});
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
            Text("LIST ALL CARS",
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
          child: const VehicleList(),
        ),
      ),
    );
  }
}

class VehicleList extends StatelessWidget {
  const VehicleList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Vehicle>>(
      stream: getVehicles(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No vehicles available.'));
        }

        return SingleChildScrollView(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return CardWidget(vehicle: snapshot.data![index]);
            },
          ),
        );
      },
    );
  }
}

class CardWidget extends StatelessWidget {
  final Vehicle vehicle;

  const CardWidget({required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AdminSelectedVehiclePage(
                      vin: vehicle.vin,
                    )),
          );
        },
        child: Card(
          color: Colors.white,
          child: ListTile(
            leading: SizedBox(
              width: 90,
              height: 80,
              child: Image.network(
                vehicle.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              '${vehicle.brand} ${vehicle.model}',
              style: const TextStyle(color: AppColors.mainTextColor),
            ),
            subtitle: Text(
              '${vehicle.year}',
              style:
                  const TextStyle(color: AppColors.mainTextColor, fontSize: 12),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.blue),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Delete Car'),
                          content: const Text(
                              'Are you sure you want to delete this car?'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('Yes'),
                              onPressed: () {
                                deleteCar(vehicle.vin);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                IconButton(
                  icon: Icon(
                      vehicle.active ? Icons.do_not_disturb_on : Icons.add,
                      color: Colors.blue),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        if (vehicle.active == true) {
                          return AlertDialog(
                            title: const Text('Disable Car'),
                            content: const Text(
                                'Are you sure you want to disable this car?'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text('Yes'),
                                onPressed: () {
                                  disableCar(vehicle.vin, vehicle.active);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        } else {
                          return AlertDialog(
                            title: const Text('Disable Car'),
                            content: const Text(
                                'Are you sure you want to activate this car?'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text('Yes'),
                                onPressed: () {
                                  disableCar(vehicle.vin, vehicle.active);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
