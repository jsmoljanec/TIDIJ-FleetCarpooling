import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late RawDatagramSocket _clientSocket;
  final destinationIPAddress = InternetAddress("10.0.2.2");
  static const port = 50001;

  late GoogleMapController mapController;
  final LatLng _center = const LatLng(46.303117, 16.324079);
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  late String locationInfo = 'Waiting for location data...';
  
  Set<Marker> markers = {};

  @override
  void initState() {
    connectUDP();
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
        body: GoogleMap(
          onMapCreated: onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
          markers: markers,
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
    sendCommand("current position");

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

          setState(() {
            locationInfo = 'Latitude: $latitude, Longitude: $longitude';
            markers = {
              Marker(
                markerId: const MarkerId('vehicle'),
                position: LatLng(latitude, longitude),
                infoWindow: const InfoWindow(title: 'Vehicle Location'),
                icon: markerIcon,
              ),
            };
          });
        }
      }
    });
  }

  void sendCommand(String command) {
    _clientSocket.send(command.codeUnits, destinationIPAddress, port);
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
