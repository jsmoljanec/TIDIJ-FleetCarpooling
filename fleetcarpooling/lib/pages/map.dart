import 'package:fleetcarpooling/Modularity/models/vehicle.dart';
import 'package:fleetcarpooling/VehicleManagamentService/vehicle_managament_service.dart';
import 'package:fleetcarpooling/handlers/udp_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fleetcarpooling/ui_elements/vehicle_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(46.303117, 16.324079);
  late String actionMessage = 'Waiting for action...';

  Set<Marker> markers = {};
  bool showController = false;
  late MarkerId selectedMarkerId;

  static const port = 50001;
  late UDPManager udpManager;
  late BitmapDescriptor icon;

  late String flagContent;
  late String vehicleIdContent;

  @override
  void initState() {
    String deviceIpAddress = const String.fromEnvironment('DEVICE_IP_ADDRESS');
    String finalIpAddress =
        deviceIpAddress.isNotEmpty ? deviceIpAddress : "10.0.2.2";
    udpManager = UDPManager(
      finalIpAddress,
      port,
      udpMessageHandler: (message) {
        RegExp bracketsRegExp = RegExp(r'\[([^\]]*)\]');
        Iterable<RegExpMatch> matches = bracketsRegExp.allMatches(message);

        if (matches.isNotEmpty) {
          flagContent = matches.elementAt(0).group(1) ?? '';
          vehicleIdContent =
              matches.length > 1 ? matches.elementAt(1).group(1) ?? '' : '';
          showToast(
              message, flagContent, vehicleIdContent, selectedMarkerId.value);
        } else {
          print('Uglate zagrade nisu pronađene u tekstu.');
        }
      },
    );
    udpManager.connectUDP();
    updateMapWithVehicleMarkers();
    selectedMarkerId = const MarkerId('');
    getIcons();
    super.initState();
  }

  getIcons() async {
    var icon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "assets/icons/vehicle_icon90.png");
    setState(() {
      this.icon = icon;
    });
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
            Positioned.fill(
              child: GoogleMap(
                onMapCreated: onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 12.0,
                ),
                onTap: (_) {
                  setState(() {
                    showController = false;
                    selectedMarkerId = const MarkerId('');
                  });
                },
                markers: markers,
              ),
            ),
            if (showController)
              VehicleController(onCommand: (command) {
                udpManager.sendCommand(command, selectedMarkerId);
              }),
          ],
        ),
      ),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Marker createVehicleMarker(Vehicle vehicle) {
    return Marker(
      icon: icon,
      markerId: MarkerId(vehicle.vin),
      position: LatLng(vehicle.latitude, vehicle.longitude),
      infoWindow: InfoWindow(title: "${vehicle.brand} ${vehicle.model}"),
      onTap: () {
        setState(() {
          if (selectedMarkerId.value == vehicle.vin) {
            showController = false;
            selectedMarkerId = const MarkerId('');
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

  void showToast(String message, String flagContent, String vehicleIdContent,
      String selectedMarkerId) {
    if (flagContent == "0000") {
      return;
    }

    if (vehicleIdContent == selectedMarkerId) {
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
