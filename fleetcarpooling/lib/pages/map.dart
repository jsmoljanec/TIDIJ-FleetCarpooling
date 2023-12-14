import 'package:fleetcarpooling/Modularity/models/vehicle.dart';
import 'package:fleetcarpooling/VehicleManagamentService/vehicle_managament_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fleetcarpooling/ui_elements/vehicle_controller.dart';
import 'dart:io';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late RawDatagramSocket _clientSocket;
  // final destinationIPAddress = InternetAddress("10.0.2.2");
  // final destinationIPAddress = InternetAddress("10.24.37.53");
  final destinationIPAddress = InternetAddress("192.168.174.184");

  static const port = 50001;

  late GoogleMapController mapController;
  final LatLng _center = const LatLng(46.303117, 16.324079);
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  late String locationInfo = 'Waiting for location data...';
  late String actionMessage = 'Waiting for action...';
  
  Set<Marker> markers = {};
  bool showController = false;
  late MarkerId selectedMarkerId;

  @override
  void initState() {
    connectUDP();
    updateMapWithVehicleMarkers();
    selectedMarkerId = MarkerId('');
    super.initState();
  }

  @override
Widget build(BuildContext context) {
  return MaterialApp(
    theme: ThemeData(
      useMaterial3: true,
      colorSchemeSeed: Colors.green[700],
    ),
    home: Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white, // Boja pozadine teksta
              padding: const EdgeInsets.all(8.0),
              child: Text(
                actionMessage,
                style: const TextStyle(fontSize: 18.0),
              ),
            ),
          ),
          Positioned.fill(
            top: MediaQuery.of(context).padding.top + 40.0, // Prilagodite ovu visinu prema potrebi
            child: GoogleMap(
              onMapCreated: onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 12.0,
              ),
              onTap: (_) {
                setState(() {
                  showController = false;
                  selectedMarkerId = MarkerId('');
                });
              },
              markers: markers,
            ),
          ),
          if (showController)
            VehicleController(
              onCommand: (command) {
                sendCommand(command);
              },
            ),
        ],
      ),
    ),
  );
}


  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void connectUDP() async {
    // print('Connecting to UDP server...');
    _clientSocket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
    // _clientSocket.send('Hello from Flutter'.codeUnits, destinationIPAddress, port);
    sendCommand("current-position");

    _clientSocket.listen((RawSocketEvent event) {
      if (event == RawSocketEvent.read) {
        Datagram dg = _clientSocket.receive()!;
        String message = String.fromCharCodes(dg.data);
        RegExp regExp = RegExp(r"'latitude': (\d+\.\d+), 'longitude': (\d+\.\d+)");

        var match = regExp.firstMatch(message);
        if (match != null) {
          var latitude = double.parse(match.group(1)!);
          var longitude = double.parse(match.group(2)!);
          print('$latitude, $longitude');
        }
      }
    });
  }

  void sendCommand(String command) {
    _clientSocket.send("$command ${selectedMarkerId.value}".codeUnits, destinationIPAddress, port);
    setState(() {
      setActionMessage(command);
    });
  }

  void setActionMessage(String command) {
  setState(() {
    if (command.startsWith("set-destination")) {
      actionMessage = 'Destination set.';
    } else if (command.startsWith("start")) {
      actionMessage = 'Vehicle $selectedMarkerId started ride.';
    } else if (command.startsWith("stop")) {
      actionMessage = 'Vehicle $selectedMarkerId stopped ride.';
    }
  });
}

  Marker createVehicleMarker(Vehicle vehicle) {
  return Marker(
    markerId: MarkerId(vehicle.vin),
    position: LatLng(vehicle.latitude, vehicle.longitude),
    infoWindow: InfoWindow(title: "${vehicle.brand} ${vehicle.model}"),
    onTap: () {
      setState(() {
        if (selectedMarkerId.value == vehicle.vin) {
          showController = false;
          selectedMarkerId = MarkerId('');
        } else {
          showController = true;
          selectedMarkerId = MarkerId(vehicle.vin);
        }
      });
    },
  );
}

void updateMapWithVehicleMarkers() {
  getVehicles().listen((vehicles) {
    final newMarkers = vehicles
      .where((vehicle) => vehicle.active == true)
      .map(createVehicleMarker)
      .toSet();

    if (newMarkers.isNotEmpty) {
      setState(() {
        markers = newMarkers;
      });
    }
  });
}

  void _dispose() {
    _clientSocket.close();
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }
}
