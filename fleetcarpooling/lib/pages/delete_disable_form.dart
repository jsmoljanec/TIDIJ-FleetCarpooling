import 'package:fleetcarpooling/Modularity/models/vehicle.dart';
import 'package:fleetcarpooling/VehicleManagamentService/vehicle_managament_service.dart';
import 'package:fleetcarpooling/ui_elements/colors';
import 'package:flutter/material.dart';

class DeleteDisableForm extends StatelessWidget {
  List<Vehicle> cars = List.empty();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: AppColors.mainTextColor),
        title: const Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(""),
            Text("Delete/disable car",
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
          child: VehicleList(),
        ),
      ),
    );
  }
}

class VehicleList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Vehicle>>(
      stream: getVehicles(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No vehicles available.'));
        }

        return SingleChildScrollView(
          child: ListView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
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

  CardWidget({required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Card(
        color: Colors.white,
        child: ListTile(
          leading: Image.network(vehicle.imageUrl),
          title: Text(
            '${vehicle.brand} ${vehicle.model}',
            style: TextStyle(color: AppColors.mainTextColor),
          ),
          subtitle: Text(
            '${vehicle.year}',
            style: TextStyle(color: AppColors.mainTextColor),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.delete, color: Colors.blue),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Delete Car'),
                        content:
                            Text('Are you sure you want to delete this car?'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text('Yes'),
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
                icon: Icon(vehicle.active ? Icons.do_not_disturb_on : Icons.add,
                    color: Colors.blue),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Disable Car'),
                        content:
                            Text('Are you sure you want to disable this car?'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text('Yes'),
                            onPressed: () {
                              disableCar(vehicle.vin, vehicle.active);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
