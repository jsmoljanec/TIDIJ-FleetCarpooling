import 'package:fleetcarpooling/Modularity/models/vehicle.dart';
import 'package:fleetcarpooling/VehicleManagamentService/vehicle_managament_service.dart';
import 'package:fleetcarpooling/ui_elements/colors';
import 'package:flutter/material.dart';

class DeleteDisableForm extends StatelessWidget {
  List<Vehicle> cars = List.empty();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
                  style: TextStyle(
                      color: AppColors.mainTextColor, fontSize: 25.0)),
            ],
          ),
          centerTitle: true,
        ),
        body: Container(
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

        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            return CardWidget(vehicle: snapshot.data![index]);
          },
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
    return Card(
      color: AppColors.backgroundColor,
      child: ListTile(
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.delete, color: Colors.blue),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(vehicle.active ? Icons.do_not_disturb_on : Icons.add,
                  color: Colors.blue),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
